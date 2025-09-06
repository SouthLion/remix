// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Immutable {
    address public immutable owner;

    // 52403 gas
    // 49989 gas
    constructor() {
        owner = msg.sender;
    }

    uint256 public x;

    function foo() external {
        require(msg.sender == owner);
        x += 1;
    }
}
