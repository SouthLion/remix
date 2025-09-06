// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// 提案合约
contract BizContract {

    uint public x;

    function call(uint _var) external payable {
        x = _var;
    }

    function showCallData() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.call.selector, 1);
    }
}