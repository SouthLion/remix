// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Caller {

    function setX(TestContract _test, uint256 _x) external {
        _test.setX(_x);
    }

    function getX(address _test) external view returns (uint256 x) {
        x = TestContract(_test).getX();
    }

    function setXandSendEther(TestContract _test, uint256 _x) external payable {
        _test.setXandSendEther{value: msg.value}(_x);
    }

    function getXandValue(address _test)
        external
        view
        returns (uint256 x, uint256 value)
    {
        (x, value) = TestContract(_test).getXandValue();
    }
}

contract TestContract {

    uint256 public x;
    
    uint256 public value = 123;

    function setX(uint256 _x) public returns (uint256) {
        x = _x;
        return x;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setXandSendEther(uint256 _x) public payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns (uint256, uint256) {
        return (x, value);
    }
}
