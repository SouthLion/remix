// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// 继承顺序： 最上层的最优先

/*

    X
  / | 
  Y |
  \ |
    Z

// 继承顺序：X, Y, Z

    X
   / \
   Y  A
   |  |
   |  B
   \ /
    Z

// 继承顺序：X，Y, A, B,Z
*/

contract X {
    function foo() public pure virtual returns (string memory) {
        return "X";
    }

    function bar() public pure virtual returns (string memory) {
        return "X";
    }

    // more code here
    function x() public pure returns (string memory) {
        return "X";
    }
}

contract Y is X {
    function foo() public pure virtual override returns (string memory) {
        return "Y";
    }

    function bar() public pure virtual override returns (string memory) {
        return "Y";
    }

    // more code here
    function y() public pure returns (string memory) {
        return "Y";
    }
}

contract Z is X, Y {
    // override（X，Y）和override（Y，X）顺序无所谓
    function foo() public pure override(X, Y) returns (string memory) {
        return "Z";
    }

    function bar() public pure override(Y, X) returns (string memory) {
        return "Z";
    }
}
