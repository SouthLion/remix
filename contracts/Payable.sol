// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract PayableExample {

     /*   address payable（可支付地址）

         在address 基础上多了一些 与转账相关的方法：

        .transfer(uint256 amount)

        .send(uint256 amount)

        .call{value: amount}("")
        可以接收、发送 ETH


       address payable = 钱包地址，能转账（“谁收钱”）。

       receive() payable = 钱包的入口函数，别人给你打钱时执行（“怎么收钱”）。 
    */
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
