// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ERC20.sol";

/// @title Example ERC-20 Token
/// @author github.com/ronexlemon
/// @notice A concrete implementation of the ERC-20 contract.
/// @dev This contract inherits all ERC-20 functionality from the base
/// ERC20 contract. It exists to deploy a token with a specific name,
/// symbol and decimal precision.
///
/// Example:
/// - Name: Team1 Token
/// - Symbol: T1
/// - Decimals: 18
contract Token is ERC20 {

    /// @notice Deploys a new ERC-20 token.
    /// @param _name Human-readable token name (e.g. "Team1 Token").
    /// @param _symbol Token ticker symbol (e.g. "T1").
    /// @param _decimal Number of decimal places used by the token.
    /// @dev The constructor simply forwards these values to the parent
    /// ERC20 contract, where they are stored.
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimal
    ) ERC20(_name, _symbol, _decimal) {}
}