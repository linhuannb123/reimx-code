// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

// call to Parent.foo
 
// foo ->  console.log: foo parent
contract Parent {
    constructor() {
        console.log("Parent");
    }

    function foo() virtual pure public  {
        console.log("fool parent");
    } 
}

// call to Base1.foo
 
// foo ->  console.log: fool base1
contract Base1 is Parent {
    constructor(){
        console.log('Base1');
    }

    function foo() override virtual pure public {
        console.log('fool base1');
    }
}

// call to Base2.foo
 
// foo ->  console.log: fool base2
contract Base2 is Parent {
    constructor(){
        console.log("Base2");
    }

    function foo() override virtual pure public {
        console.log("fool base2");
    }
}

// call to Inherited.foo
// foo -> 
//  console.log:
//   fool
//   fool base1
contract Inherited is Base2,Base1 {
    constructor(){
        console.log("Inherited");
    }

    function foo() override(Base1,Base2) pure public {
        console.log("fool");
        super.foo();
    }
}