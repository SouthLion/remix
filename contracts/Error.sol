// require, revert, assert
// - gas refund, state updates are reverted
// custom error - save gas
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Error1 {
    function testRequire(uint256 _i) public pure {
        require(_i <= 10, "i > 10");
        // code
    }

    function testRevert(uint256 _i) public pure {
        if (_i > 1) {
            // code
            if (_i > 2) {
                // more code
                if (_i > 10) {
                    revert("i > 10");
                }
            }
        }
    }

    uint256 public num = 123;

    function testAssert() public view {
        assert(num == 123);
    }

    function foo(uint256 _i) public {
        num += 1;
        require(_i < 10);
    }

    error MyError(address caller, uint256 i);

    function testCustomError(uint256 _i) public view {
        if (_i > 10) {
            revert MyError(msg.sender, _i);
        }
    }
}
