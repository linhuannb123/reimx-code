// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MyContract {
    uint256 public myVariable;
    constructor(uint256 initVal){
        myVariable = initVal;
    }

    function setValue(uint _myVariable) public {
        myVariable = _myVariable;
    }
}

