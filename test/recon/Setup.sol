// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import "src/Singleton.sol";
import "src/ERC20.sol";
import {CollateralModule} from "src/CollateralModule.sol";
import {MintModule} from "src/MintModule.sol";
import {LiquidationModule} from "src/LiquidationModule.sol";
import {MockOracle} from "src/MockOracle.sol";

abstract contract Setup is BaseSetup {
    ERC20 collateral;
    ERC20 debt;

    Singleton singleton;

    CollateralModule collateralModule;
    MintModule mintModule;
    LiquidationModule liquidationModule;

    MockOracle mockOracle;

    function setup() internal virtual override {
        collateral = new ERC20("Collateral", "COL");
        debt = new ERC20("Debt", "DEBT");

        collateralModule = new CollateralModule();
        mintModule = new MintModule();
        liquidationModule = new LiquidationModule();

        mockOracle = new MockOracle();

        singleton = new Singleton(collateral, debt, address(collateralModule), address(mintModule), address(liquidationModule), mockOracle);
    }
}
