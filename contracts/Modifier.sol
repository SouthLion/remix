// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Function modifier - 代码重⽤
// Basic, inputs, sandwich
contract FunctionModifier {
    bool public paused;
    uint256 public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    modifier whenNotPaused() {
        require(!paused, "paused");
        _;
    }

    function inc() external whenNotPaused {
        count += 1;
    }

    function dec() external whenNotPaused {
        count -= 1;
    }

    modifier cap(uint256 _x) {
        require(_x < 100, " x >= 100");
        _;
    }

    function incBy(uint256 _x) external whenNotPaused cap(_x) {
        count += _x;
    }

    modifier sandwich() {
        // code here
        count += 1;
        _;
        count *= 2;
    }

    function foo() external sandwich {
        count += 1;
    }
}
