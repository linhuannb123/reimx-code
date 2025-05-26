// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 导入 Hardhat 控制台日志库，仅用于开发和测试环境
import "https://github.com/NomicFoundation/hardhat/blob/main/packages/hardhat-core/console.sol";

/**
 * @title Called
 * @dev 演示不同调用方式对状态变量影响的目标合约
 */
// inc  ->  number = 1
// number ->  1
// setN(0) -> number = 0 (已变)
contract Called {
    uint256 public number; // 存储合约状态的变量

    /**
     * @dev 将 number 变量递增 1
     * @notice 此函数修改合约状态
     */
    function inc() external {
        ++number;
    }

    /**
     * @dev 设置 number 变量的值
     * @param _number 要设置的新值
     * @return 返回设置后的 number 值
     * @notice 此函数修改合约状态并返回新值
     */
    function setN(uint256 _number) external returns (uint256) {
        number = _number;
        return number;
    }
}

/**
 * @title Caller
 * @dev 通过不同调用方式与 Called 合约交互的合约
 * @notice 演示 call、delegatecall 和 staticcall 的区别
 */
 // EOA -> CALLER -> CALLED

// inc ->  Called.number = 1(已变Called.number+1)  Caller.number = 0;(不变)
// setN(10) -> Called.number = 10(已变) Caller.number = 0;(不变)
// number ->  0
// delegateSetN(100) -> Called.number = 10(不变) Caller.number = 100(已变)

// staticSetN() -> 0x000000000000000000000000000000000000000000000000000000000000000a (called.number = 10 不变)
contract Caller {
    uint256 public number; // 存储当前合约状态的变量
    address to; // 目标合约地址

    /**
     * @dev 构造函数，初始化目标合约地址
     * @param _to Called 合约的地址
     */
    constructor(address _to) {
        to = _to;
    }

    /**
     * @dev 通过常规 call 调用目标合约的 inc 函数
     * @notice 使用 call 调用会在目标合约上下文中执行，不会影响当前合约的状态
     */
    function inc() external {
        (bool _r, bytes memory data) = to.call(abi.encodeWithSignature("inc()"));
        require(_r, "Call to inc() failed");
        console.logBytes(data); // 输出调用返回的数据
    }

    /**
     * @dev 通过常规 call 调用目标合约的 setN 函数
     * @param _number 要设置的新值
     * @notice 使用 call 调用会在目标合约上下文中执行，不会影响当前合约的状态
     */
    function setN(uint256 _number) external {
        (bool _r, bytes memory data) = to.call(abi.encodeWithSignature("setN(uint256)", _number));
        require(_r, "Call to setN() failed");
        console.logBytes(data); // 输出调用返回的数据
    }

    /**
     * @dev 通过 delegatecall 调用目标合约的 setN 函数
     * @param _number 要设置的新值
     * @notice delegatecall 在当前合约上下文中执行目标合约代码，会修改当前合约的状态
     */
    function delegateSetN(uint256 _number) external {
        (bool _r, bytes memory data) = to.delegatecall(abi.encodeWithSignature("setN(uint256)", _number));
        require(_r, "Delegatecall to setN() failed");
        console.logBytes(data); // 输出调用返回的数据
    }

    /**
     * @dev 通过 staticcall 调用目标合约的 number 函数
     * @notice staticcall 是只读调用，禁止修改状态，即使目标函数是可写的
     */
    function staticSetN() view external {
        (bool _r, bytes memory data) = to.staticcall(abi.encodeWithSignature("number()"));
        require(_r, "Staticcall to number() failed");
        console.logBytes(data); // 输出调用返回的数据
    }
}