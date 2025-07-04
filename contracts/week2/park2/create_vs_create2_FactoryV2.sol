// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 导入 Hardhat 控制台日志库，仅用于开发和测试环境
// import "https://github.com/NomicFoundation/hardhat/blob/main/packages/hardhat-core/console.sol";
import "hardhat/console.sol";

contract Factory2 {

    event ContractCreated(address indexed);

    function deployV2(uint256 salt) external {
       bytes memory _bytes = abi.encodePacked(type(Demo2).creationCode,abi.encode(uint256(300)));

       address deployAddress;
       assembly {
        deployAddress :=create2(callvalue(),add(_bytes,0x20),mload(_bytes),salt)
        if iszero(extcodesize(deployAddress)){
            revert(0,0)
        }
       }
       console.logAddress(deployAddress);
       // 使用emit来触发事件
       emit ContractCreated(deployAddress);
    }

    function deployV1(uint256 salt) external {
        address _deployAddress = address(new Demo2{salt:bytes32(salt)}(300));
        console.logAddress(_deployAddress);
        emit ContractCreated(_deployAddress);
    }

    function predict(uint256 salt) external view returns (address){
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff),address(this),salt,keccak256(abi.encodePacked(type(Demo2).creationCode,abi.encode(300))))
        );
        return address(uint160(uint256(hash)));        
    }
}

contract Demo2 {
    
    uint256 public i;
    constructor(uint256 _i){
        i = _i;
    }
}