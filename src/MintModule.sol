// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol"; // https://github.com/centrifuge/tinlake-erc20/blob/master/src/erc20.sol

contract MintModule is SharedStorage {
    // mint Call
    function mint(ERC20 debt, uint256 amt) external {
        liabilities[msg.sender] += amt;
        debt.mint(msg.sender, amt);
    }

    // burn from user to repay
    function burn(ERC20 debt, uint256 amt) external {
        liabilities[msg.sender] -= amt;
        debt.burn(msg.sender, amt);
    }
}
