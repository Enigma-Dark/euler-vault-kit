// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IVaultModuleHandler {
    function depositToActor(uint256 assets, uint256 i) external;
    function mintToActor(uint256 shares, uint256 i) external;
    function skim(uint256 assets, uint256 i) external;
}
