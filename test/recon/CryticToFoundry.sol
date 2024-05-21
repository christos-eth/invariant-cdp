// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import "forge-std/console2.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        // targetContract(address(counter));
    }

    function test_wireup() public {
        // we have deployed the Mint Module
        // the storage is actually tracked in singleton

        // for unit tests we can directly test on the CollateralModule
        assertEq(address(singleton.collateral()), address(collateral), "Match");
        assertEq(address(singleton.debt()), address(debt), "Match");
        assertEq(address(singleton.collateralModule()), address(collateralModule), "Match");
    }

    function test_mintUnit() public {
        // Approve the token

        // Deposit

        // Ensure balance changes

        collateral.mint(address(this), 1e18);
        collateral.approve(address(collateralModule), 1e18);
        collateralModule.deposit(collateral, 1e18);
        assertTrue(collateralModule.deposits(address(this)) == 1e18);
    }

    function test_canAlwaysLiquidate(uint128 price, uint128 collateral, uint256 multiplier) public {
        uint256 thresholdBPS = 7_500;
        uint256 decimals = 18;

        // uint256 multiplier = bound(multiplier, 0, 100);
        multiplier %= 25; //[0,25]

        uint256 debt = uint256(collateral) *  (75 + multiplier) / 100; // debt < multiplier
        // assertTrue(debt <= collateral, "debt is higher than the collateral");

        assertTrue(liquidationModule.canLiquidateGivenCollateralAndDebt(price, decimals, thresholdBPS, collateral, debt), "can't liquidate");
    }

    function test_basicLiquidationModule(uint128 price, uint128 collateral, uint128 debt) public {
        uint256 thresholdBPS = 7_500;
        uint256 decimals = 18;

        try liquidationModule.canLiquidateGivenCollateralAndDebt(price, decimals, thresholdBPS, collateral, debt) {}
        catch {
            assertTrue(false, "should never revert");
        }
    }
}
