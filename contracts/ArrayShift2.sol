// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
// 以上的删除方式，gas较高

// 通过交换数组最后一位和arr[deleteIndex],再pop最后一位
contract ArrayReplaceLast {
    uint256[] public arr;


    // [1, 2, 3, 4] -- remove(1) --> [1, 4, 3]
    // [1, 4, 3] -- remove(2) --> [1 ,4]
    function remove(uint256 _index) public {
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }

    function test() external {
        arr = [1, 2, 3, 4];
        remove(1);
        // [1, 4, 3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);
        remove(2);
        // [1 ,4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}
