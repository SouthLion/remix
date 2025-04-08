// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICouter {
    function count() external view returns (uint256);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICouter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint256) {
        return ICouter(_counter).count();
    }
}
