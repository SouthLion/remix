// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayableExample {
    address payable public recipient;

    // 构造函数，初始化 recipient 为 msg.sender
    constructor() {
        recipient = payable(msg.sender);
    }

    receive() external payable { }
    
    // 定义⼀个 payable 函数，⽤于接收以太币
    function receiveEther() external payable {}

    // 查询合约余额
    function queryBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 接收以太币失败时的回退函数
    fallback() external payable {
        revert("Function not payable");
    }
}
