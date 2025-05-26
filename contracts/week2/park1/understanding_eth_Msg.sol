// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 导入 Hardhat 控制台日志库，仅用于开发和测试环境
import "hardhat/console.sol";

/**
 * @title CallMsg
 * @dev 演示 msg 对象属性的合约，展示不同调用方式下的消息数据差异
 */
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// 100
// 0x7eecd3b6
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// 0xE159BbF8e8543FEe9A80B3b485493aAc04c9BafC
// EOA -> CallMsg
// 普通调用
contract CallMsg {
    /**
     * @dev 记录并展示当前调用的消息属性
     * @notice 此函数会记录发送者地址、发送的以太币数量、调用数据、交易发起者和合约自身地址
     * @dev 注意：msg.sender 是直接调用者，而 tx.origin 始终是原始交易发起者
     */
    function msgFrom() external payable {
        console.logAddress(msg.sender); // 打印直接调用者的账户地址: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        console.logUint(msg.value); // 打印随调用发送的以太币数量（以 wei 为单位）100Wei
        console.logBytes(msg.data); // 打印调用数据（即函数选择器和编码参数） 0x7eecd3b6
        console.logAddress(tx.origin); // 打印原始交易发起者地址  0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        console.logAddress(address(this)); // 打印当前合约地址 0xE159BbF8e8543FEe9A80B3b485493aAc04c9BafC

        // 以下代码用于后续课程演示
        // console.logBytes4(CallMsg.msgFrom.selector);
        // console.logBytes(abi.encodeWithSignature("msgFrom()"));
        // console.logBytes4(bytes4(keccak256("msgFrom()")));
    }
}

/**
 * @title CallContract
 * @dev 通过代理调用演示不同调用方式的合约
 * @notice 该合约持有对 CallMsg 合约的引用，并通过常规调用方式触发其函数
 */

// 它与CallMsg比较
// 0xcF037f9f75F35362Fc21e4CA879C8281AB53C39A   已变化   更改成CallContract合约地址 msg.sender = B.address
// 0             已变化 A.value = 1eth   B.value = 0       callcontract合约账号的余额：一开始没传为0  msg.value = B.value                
// 0x7eecd3b6  调用方法不变
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4  // 发送的源头地址不变
// 0xE159BbF8e8543FEe9A80B3b485493aAc04c9BafC  // 当前合约地址不变
// EOA -> CallContract -> CallMsg
// 普通合约调用
contract CallContract {
    CallMsg call;

    /**
     * @dev 构造函数，初始化对目标 CallMsg 合约的引用
     * @param _call CallMsg 合约的地址
     */
    constructor(CallMsg _call) {
        call = _call;
    }

    /**
     * @dev 通过常规调用方式调用 CallMsg 合约的 msgFrom 函数
     * @notice 此调用会改变执行上下文，msg.sender 将是本合约地址
     */
    function callContract() external payable {
        call.msgFrom();
    }
}

/**
 * @title CallDelegate
 * @dev 通过 delegatecall 演示上下文保持的合约调用
 * @notice 该合约使用 delegatecall 调用目标合约，执行代码时保持当前合约的上下文
 */
// 它与CallContract比较
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4  已变化 msg.sender = A.address
// 1000000000000000000      已变化 msg.value = A.value
// 0x7eecd3b6    调用的方法不变
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4   源头地址不变
// 0xFd33eca8D6411f405637877c9C7002D321182937   当前合约地址变成CallDelegate合约地址 
// EOA -> CallDelegate -> CallMsg
// 代理调用
contract CallDelegate {
    CallMsg call;

    /**
     * @dev 构造函数，初始化对目标 CallMsg 合约的引用
     * @param _call CallMsg 合约的地址
     */
    constructor(CallMsg _call) {
        call = _call;
    }

    /**
     * @dev 通过 delegatecall 调用 CallMsg 合约的 msgFrom 函数
     * @notice delegatecall 保持当前合约的上下文（存储、余额等），但执行目标合约的代码
     * @dev 注意：delegatecall 的返回值处理和错误处理
     */
    function delegateCall() external payable {
        (bool _r, ) = address(call).delegatecall(abi.encodeWithSignature("msgFrom()"));
        require(_r, "Delegate call failed");
    }
}