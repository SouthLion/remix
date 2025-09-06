// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0-rc.0/contracts/utils/cryptography/MessageHashUtils.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0-rc.0/contracts/utils/cryptography/ECDSA.sol";
contract VerifySignature2 {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    function recover(string memory str, bytes memory signature) external pure returns(address) {
        bytes32 hash = keccak256(bytes(str));

        return hash.toEthSignedMessageHash().recover(signature);
    }
}