// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract UUPSV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    uint256 public x;

    constructor(uint256 _val) {
        x = _val; 
    }

    function _authorizeUpgrade(address newImplementation) internal override  {

    }

    function Initialize(uint256 _val) external initializer {
        x = _val; // set initial value in initializer
        __Ownable_init(msg.sender);
    }

    function cal() external {
        x = x + 1;
    }

    function showInvoke() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.Initialize.selector, 1);
    }

}


contract UUPSV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    uint256 public x;

    constructor(uint256 _val) {
        x = _val; 
    }

    function _authorizeUpgrade(address newImplementation) internal override  {

    }

    function Initialize(uint256 _val) external initializer {
        x = _val; // set initial value in initializer
        __Ownable_init(msg.sender);
    }

    function cal() external {
        x = x * 2;
    }

}

