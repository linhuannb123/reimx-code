// SPDX - License - Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

contract Called {
    function balance() external view returns (uint256) {
        return address(this).balance; // 显式返回合约余额
    }
    // 不加receive transfer、call转币失败，send 成功了 ，但是 balace -> 0 说明send看上去成功了，实际下游失败了
    
    receive() external payable {
        // 我在这行添加打印当前调用的地址  
        // call 成功了 transfer和send失败了这是什么原因？
        // 假如我只有3wei，执行这个代码需要支付2300wei,transfer和send方法会失败是因为这3wei
        // 不足已支付gas的消费，所有导致它们执行失败，但是使用call方法，它把剩余的gas全部给到
        // receive方法去,才能执行成功
        // 它支付3Wei也能成功
        // transfer和send方法它会转2300gas抛异常，call它会将全部gas或指定gas转给下游，返回一个bool值
        console.log(address(this)); 
    }
}

contract Caller {
    address payable called;
    constructor(address payable to) {
        called = to;
    }
    // send 和 transfer的区别
    // send转币是有返回值的，需要断言去判断返回值
    // trnsfer转币不需要判断返回值，它直接返回
    function sender() external payable {
       bool result = called.send(3);
       require(result);
    }

    function transfer() external payable {
        called.transfer(3);
    }

    function call() external payable {
        (bool result, bytes memory data) = called.call{value: 3}("");
        require(result);
    }
}
