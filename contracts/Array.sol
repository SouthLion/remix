// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

//Array - 动态或固定⻓度
// 初始化
// Insert (push), get, update, delete, pop, length
// Creating arr in memory
// Returning array from function
contract Array {
    uint256[] public nums = [1, 2, 3];
    uint256[3] public numsFixed = [4, 5, 6];

    function examples() external {
        nums.push(4); // [1,2,3,4]
        uint256 x = nums[1];
        nums[2] = 777; // [1, 2, 777, 4]
        delete nums[1]; // [1, 0, 777, 4]
        nums.pop(); // [1, 0, 777]
        uint256 len = nums.length;
        // create array in memory
        uint256[] memory a = new uint256[](5);
        a[1] = 123;
    }
}
