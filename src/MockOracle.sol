// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol"; // https://github.com/centrifuge/tinlake-erc20/blob/master/src/erc20.sol

// external dependency
// We don't delegate to this
contract MockOracle {
    // TODO: Allow for reverts, for fun
    uint256 public getPrice;
    uint256 public lastUpdated;
    uint256 public constant DECIMALS = 18;

    function setPrice(uint256 newPrice) external {
        getPrice = newPrice;
        lastUpdated = uint256(block.timestamp); // ToDO: Allow manipulation
    }
}
