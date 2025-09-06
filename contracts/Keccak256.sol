// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/*
Alice：

计算消息的哈希值：hash(message) = H
⽤她的私钥对哈希值进⾏签名：signature = Sign(H, Alice's private key)
发送消息和签名给 Bob

Bob：
接收到消息和签名
⽤ Alice 的公钥对签名进⾏验证，得到哈希值：H' = Verify(signature, Alice's public key)
计算接收到消息的哈希值：H'' = hash(message)
⽐较 H' 和 H''，如果相等，消息未被篡改且确实来⾃ Alice
*/
contract HashFunc {
    function hash(
        string memory text,
        uint256 num,
        address addr
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
        // abi.encode
    }

    function encode(string memory text0, string memory text1)
        external
        pure
        returns (bytes memory)
    {
        return abi.encode(text0, text1);
    }

    function encodePacked(string memory text0, string memory text1)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(text0, text1);
    }

    function collision(
        string memory text0,
        uint256 x,      // 加入一个数字防止冲突
        string memory text1
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text0, x, text1));
    }
}
