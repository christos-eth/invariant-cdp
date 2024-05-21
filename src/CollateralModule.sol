// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol"; // https://github.com/centrifuge/tinlake-erc20/blob/master/src/erc20.sol

contract CollateralModule is SharedStorage {
    // Deposit Call
    function deposit(ERC20 collateral, uint256 amt) external {
        // Transfer the collateral amt
        deposits[msg.sender] += amt;

        // Credit that to the user
        collateral.transferFrom(msg.sender, address(this), amt);
    }

    // withdraw call
    function withdraw(ERC20 collateral, uint256 amt) external {
        deposits[msg.sender] -= amt;
        collateral.transfer(msg.sender, amt);
    }
}
