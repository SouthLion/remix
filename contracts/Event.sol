// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Event {

    // up to 3 index（最多只能设置3个索引）
    event Log(string message, uint256 val);

    event IndexedLog(address indexed sender, uint256 val);

    function example() external {
        emit Log("foo", 1234);
        emit IndexedLog(msg.sender, 789);
    }

    event Message(address indexed _from, address indexed _to, string message);

    function sendMessage(address _to, string calldata message) external {
        emit Message(msg.sender, _to, message);
    }
}
