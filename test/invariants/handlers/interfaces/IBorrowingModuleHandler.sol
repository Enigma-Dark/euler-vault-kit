// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IBorrowingModuleHandler {
    function repayTo(uint256 assets, uint256 i) external;
}
