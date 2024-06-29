// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Libraries
import "../../../../src/EVault/shared/Constants.sol";

// Test Contracts
import {Actor} from "../../utils/Actor.sol";
import {BaseHandler} from "../../base/BaseHandler.t.sol";

// Interfaces
import {ILiquidation} from "../../../../src/EVault/IEVault.sol";

import "forge-std/console.sol";

/// @title LiquidationModuleHandler
/// @notice Handler test contract for the VaultRegularBorrowable actions
contract LiquidationModuleHandler is BaseHandler {
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                      STATE VARIABLES                                      //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    struct LiquidationData {
        bool violatorStatus;
        bool senderStatus;
        uint256 debtViolator;
        uint256 debtSender;
        uint256 collateralBalanceViolator;
        uint256 collateralBalanceSender;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                       GHOST VARAIBLES                                     //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                           ACTIONS                                         //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    function liquidate(uint256 repayAssets, uint256 minYieldBalance, uint256 i) external setup {
        bool success;
        bytes memory returnData;

        LiquidationData memory liquidationData;

        address target = address(eTST);

        // Get one of the three actors randomly
        address violator = _getRandomActor(i);

        // Get violator info
        liquidationData.violatorStatus = isAccountHealthyLiquidation(violator);
        liquidationData.debtViolator = eTST.debtOf(violator);

        // Get sender info
        liquidationData.senderStatus = isAccountHealthyLiquidation(address(actor));
        liquidationData.debtSender = eTST.debtOf(address(actor));

        liquidationData.collateralBalanceViolator = eTST2.balanceOf(violator);
        liquidationData.collateralBalanceSender = eTST2.balanceOf(address(actor));

        (uint256 maxRepay, uint256 maxYield) = eTST.checkLiquidation(address(actor), violator, address(eTST2));

        {
            {
                (, uint256 liabilityValue) = eTST.accountLiquidity(violator, true);
                require(liabilityValue > 0, "LiquidationModuleHandler: debtViolator is 0");

                minYieldBalance = clampLe(minYieldBalance, maxYield);
            }

            _beforeLiquidation(violator);

            (success, returnData) = actor.proxy(
                target,
                abi.encodeWithSelector(
                    ILiquidation.liquidate.selector, violator, address(eTST2), repayAssets, minYieldBalance
                )
            );
        }

        if (success && (maxRepay != 0 || minYieldBalance != 0)) {
            _after();

            // Violator should be unhealthy before liquidation
            assertFalse(liquidationData.violatorStatus, LM_INVARIANT_A);

            if (repayAssets == type(uint256).max) repayAssets = maxRepay;

            // Debt accounting
            if (!eTST.isFlagSet(CFG_DONT_SOCIALIZE_DEBT) && eTST2.balanceOf(violator) == 0) {
                assertEq(eTST.debtOf(violator), 0, LM_INVARIANT_G);
            } else {
                assertEq(eTST.debtOf(violator), liquidationData.debtViolator - repayAssets, LM_INVARIANT_E);
            }
            assertEq(eTST.debtOf(address(actor)), liquidationData.debtSender + repayAssets, LM_INVARIANT_E);

            // Collateral accounting
            assertEq(eTST2.balanceOf(violator), liquidationData.collateralBalanceViolator - maxYield, LM_INVARIANT_F);
            assertEq(
                eTST2.balanceOf(address(actor)), liquidationData.collateralBalanceSender + maxYield, LM_INVARIANT_F
            );

            // Sender should stay healthy
            assertTrue(isAccountHealthy(address(actor)), LM_INVARIANT_C);
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                           HELPERS                                         //
    ///////////////////////////////////////////////////////////////////////////////////////////////
}
