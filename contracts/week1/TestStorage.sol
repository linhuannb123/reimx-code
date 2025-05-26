//SPDX-License-Identifier:MIT
pragma solidity ^0.8.26;


// retreiveSlotContent(0) -> bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000084
// retreiveSlotContent(1) -> bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000000
// retreiveSlotContent(2) -> bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000000
// retreiveSlotContent(10) -> bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000000


contract TestStorage {
    uint256 a = 132;
    
    function retreiveSlotContent(uint256 index) external view returns(bytes32 content){
        assembly{
            content:=sload(index)
        }
    }
}