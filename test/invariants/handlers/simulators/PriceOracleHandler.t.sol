// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseHandler} from "../../base/BaseHandler.t.sol";

import "forge-std/console.sol";

/// @title PriceOracleHandler
/// @notice Handler test contract for the  PriceOracle actions
contract PriceOracleHandler is BaseHandler {
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                      STATE VARIABLES                                      //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                       GHOST VARAIBLES                                     //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                           ACTIONS                                         //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /// @notice This function simulates changes in the price of an asset
    function setPrice(uint256 i, uint256 price) external {
        address baseAsset = _getRandomBaseAsset(i);

        oracle.setPrice(baseAsset, unitOfAccount, price);
    }

    /// @notice This function simulates smaller changes in the price of an asset
    function changePrice(uint256 i, uint16 deltaPercentage, bool up) external {
        address baseAsset = _getRandomBaseAsset(i);

        deltaPercentage = uint16(clampLe(deltaPercentage, 1e4));

        uint256 price = oracle.getQuote(1e18, baseAsset, unitOfAccount);

        if (up) {
            price = price + (price * deltaPercentage) / 1e4;
        } else {
            price = price - (price * deltaPercentage) / 1e4;
        }

        oracle.setPrice(baseAsset, unitOfAccount, price);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                           HELPERS                                         //
    ///////////////////////////////////////////////////////////////////////////////////////////////
}
