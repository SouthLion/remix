// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/*
- 函数不存在
- 直接发送eth
           Ether
             |
    is msg.data empty?
            /    \
           Yes    No
           /       \
receive() exists? fallback()
   /   \
  Yes    No
  |       |
receive() fallback()
*/

contract Fallback {

    event Log(string func, address sender, uint256 value, bytes data);

    // 当用户调用不存在的函数时候，执行fallback（）函数
    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    // 不能接受数据
    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}
