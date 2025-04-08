// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


// visibility
// private - 只在合约内部
// internal - 合约内部或⼦合约
// public - 内部或外部


// external - 只能外部调⽤
/*
A
private pri()
internal inter()
public pub() <-------- C pub() and ext()
external ext()
B is A
inter() <-------- C pub() and ext()
pub()
*/

contract Base {
    uint256 private x = 0;
    uint256 internal y = 1;
    uint256 public z = 2;

    function privateFunc() private pure returns (uint256) {
        return 0;
    }

    function internalFunc() internal pure returns (uint256) {
        return 100;
    }

    function publicFunc() public pure returns (uint256) {
        return 200;
    }

    function externalFunc() external pure returns (uint256) {
        return 300;
    }

    function examples() external view {
        x + y + z;
        privateFunc();
        internalFunc();
        publicFunc();
        this.externalFunc(); // 强制调用external方法，但是不推荐，gas消耗很多，也不符合合约编写逻辑
    }
}

contract Child is Base {
    function examples2() external view {
        y + z;
        internalFunc();
        publicFunc();
    }
}
