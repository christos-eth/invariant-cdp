// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {CollateralModule} from "./CollateralModule.sol";
import {LiquidationModule} from "./LiquidationModule.sol";
import {MintModule} from "./MintModule.sol";
import {MockOracle} from "./MockOracle.sol";

import {ERC20} from "./ERC20.sol";

contract Singleton {
    // STORAGE CLASHES
    // functionality
    // delegate Call

    // == MODULES == //
    address public immutable collateralModule;
    address public immutable mintModule;
    address public immutable liquidationModule;
    MockOracle public immutable mockOracle;

    ERC20 public immutable collateral;
    ERC20 public immutable debt;

    uint256 public immutable thresholdBPS = 7_500;

    // == END MODULES == //
    constructor(ERC20 _collateral, ERC20 _debt, address _collateralModule, address _mintModule, address _liquidationModule, MockOracle _mockOracle) {
        collateral = _collateral;
        debt = _debt;
        collateralModule = _collateralModule;
        mintModule = _mintModule;
        liquidationModule = _liquidationModule;

        mockOracle = _mockOracle;
    }

    // Deposit Call
    function deposit(uint256 amt) external {
        // Transfer the collateral amt
        // Credit that the use
        _executeModules(collateralModule, abi.encodeCall(CollateralModule.deposit, (collateral, amt)));
    }

    // withdraw call
    function withdraw(uint256 amt) external {
        // Transfer the collateral amt
        // Credit that the use
        _executeModules(collateralModule, abi.encodeCall(CollateralModule.withdraw, (collateral, amt)));
    }

    // Mint our Debt collateral
    function mint(uint256 amt) external {
        _executeModules(collateralModule, abi.encodeCall(MintModule.mint, (debt, amt)));
    }

    function burn(uint256 amt) external {
        _executeModules(collateralModule, abi.encodeCall(MintModule.burn, (debt, amt)));
    }

    // Check for liquidation
    function canLiquidate(address target) public /* view */ returns(bool) {
        _executeModules(liquidationModule, abi.encodeCall(LiquidationModule.canLiquidate, (mockOracle, thresholdBPS, target)));
    }

    // withdraw

    // Credit to tapicodatao
    function _executeModules(address module, bytes memory _data) private returns (bytes memory returnData) {
        bool success = true;

        (success, returnData) = address(module).delegatecall(_data);

        if (!success) {
            revert("an error occurred");
        }
    }
}
