// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20 {
    constructor(uint256 initalSupply) ERC20("USDT", "u") {
        _mint(msg.sender, initalSupply);
    }
}
