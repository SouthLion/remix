// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vault01 {
    IERC20 public immutable token;
    uint256 public totalsupply;
    mapping(address => uint256) public balance0f;

    constructor(IERC20 _token) {
        token = _token;
    }

    function _mint(address _to, uint256 _shares) private {
        totalsupply += _shares;
        balance0f[_to] += _shares;
    }

    function _burn(address _from, uint256 _shares) private {
        totalsupply -= _shares;
        balance0f[_from] -= _shares;
    }

    function deposit(uint256 _amount) external {
        /*
            a = amount
            B = balance of token before deposit
            T = shares total supply
            s = shares to mint
        
            (T + s) / T = (a + B) / B
            s = aT /B
        */

        uint256 shares;
        if (totalsupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalsupply) / token.balanceOf(address(this));
        }
        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _shares) external {
        /*
            a = amount
            B = balance of token before withdraw
            T= shares total supply
            s= shares to burn
            (T-s) / T = (B - a) / B 
            a = SB /T 
        */
        uint256 amount = (_shares * token.balanceOf(address(this))) / totalsupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}
