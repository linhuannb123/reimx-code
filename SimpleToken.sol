// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleToken {
    string public name = "SimpleToken";
    string public symbol = "SIM";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    
    // 转账事件，与你代码中的监听匹配
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // 构造函数，初始化代币总量并分配给合约创建者
    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    // 转账函数
    function transfer(address to, uint256 value) public returns (bool success) {
        // require(balanceOf[msg.sender] >= value, "余额不足");
        require(balanceOf[msg.sender] >= value, "\u4F59\u989D\u4E0D\u8DB3"); // "余额不足" 的 Unicode 转义
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
}