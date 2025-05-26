// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract LowGasERC20 {
  string public name;
  string public symbol;
  uint8 public decimals = 6; // BSC常用6位小数

  uint256 public totalSupply;
  mapping(address => uint256) public balanceOf;

  constructor(string memory _name, string memory _symbol,uint256 _totalSupply) {
    name = _name;
    symbol = _symbol;
    totalSupply = _totalSupply * 10 ** uint256(decimals);
    balanceOf[msg.sender] = _totalSupply;
  }

  // 转账合约
  function transfer(address recipient,uint256 amount ) public returns(bool) {
    // 添加余额检查
    require(balanceOf[msg.sender] >= amount,"\u4F59\u989D\u4E0D\u8DB3");
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient] += amount;
    emit Transfer(msg.sender,recipient,amount);
    return true ;
  }

  event Transfer(address indexed from , address indexed to ,uint256 value);
}
