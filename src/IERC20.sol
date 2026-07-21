// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ERC-20 Token Interface
/// @author github.com/ronexlemon
/// @notice Defines the standard interface for ERC-20 fungible tokens.
/// @dev Any ERC-20 compliant token contract should implement this interface.
interface IERC20 {
    /// @notice Returns the total number of tokens currently in existence.
    /// @dev This value increases when tokens are minted and decreases when tokens are burned.
    /// @return The current total token supply.
    function totalSupply() external view returns (uint256);

    /// @notice Returns the token balance of a specific account.
    /// @param account The address whose balance is being queried.
    /// @return The number of tokens owned by the account.
    function balanceOf(address account) external view returns (uint256);

    /// @notice Returns the remaining number of tokens that a spender is allowed
    /// to transfer on behalf of the token owner.
    /// @dev This value is set using {approve} and decreases whenever
    /// {transferFrom} is successfully called.
    /// @param owner The address that owns the tokens.
    /// @param spender The address authorized to spend the tokens.
    /// @return The remaining approved allowance.
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /// @notice Approves another account or smart contract to spend tokens
    /// on behalf of the caller.
    /// @dev Calling this function updates the spender's allowance.
    /// @param spender The address being granted permission to spend tokens.
    /// @param amount The maximum number of tokens the spender is allowed to transfer.
    /// @return True if the approval succeeds.
    function approve(address spender, uint256 amount)
        external
        returns (bool);

    /// @notice Transfers tokens from the caller to another address.
    /// @param recipient The address receiving the tokens.
    /// @param amount The number of tokens to transfer.
    /// @return True if the transfer succeeds.
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /// @notice Transfers tokens from one account to another using an existing allowance.
    /// @dev The caller must have sufficient allowance granted by the sender.
    /// The allowance is reduced by the transferred amount after a successful transfer.
    /// @param sender The address the tokens are transferred from.
    /// @param recipient The address receiving the tokens.
    /// @param amount The number of tokens to transfer.
    /// @return True if the transfer succeeds.
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}