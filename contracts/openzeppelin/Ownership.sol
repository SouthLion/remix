// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Mycontract is Ownable{

    constructor(address initialOwner) Ownable(initialOwner) {

    }

    function normalThing() public {
        // anyone can call this normalThing()
    }

    function specialThing() public onlyOwner{
        // only the owner can call specialThing()!
    }
}