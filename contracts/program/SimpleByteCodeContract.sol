// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Runtime code
// Creation code
// Factory contract

contract Factory {
    event Log(address addr);

    function deploy() external {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address addr;
        assembly {
            addr := create(0, add(bytecode, 0x20), 0x13) // 第一个参数0是以太，0x20是32长度，0x13是bytecode的长度
        }
        require(addr != address(0), "deploy failed");
        emit Log(addr);
    }
}

interface IContract {
    function getMeaningOfLife() external view returns (uint256);
}

/*
    return(p, s) - end execution and return data from memory p to p + s
    mstore(p, v) - store v at memory p to p + 32

    PUSH1 0x2a  // 42
    PUSH1 0
    MSTORE

    Return 32 bytes from memory
    PUSH1 0x20
    PUSH1 0
    RETURN

    https://www.evm.codes/playground
    Run time code - return 42
    602a60005260206000f3

    Creation code
    Store run time code to memory

    PUSH10 0x602a60005260206000f3    // 20个字符10个字节
    PUSH1 0 // 从0开始
    MSTORE
    0x00000000000000000000000000000000000000000000602a60005260206000f3 // 44个0，22个字节

    Return 10 bytes from memroy starting at offset 22
    PUSH1 0x0a // 10个字节
    PUSH1 0x16 // 22个偏移量
    RETURN

    69602a60005260206000f3600052600a6016f3
*/
