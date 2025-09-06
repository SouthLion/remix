// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Function modifier - 代码重⽤
// Basic, inputs, sandwich

// function <函数名>(<参数列表>)
//     [可见性修饰符]   // public | external | internal | private
//     [状态修饰符]     // pure | view | payable
//     [权限/自定义modifier]  // onlyOwner 等
//     [virtual/override]    // 是否允许/需要重写
//     [returns (…)]   // 返回值

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
