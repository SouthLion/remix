// SPDX-License-Identifier: MIT
// 一次查询中返回多次结果
pragma solidity ^0.8.23;

contract TestMultiCall {
    function func1() external view returns (uint256, uint256) {
        return (1, block.timestamp);
    }

    function func2() external view returns (uint256, uint256) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns (bytes memory) {
        // return abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns (bytes memory) {
        // return abi.encodeWithSignature("func2()");
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);
        for (uint256 i; i < targets.length; i++) {
            // 因为没有设计到修改，所以只需要静态调用static call，需要设计需改，需要用call
            (bool success, bytes memory result) = targets[i].staticcall(
                data[i]
            );
            require(success, "tx failed");
            results[i] = result;
        }
        return results;
    }
}
