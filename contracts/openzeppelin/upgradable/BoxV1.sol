// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract BoxV1 is Initializable {

    uint256 public x;

    function Initialize(uint256 _val) external initializer {
        x = _val; // set initial value in initializer
    }

    function cal() external {
        x = x + 1;
    }

    function showInvoke() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.Initialize.selector, 1);
    }
}
