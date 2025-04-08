// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Data locations - storage, memory and calldata
contract DataLocations {
    struct MyStruct {
        uint256 foo;
        string text;
    }
    mapping(address => MyStruct) myStructs;

    function examples(uint256[] calldata y, string calldata s)
        external
        returns (uint256[] memory)
    {
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});
        MyStruct storage myStruct = myStructs[msg.sender];
        myStruct.text = "foo";
        MyStruct memory readOnly = myStructs[msg.sender];
        readOnly.foo = 456;
        _internal(y);
        uint256[] memory memArr = new uint256[](3);
        memArr[0] = 234;
        return memArr;
    }

    function _internal(uint256[] calldata y) private {
        uint256 x = y[0];
    }
}
