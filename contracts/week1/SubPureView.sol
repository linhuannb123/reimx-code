// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./PureView.sol";

// 继承PureView合约
contract SubPureView is PureView {
    // 默认是external
    function test() view external {
        console.log(_var);
    }
}