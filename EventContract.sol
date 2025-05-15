
//  SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

contract EventContract {
    // 定义一个事件，当值被设置时触发
    event ValueSet(address indexed setter,uint256 newValue);

    uint256 public value;
    // 设置值的函数，调用是触发ValueSet事件
    function setValue(uint _newValue) public {
        value = _newValue;
        emit ValueSet(msg.sender,_newValue);
    }
}