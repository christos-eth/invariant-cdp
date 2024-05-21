// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol"; // https://github.com/centrifuge/tinlake-erc20/blob/master/src/erc20.sol
import {MockOracle} from "./MockOracle.sol";

contract LiquidationModule is SharedStorage {
    // Grab the latest price

    // Convert collateral to debt, verify if a liquidation should happen
    //
    function canLiquidate(MockOracle oracle, uint256 thresholdBPS, address target) public returns (bool) {
        uint256 collateral = deposits[target];
        uint256 debt = liabilities[target];

        uint256 decimals = oracle.DECIMALS();
        uint256 price = oracle.getPrice();

        return canLiquidateGivenCollateralAndDebt(price, decimals, thresholdBPS, collateral, debt);
    }

    event DebugValue(string, uint256);
    
    /// TODO: TEST IT
    function canLiquidateGivenCollateralAndDebt(
        uint256 price,
        uint256 decimals,
        uint256 thresholdBPS,
        uint256 collateral,
        uint256 debt
    ) public returns (bool) {
        uint256 collateralAsDebt = collateral * price / (10 ** decimals);
        emit DebugValue("collateralAsDebt", collateralAsDebt);//@added

        uint256 withThreshold = collateralAsDebt * thresholdBPS / 10_000;
        emit DebugValue("withThreshold", withThreshold); //@added

        return withThreshold <= debt; //@note - < or <=
    }
}
