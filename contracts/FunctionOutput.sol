// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Return multiple outputs
// Named outputs
// Destructuring Assignmnet
contract FunctionOutputs {
    function returnMany() public pure returns (uint256, bool) {
        return (1, true);
    }

    function named() public pure returns (uint256 x, bool b) {
        return (1, true);
    }

    function assigned() public pure returns (uint256 x, bool b) {
        // return (1, true);
        x = 1;
        b = true;
    }

    function destructingAssigments()public pure{
        (uint x,bool b) = returnMany();
        
        // 只获取第二个变量
        (,bool c) = returnMany();

    }
    
}
