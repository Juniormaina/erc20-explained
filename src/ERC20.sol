// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC20.sol";

/// @title Minimal ERC-20 Token Implementation
/// @author github.com/ronexlemon
/// @notice A simple implementation of the ERC-20 standard for educational purposes.
/// @dev This contract demonstrates how balances, allowances, transfers,
/// approvals, minting, and burning work internally.
contract ERC20 is IERC20 {
    /// @notice Total number of tokens currently in circulation.
    /// @dev Increases when tokens are minted and decreases when burned.
    uint256 public totalSupply;

    /// @notice Stores the balance of every account.
    /// @dev Example:
    /// balanceOf[Alice] = 100
    mapping(address account => uint256 amount) public balanceOf;

    /// @notice Stores how many tokens a spender is allowed to spend
    /// on behalf of a token owner.
    /// @dev Example:
    /// allowance[Alice][Bob] = 50
    /// means Bob can spend up to 50 of Alice's tokens.
    mapping(address owner => mapping(address spender => uint256 amount))
        public allowance;

    /// @notice Human-readable token name.
    string public name;

    /// @notice Token ticker symbol.
    string public symbol;

    /// @notice Number of decimal places the token uses.
    /// @dev Most ERC-20 tokens use 18 decimals.
    uint8 public decimal;

    /// @notice Emitted whenever tokens move between accounts.
    /// @dev Minting emits:
    /// Transfer(address(0), recipient, amount)
    ///
    /// Burning emits:
    /// Transfer(holder, address(0), amount)
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    /// @notice Emitted whenever an allowance is created or updated.
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /// @notice Creates a new ERC-20 token.
    /// @param _name The token name.
    /// @param _symbol The token symbol.
    /// @param _decimal Number of decimal places.
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimal
    ) {
        name = _name;
        symbol = _symbol;
        decimal = _decimal;
    }

    /// @notice Transfers tokens from the caller to another account.
    /// @dev Reverts automatically if the sender has insufficient balance.
    /// @param recipient Address receiving the tokens.
    /// @param amount Number of tokens to transfer.
    /// @return True if the transfer succeeds.
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    /// @notice Approves another account to spend tokens on behalf of the caller.
    /// @dev This only grants permission—it does not transfer any tokens.
    /// @param spender Address receiving spending permission.
    /// @param amount Maximum number of tokens the spender may transfer.
    /// @return True if the approval succeeds.
    function approve(
        address spender,
        uint256 amount
    ) external returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    /// @notice Transfers tokens using an existing allowance.
    /// @dev The caller must have sufficient allowance granted by the sender.
    ///
    /// Steps:
    /// 1. Verify allowance.
    /// 2. Reduce allowance.
    /// 3. Move tokens.
    ///
    /// @param sender Address the tokens are taken from.
    /// @param recipient Address receiving the tokens.
    /// @param amount Number of tokens to transfer.
    /// @return True if the transfer succeeds.
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    /// @notice Creates new tokens.
    /// @dev Internal function so child contracts can control who is allowed
    /// to mint. Minting increases both the recipient's balance and total supply.
    ///
    /// Emits a Transfer event from the zero address.
    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;

        emit Transfer(address(0), to, amount);
    }

    /// @notice Destroys existing tokens.
    /// @dev Burning decreases both the account balance and total supply.
    ///
    /// Emits a Transfer event to the zero address.
    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;
        totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }

    /// @notice Public wrapper around the internal mint function.
    /// @dev In production this function should usually be protected
    /// with access control (e.g. onlyOwner).
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /// @notice Public wrapper around the internal burn function.
    /// @dev In production, only the token owner or an approved spender
    /// should be allowed to burn tokens.
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}