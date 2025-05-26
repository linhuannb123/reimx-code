// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

// call to Parent.foo
// [call]from: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// to: Parent.foo()data: 0xc29...85578
// console.log:
// foo parent
contract Parent {
    constructor() {
        console.log("Parent");
    }

    function foo() virtual pure public  {
        console.log("foo parent");
    } 
}

// call to Base1.foo
// [call]from: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// to: Base1.foo()data: 0xc29...85578
// console.log:
// foo base1
contract Base1 is Parent {
    constructor(){
        console.log('Base1');
    }

    function foo() override virtual pure public {
        console.log('foo base1');
    }
}

// call to Base2.foo
// [call]from: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// to: Base2.foo()data: 0xc29...85578
// console.log:
// foo base2
contract Base2 is Parent {
    constructor(){
        console.log("Base2");
    }

    function foo() override virtual pure public {
        console.log("foo base2");
    }
}

// call to Inherited.foo
// [call]from: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4to: Inherited.foo()data: 0xc29...85578
// console.log:
// foo
// foo base1
contract Inherited is Base2,Base1 {
    constructor(){
        console.log("Inherited");
    }

    function foo() override(Base1,Base2) pure public {
        console.log("foo");
        super.foo();
    }
}