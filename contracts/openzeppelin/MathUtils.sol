// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "@openzeppelin/contracts/utils/math/Math.sol";
contract MathUtils {

    using Math for uint256;

    // 实现加法方式一
    function testAdd(uint a, uint b) external pure {
        Math.tryAdd(a,b);
    }

    // 实现加法方式二
    function testAdd2(uint a,uint b) external pure {
        a.tryAdd(b);
    }
}