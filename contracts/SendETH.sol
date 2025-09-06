// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// 3 ways to send ETH
// transfer - 2300 gas, reverts
// send - 2300 gas returns bool
// call - all gas, retuns bool and data

contract SendEther {

    // 允许合约在部署时接收以太币（ETH）
    constructor() payable {}

    receive() external payable {}

    // 简单场景用transfer
    function sendViaTransfer(address payable _to) external payable {
        // 往to地址发送123wei以太
        _to.transfer(123);
    }

    // 几乎不会用send
    function sendViaSend(address payable _to) external payable {
        // 往to地址发送123wei以太，同时返回一个bool变量
        bool sent = _to.send(123);
        require(sent, "send failed");
    }

    // 复杂场景用call
    function sendViaCall(address payable _to) external payable {
        (bool success, ) = _to.call{value: 123}("");
        require(success, "call failed");
    }
}

contract EthReciver {
    event Log(uint256 amount, uint256 gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}
