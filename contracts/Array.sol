// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

//Array - 动态或固定⻓度
// 初始化
// Insert (push), get, update, delete, pop, length
// Creating arr in memory
// Returning array from function

contract Array {

    // 声明动态长度数组
    uint256[] public nums = [1, 2, 3];

    uint256[3] public numsFixed = [4, 5, 6];

    function examples() external {
        // 只能push动态数组
        nums.push(4); // [1,2,3,4]
        uint256 x = nums[1];
        nums[2] = 777; // [1, 2, 777, 4]
        delete nums[1]; // [1, 0, 777, 4]
        nums.pop(); // [1, 0, 777]
        uint256 len = nums.length;

        // 只能在内存里面创建固定长度的数组，不能创建动态数组，所以不能调用pop和push函数
        uint256[] memory a = new uint256[](5);
        a[1] = 123;
    }

    // ***一般情况下，不建议return一个数组，它的长度越大，消耗的gas就会越多，手续费就会非常昂贵
    function returnArray() external view returns (uint[] memory) {
        return nums;
    }
}
