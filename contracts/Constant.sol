// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// 216 gas
contract Constants {
    address public constant MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint256 public constant MY_UINT = 123;
}

// 2303 gas
contract Var {
    address public MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
}
