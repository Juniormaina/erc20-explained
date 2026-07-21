# ERC20 Explained

A minimal implementation of the ERC-20 token standard written in Solidity for educational purposes.

This project is intended to help developers understand how an ERC-20 token works internally by implementing the standard from scratch instead of relying on OpenZeppelin.

> **Note**
> This project is for learning and experimentation only. It has not been audited and should **not** be used in production.

---

## Features

- ERC-20 interface implementation
- Token transfers
- Allowances
- Approvals
- `transferFrom`
- Minting
- Burning
- Unit tests with Foundry

---

## Project Structure

```
.
├── src
│   ├── IERC20.sol
│   ├── ERC20.sol
│   └── Token.sol
├── test
│   └── Token.t.sol
├── README.md
└── CONTRIBUTING.md
```

---

## ERC20 Functions

### `totalSupply()`

Returns the total number of minted tokens.

---

### `balanceOf(address account)`

Returns the token balance of an account.

---

### `transfer(address recipient, uint256 amount)`

Transfers tokens from the caller to another account.

---

### `approve(address spender, uint256 amount)`

Allows another account or smart contract to spend tokens on behalf of the owner.

---

### `allowance(address owner, address spender)`

Returns the remaining amount a spender is allowed to transfer.

---

### `transferFrom(address sender, address recipient, uint256 amount)`

Transfers tokens using an existing allowance.

---

## How Allowances Work

```
Alice
  │
  │ approve(Bob, 100)
  ▼
Allowance
Alice → Bob = 100

Bob

transferFrom(Alice, Charlie, 40)

Balances

Alice   -40
Charlie +40

Allowance

Alice → Bob = 60
```

---

## Getting Started

### Clone

```bash
git clone https://github.com/<your-username>/erc20-explained.git

cd erc20-explained
```

### Install

```bash
forge install
```

### Build

```bash
forge build
```

### Run Tests

```bash
forge test
```

Verbose output

```bash
forge test -vvvv
```

Coverage

```bash
forge coverage
```

---

## Learning Goals

This repository explains:

- ERC-20 architecture
- Solidity mappings
- Events
- Allowances
- Token transfers
- Minting
- Burning
- Foundry testing

---

## Future Improvements

- Ownership
- Access Control
- Permit (EIP-2612)
- ERC20Votes
- ERC20Snapshot
- ERC20Burnable
- ERC20Pausable
- ERC20Capped
- Gas optimizations

---

## License

MIT