// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract GasGolf {
    // start - 55167 gas
    // use calldata - 54438 gas -> calldata 替代 memory
    // load state variables to memory - 54187 gas -> // 每次循环，状态变量total都要被读取一次，然后修改，故可以把状态变量放到内存里面节省gas
    // short circuit - 53815 gas -> num % 2 == 0 && num < 99 替代 bool isEven = num[i] % 2 == 0 ; bool isLessThan99 = num[i] < 99 
    // loop increments - 53304 gas   -> ++i 替代 i+= 1；
    // cache array length - deprecated
    // load array elements to memory - 53097 gas -> 提取uint256 num = nums[i],避免多次读取数组

    uint256 public total;

    // [1,2,3,4,5,100]
    function sumIfEvenAndLessThan99(uint256[] calldata nums) external {
        // 每次循环，状态变量total都要被读取一次，然后修改，故可以把状态变量放到内存里面节省gas
        uint256 _total = total;
        for (uint256 i = 0; i < nums.length; ++i) {
            uint256 num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }
}
