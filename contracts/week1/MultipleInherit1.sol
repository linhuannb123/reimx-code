// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

// i -> uint256: 0
contract Parent {
    uint256 public i;
    constructor() {
        console.log("Parent()");
    }

}


// transact to Base1.foo pending ... 
// foo => console.log: foo1()
// i -> uint256: 2
contract Base1 is Parent {
    constructor(){
        console.log('Base1()');
    }

    function foo() virtual  public {
        i = i + 2;
        console.log('foo1()');
    }
}

// transact to Base2.foo pending ... 
// foo => console.log: foo2()
// i -> uint256: 0
contract Base2 is Parent {
    constructor(){
        console.log("Base2()");
    }

    function foo() virtual  public {
        i = i * 2;
        console.log("foo2()");
    }
}

// transact to Inherited.foo pending ... 
// foo => console.log: foo() foo1()
// i -> uint256: 2
contract Inherited is Base2,Base1 {
    constructor(){
        console.log("Inherited");
    }

    function foo() override(Base2,Base1)  public {
        console.log("foo()");
        super.foo();
    }
}