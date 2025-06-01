// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TransferToken {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;

    // 构造函数，初始化代币信息
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply; // 初始代币都分配给合约创建者
    }

    // 转账函数
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "\u4F59\u989D\u4E0D\u8DB3"); //余额不足
        require(_to != address(0), "\u4E0D\u80FD\u8F6C\u8D26\u5230\u96F6\u5730\u5740"); // 不能转账到零地址
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // 转账事件
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}    