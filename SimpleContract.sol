// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleContract {
    // 定义一个事件
    event ValueUpdated(uint256 oldValue, uint256 newValue);

    uint256 public value;
    
    constructor(){
        value = 100;
    }

    // 设置值的函数，触发事件
    function setValue(uint256 _newValue) public {
        uint256 oldValue = value;
        value = _newValue;
        emit ValueUpdated(oldValue, _newValue);
    }

    // 获取值的函数
    function getValue() public view returns (uint256) {
        return value;
    }
}