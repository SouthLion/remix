// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract SimpleStorage {
    
    string public text;

    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    // calldata 51404
    // memory 51581
    function set(string calldata _text) external {
        text = _text;
    }

    function get() external view returns (string memory) {
        return text;
    }
}
