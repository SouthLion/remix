// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "@openzeppelin/contracts/access/AccessControl.sol";

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 admin 
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 normal
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db manager
// 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB normal

contract Mycontract is AccessControl{

    bytes32 public constant ROLE_MANAGER = keccak256("ROLE_MANAGER");

    bytes32 public constant ROLE_NORMAL = keccak256("ROLE_NORMAL");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function setRoleAdmin() external onlyRole(DEFAULT_ADMIN_ROLE) {
        // 设置ROLE_NORMAL的管理角色为ROLE_MANAGER
        _setRoleAdmin(ROLE_NORMAL,ROLE_MANAGER);
    }

    function normalThing() external onlyRole(ROLE_NORMAL) {
        // anyone can call this normalThing()
    }

    function specialThing() public onlyRole(ROLE_MANAGER) {
        // only the owner can call specialThing()!
    }
}