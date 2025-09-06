// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract C2NToken is ERC20 {

    constructor() ERC20("C2NToken", "C2N") {
        _mint(msg.sender, 100 * 10 ** decimals());
    }
}