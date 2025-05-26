// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

contract PureView {
    uint256 _var; // 状态变量
    
    // paybale 需要配合外部使用 如：public external
    // 读取全局变量但不修改状态，应标记为view
    function showGlobalVar() payable external  {
        console.log(msg.sender);  // 打印当前调用者的地址 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        console.log(block.timestamp); // 打印当前时间戳 1748162783
        console.logUint(msg.value); // 打印值 0
    }
    // 纯函数：不读取也不修改状态用pure  将view 改成pure
    // notAccess(uint,uint) 外部读取 返回uint
    function notAccess(uint256 a, uint256 b) external pure  returns (uint256) {
        return a + b; //  1 ， 2  uint256: 3

    }
    // 视图函数：读取但不修改状态 
    // notModifiy (uint,uint) 外部读取 返回uint
    function notModifiy(uint256 a, uint256 b) external view returns (uint256){
        // 1+2+ 99999999999992867676  = 99999999999992867679
        return a + b + msg.sender.balance; // msg.sender.balance 可以获取当前发送方的余额
    }

    // 修改状态变量
    // modifiyState 外部调用
    function modifiyState()  external {
       _var++; // 加一
    }
     // 视图函数：读取状态变量
    function getValue() external view returns (uint256) {
        return  _var; // 初始值 0
    }
}