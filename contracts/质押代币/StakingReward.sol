// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

// 质押收益合约
contract StakingRewards {
    // 声明一些基础变量

    // 质押token
    IERC20 public immutable stakingToken;
    // 收益token
    IERC20 public immutable rewardsToken;

    // 管理员
    address public owner;

    // 持续时间
    uint256 public duration;

    // 其他计算收益的时间变量
    uint256 public finishAt;

    uint256 public updatedAt;
    // 奖励速率
    uint256 public rewardRate;

    uint256 public rewardPerTokenStored;

    // 需要两个mapping来存储每个质押用户它对应的状态变量

    // 用户被质押的时候当前状态的奖励数量
    mapping(address => uint256) public userRewardPerTokenPaid;
    // 用户当前质押状态
    mapping(address => uint256) public rewards;

    //计算用户质押的数额
    mapping(address => uint256) public balanceOf;

    // 总的代币数量
    uint256 public totalSupply;

    // 质押的构造函数 两个参数：token1和token2
    constructor(address _stakingToken, address _rewardsToken) {
        //  设置管理管理，创建的合约人，只有管理员才能执行
        // msg.sender 调用者的合约账号,比如 账户0 调用该合约他就是管理员
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    // 管理员才能执行的两个modifer
    // modifier就是我们可以在函数后面去添加自己的它会自动去执行这块的内容
    // 很多需要经常频繁执行的函数来说，modifier是很方便的，比如说：这里去
    // 检查我们这个方法是不是由管理去执行
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        // 下划线表示我们执行的主体代码
        _;
    }

    // 它是用来更新当前每个用户的奖励数额的，它会我们质押和撤回，以及
    // 重新设置奖励参数的时候都会调用一下

    // updateReward主要做的操作的是更新用户奖励的状态，它会每次调用的时候都
    // 会更新rewordPerTokenStored
    modifier updateReward(address _account) {
        //  奖励的数额
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();
        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
        _;
    }

    // rewardPerToken 它计算的是每一次质押代币，它对应的奖励代币是多少
    // 它会用上一次存储的rewordPerTokenStored数值 + 奖励速率 * 时间差
    // 它是一个增量更新的逻辑
    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) return rewardPerTokenStored;

        return
            rewardPerTokenStored +
            ((rewardRate * (lastTimeRewardApplicable() - updatedAt)) * 1e18) /
            totalSupply;
    }

    function  _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return _min(block.timestamp, finishAt);
    }

    // 查看奖励收益
    function earned(address _account) public view returns (uint256) {
        return
            (balanceOf[_account] *
                (rewardPerToken() - userRewardPerTokenPaid[_account])) /
            1e18 +
            rewards[_account];
    }


    // 设置奖励持续时间的函数
    function setRewardDuration(uint256 _duration) external onlyOwner {
        // 结束时间 是否比当前时间，当前时间周期还没结束
        // 是不允许它重新设置奖励周期
        require(finishAt < block.timestamp, "reward duration not finished");
        duration = _duration;
    }

    // 计时器外部可以调用的函数 ,它只能由管理员来调用
    function notifyRewardAmount(uint256 _amount)
        external
        onlyOwner
        updateReward(address(0))
    {
        /****
         *   有两种可能：
         * 1. 当当前时间超过上一个奖励周期结束时间(`finishAt`)时，创建一个全新的奖励周期
         * 2. 当当前时间还在上一个奖励周期内时，将剩余奖励与新奖励合并计算新的分配速率
         * 更新奖励结束时间(`finishAt`)为当前时间加上持续时间(`duration`)
         * 1. 当前时间： 1600, finishAt: 1500 , amount:1000 ,duration: 1000
         *   1. rewardRate: 1000 / 1000 = 1
         * 2. 当前时间： 2000, finishAt: 2600 , amount:1000 ,duration: 1000
         *   1. remainingRewards : (2600 - 2000) * 1 = 600
         *   2. rawardRate: (600 + 1000) / 1000 = 1.6
         */
        if (block.timestamp > finishAt) {
            rewardRate = _amount / duration;
        } else {
            uint256 remainingRewards = rewardRate *
                (finishAt - block.timestamp);
            rewardRate = (remainingRewards + _amount) / duration;
        }

        require(rewardRate > 0, "reward rate = 0");
        require(
            rewardRate * duration <= rewardsToken.balanceOf(address(this)),
            "reward amount > balance"
        );

        finishAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }

    // 质押方法：就是把质押token传到合约里
    // 调用质押的时候需要更新一下奖励的一些参数
    function stake(uint256 _amount) external updateReward(msg.sender) {
        require(_amount > 0, "amount = 0");
        // 将这些代币转入到合约里面
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        // 记录当前的用户balance是多少,这个存储在合约里面
        balanceOf[msg.sender] += _amount;
        // 更新总质押金额
        totalSupply += _amount;
    }

    // 提取方法
    function withdraw(uint256 _amount) external updateReward(msg.sender) {
        require(_amount > 0, "amount = 0");
        // 记录当前的用户balance是多少,这个存储在合约里面
        balanceOf[msg.sender] -= _amount;
        // 更新总质押金额
        totalSupply -= _amount;

        stakingToken.transfer(msg.sender, _amount);
    }

    // 获取收益的函数
    function getReward() external updateReward(msg.sender) {
        // 访问用户奖励存储的数额
        uint256 reward = rewards[msg.sender];
        // 如果奖励数额大于0
        if (reward > 0) {
            rewards[msg.sender] = 0;

            rewardsToken.transfer(msg.sender, reward);
        }
    }
}
