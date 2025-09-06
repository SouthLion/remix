// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Test {

    function clock() external view returns (uint256) {
        return block.number;
    }
}