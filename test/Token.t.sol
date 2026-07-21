// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

/// @title ERC-20 Test Suite
/// @author github.com/ronexlemon
/// @notice Tests the core functionality of the ERC-20 implementation.
/// @dev Covers metadata, transfers, allowances, minting, burning,
/// failure cases, and fuzz testing.
contract TokenTest is Test {
    /// @notice The token contract being tested.
    Token public token;

    /// @notice Test accounts used throughout the suite.
    address alice = address(1);
    address bob = address(2);
    address charlie = address(3);

    /// @notice Deploys a fresh token before every test.
    /// @dev Foundry calls this automatically before each test function.
    function setUp() public {
        token = new Token("Team1", "T1", 18);
    }

    /// @notice Verifies the token metadata was initialized correctly.
    function testMetadata() public view {
        assertEq(token.name(), "Team1");
        assertEq(token.symbol(), "T1");
        assertEq(token.decimal(), 18);
    }

    /// @notice Ensures minting increases both total supply and
    /// the recipient's balance.
    function testMint() public {
        token.mint(alice, 100);

        assertEq(token.totalSupply(), 100);
        assertEq(token.balanceOf(alice), 100);
    }

    /// @notice Verifies a holder can transfer tokens to another account.
    function testTransfer() public {
        token.mint(alice, 100);

        // Simulate Alice sending the transaction.
        vm.prank(alice);
        token.transfer(bob, 40);

        assertEq(token.balanceOf(alice), 60);
        assertEq(token.balanceOf(bob), 40);
    }

    /// @notice Ensures approvals correctly create allowances.
    function testApprove() public {
        token.mint(alice, 100);

        vm.prank(alice);
        token.approve(bob, 50);

        assertEq(token.allowance(alice, bob), 50);
    }

    /// @notice Verifies an approved spender can transfer tokens
    /// on behalf of another account.
    function testTransferFrom() public {
        token.mint(alice, 100);

        // Alice approves Bob.
        vm.prank(alice);
        token.approve(bob, 70);

        // Bob spends part of Alice's allowance.
        vm.prank(bob);
        token.transferFrom(alice, charlie, 50);

        // Alice loses tokens.
        assertEq(token.balanceOf(alice), 50);

        // Charlie receives tokens.
        assertEq(token.balanceOf(charlie), 50);

        // Bob's remaining allowance decreases.
        assertEq(token.allowance(alice, bob), 20);
    }

    /// @notice Verifies burning destroys tokens and reduces total supply.
    function testBurn() public {
        token.mint(alice, 100);

        token.burn(alice, 30);

        assertEq(token.balanceOf(alice), 70);
        assertEq(token.totalSupply(), 70);
    }

    /// @notice Ensures transfers fail when the sender lacks
    /// sufficient balance.
    function testCannotTransferMoreThanBalance() public {
        token.mint(alice, 100);

        vm.prank(alice);

        // Solidity 0.8+ automatically reverts on arithmetic underflow.
        vm.expectRevert();
        token.transfer(bob, 101);
    }

    /// @notice Ensures transferFrom cannot be used without approval.
    function testCannotTransferFromWithoutAllowance() public {
        token.mint(alice, 100);

        vm.prank(bob);

        vm.expectRevert();
        token.transferFrom(alice, charlie, 10);
    }

    /// @notice Ensures a spender cannot transfer more than
    /// the approved allowance.
    function testCannotTransferMoreThanAllowance() public {
        token.mint(alice, 100);

        vm.prank(alice);
        token.approve(bob, 20);

        vm.prank(bob);

        vm.expectRevert();
        token.transferFrom(alice, charlie, 30);
    }

    /// @notice Ensures burning more tokens than an account owns
    /// causes the transaction to revert.
    function testCannotBurnMoreThanBalance() public {
        token.mint(alice, 100);

        vm.expectRevert();
        token.burn(alice, 101);
    }

    /// @notice Fuzz test for transfers.
    /// @dev Foundry generates random amounts to verify transfer logic
    /// works for a wide range of values.
    function testFuzzTransfer(uint256 amount) public {
        // Prevent overflow and unrealistic values.
        amount = bound(amount, 0, 1e24);

        token.mint(alice, amount);

        vm.prank(alice);
        token.transfer(bob, amount);

        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), amount);
    }

    /// @notice Fuzz test for approvals.
    /// @dev Ensures allowances are correctly stored regardless
    /// of the approved amount.
    function testFuzzApprove(uint256 amount) public {
        vm.prank(alice);
        token.approve(bob, amount);

        assertEq(token.allowance(alice, bob), amount);
    }
}