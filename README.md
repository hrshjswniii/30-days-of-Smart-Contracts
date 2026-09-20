<div align="center">

# 💎 30 Days of Smart Contracts

### *Mastering Solidity, EVM Architecture, and Web3 Smart Contract Engineering*

![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.20-363636?style=for-the-badge&logo=solidity&logoColor=white)
![EVM](https://img.shields.io/badge/EVM-Compatible-627EEA?style=for-the-badge&logo=ethereum&logoColor=white)
![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-Contracts-4E5EE4?style=for-the-badge&logo=openzeppelin&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Status](https://img.shields.io/badge/Progress-16%20%2F%2030%20Days-brightgreen?style=for-the-badge)

<p align="center">
  A hands-on, progressive challenge building production-ready smart contracts from core Solidity fundamentals to advanced DeFi mechanics, tokenomics, access control, and state architecture.
</p>

---

</div>

## 📑 Table of Contents
- [📖 About The Challenge](#-about-the-challenge)
- [⚡ Tech Stack & Tools](#-tech-stack--tools)
- [📊 Smart Contract Index](#-smart-contract-index)
- [🧠 Core Concepts Covered](#-core-concepts-covered)
- [📂 Repository Structure](#-repository-structure)
- [🚀 Quick Start & Deployment Guide](#-quick-start--deployment-guide)
  - [1. Using Remix IDE](#1-using-remix-ide-recommended)
  - [2. Using Hardhat / Foundry](#2-using-hardhat--foundry)
- [🎯 Challenge Progress Tracker](#-challenge-progress-tracker)
- [👨‍💻 Author & License](#-author--license)

---

## 📖 About The Challenge

Welcome to **30 Days of Smart Contracts**! This repository tracks a progressive 30-day journey of mastering **Solidity** and **Web3 protocol development**. 

Every contract is built with precision—starting from fundamental state storage to complex real-world decentralized protocols including **Time-Weighted Token Staking**, **Automated Faucets**, **Escrows**, **Access Controls**, and **Subscription Payment Systems**.

---

## ⚡ Tech Stack & Tools

| Component | Technology | Description |
| :--- | :--- | :--- |
| **Language** | **Solidity `^0.8.20`** | Primary smart contract programming language |
| **Standard** | **ERC-20** | Standardized fungible token interface |
| **Security** | **OpenZeppelin Contracts** | Industry-standard secure contract libraries |
| **Execution Environment** | **EVM (Ethereum Virtual Machine)** | Ethereum Mainnet, Testnets (Sepolia), L2s (Arbitrum, Optimism, Polygon) |
| **Dev Tooling** | **Remix IDE / Hardhat / Foundry** | Smart contract compilation, testing, and deployment |

---

## 📊 Smart Contract Index

The table below catalogs the smart contracts included in this repository:

| Day | Contract Name | Source File | Core Topics & Key Features | Complexity |
| :-: | :--- | :--- | :--- | :-: |
| **01** | **Hello World** | [`Contract 1-HelloWorld.sol`](./Contract%201-HelloWorld.sol) | State Variables, Public Getters, Memory Strings | 🌱 Beginner |
| **02** | **Counter Contract** | [`Contract 2 - CounterContract.sol`](./Contract%202%20-%20CounterContract.sol) | State Mutation, Integer Arithmetic, Value Resets | 🌱 Beginner |
| **03** | **Simple Storage** | [`Contract 3-SimpleStorage.sol`](./Contract%203-SimpleStorage.sol) | Structs, Dynamic Arrays, Key-Value Mappings | 🌱 Beginner |
| **04** | **Ether Wallet** | [`Contract 4-EtherWallet.sol`](./Contract%204-EtherWallet.sol) | `payable` Functions, Balance Tracking, Native ETH Transfers | 🌱 Beginner |
| **05** | **Ownable Access Control** | [`Contract 5-OwnableContract.sol`](./Contract%205-OwnableContract.sol) | Custom Modifiers (`onlyOwner`), Role Access, Ownership Transfer | 🌿 Intermediate |
| **06** | **Simple Voting System** | [`Contract 6-SimpleVotingContract.sol`](./Contract%206-SimpleVotingContract.sol) | Address Tracking, Sybil Guard Mappings, Vote Tallying | 🌿 Intermediate |
| **07** | **Time-Locked Wallet** | [`Contract 7-TimeLockedWallet.sol`](./Contract%207-TimeLockedWallet.sol) | `block.timestamp` Guards, Timelock Escrow Releases | 🌿 Intermediate |
| **08** | **Escrow Contract** | [`Contract 8-EscrowContract.sol`](./Contract%208-EscrowContract.sol) | 3-Party Escrow (Buyer, Seller, Arbiter), Approvals & Refunds | 🌿 Intermediate |
| **09** | **Crowdfunding Campaign** | [`Contract 9 – CrowdFundingContract.sol`](./Contract%209%20%E2%80%93%20CrowdFundingContract.sol) | Campaign Timelines, Goal Validation, Contributor Refunds | 🌿 Intermediate |
| **10** | **EVM Event Logger** | [`Contract 10-EventLoggerContract.sol`](./Contract%2010-EventLoggerContract.sol) | EVM Events (`indexed` topics), Off-Chain Telemetry | 🌿 Intermediate |
| **11** | **ERC-20 Token (From Scratch)** | [`Contract 11- ERC20 token.sol`](./Contract%2011-%20ERC20%20token.sol) | Custom ERC-20 (`totalSupply`, `balanceOf`, `allowance`, `transferFrom`) | ⚡ Advanced |
| **12** | **ERC-20 Token (OpenZeppelin)** | [`Contract 12-ERC20 part2.sol`](./Contract%2012-ERC20%20part2.sol) | Standard OpenZeppelin Implementation, Decimals & Initial Supply | 🌿 Intermediate |
| **13** | **Token Faucet** | [`Contract 13-TokenFaucet.sol`](./Contract%2013-TokenFaucet.sol) | `IERC20` Interface Interactions, Rate-Limiting Cooldowns (`1 hours`) | ⚡ Advanced |
| **14** | **Simple Token Staking** | [`Contract 14-StakingContract.sol`](./Contract%2014-StakingContract.sol) | Time-Weighted Yield Calculations, Staking Balances & Rewards | ⚡ Advanced |
| **15** | **Subscription Payment** | [`Contract 15-SubscriptionPaymentContract.sol`](./Contract%2015-SubscriptionPaymentContract.sol) | Recurring Web3 Payments, Expiry Math, Renewal Logic | ⚡ Advanced |
| **23** | **Escrow with Dispute** | [`Contract 23-EscrowWithDispute.sol`](./Contract%2023-EscrowWithDispute.sol) | State Machine (`AWAITING_PAYMENT`, `DISPUTED`), Arbiter Dispute Resolution, Refund/Release Flows | ⚡ Advanced |

---

## 🧠 Core Concepts Covered

> [!NOTE]
> Below are the core technical building blocks demonstrated across the smart contracts:

### 🛡️ 1. Access Control & Authorization
- **Custom Modifiers**: Restricting executive operations using custom modifiers (e.g. `onlyOwner`).
- **Zero-Address Guard**: Protecting smart contracts against unintended ownership transfers to `address(0)`.

### 💸 2. Native ETH & Token Economics
- **Payable Receivers**: Accepting native Ether deposits safely in smart contracts.
- **ERC-20 Standard**: Implementing standard token transfers, allowances, and third-party delegated spending (`transferFrom`).
- **Interface Abstractions**: Interacting dynamically with deployed tokens via standard interfaces (`IERC20`).

### ⏳ 3. Time-Lock & Yield Mechanics
- **Timestamp Validation**: Utilizing `block.timestamp` to lock funds and set strict campaign deadlines.
- **Dynamic Yield Calculations**: Calculating earned yield over time: `reward = (time * rate * balance) / 1e18`.
- **Cooldown Rate-Limiting**: Enforcing claiming delays in faucets to mitigate abuse.

### 📡 4. EVM Events & Off-Chain Indexing
- **Indexed Logging**: Emitting EVM events (`Deposit`, `Withdraw`, `MessageLogged`) with `indexed` parameters for seamless integration with off-chain indexers like The Graph.

### ⚖️ 5. State Machines & Multi-Party Arbitration
- **State Transition Management**: Utilizing explicit `enum` states (`AWAITING_PAYMENT`, `AWAITING_DELIVERY`, `DISPUTED`, `COMPLETE`, `REFUNDED`) to restrict operations and manage contract lifecycle.
- **Third-Party Dispute Resolution**: Empowering neutral arbiters to settle disputes and decide final funds disbursement between buyer and seller.

---

## 📂 Repository Structure

```text
30-Days-of-Smart-Contracts/
├── Contract 1-HelloWorld.sol              # Day 01: Basics & State Variables
├── Contract 2 - CounterContract.sol       # Day 02: State Mutation
├── Contract 3-SimpleStorage.sol           # Day 03: Structs & Mappings
├── Contract 4-EtherWallet.sol             # Day 04: Native ETH Management
├── Contract 5-OwnableContract.sol         # Day 05: Ownership Modifiers
├── Contract 6-SimpleVotingContract.sol    # Day 06: Mappings & Voting Logic
├── Contract 7-TimeLockedWallet.sol        # Day 07: Timelocks & Timestamps
├── Contract 8-EscrowContract.sol          # Day 08: 3-Party Escrow Protocol
├── Contract 9 – CrowdFundingContract.sol  # Day 09: Crowdfunding & Refunds
├── Contract 10-EventLoggerContract.sol    # Day 10: EVM Events & Indexing
├── Contract 11- ERC20 token.sol           # Day 11: Custom ERC-20 Standard
├── Contract 12-ERC20 part2.sol            # Day 12: OpenZeppelin ERC-20 Standard
├── Contract 13-TokenFaucet.sol            # Day 13: Rate-Limited ERC-20 Faucet
├── Contract 14-StakingContract.sol        # Day 14: Yield Staking Engine
├── Contract 15-SubscriptionPaymentContract.sol # Day 15: Subscription Manager
├── Contract 23-EscrowWithDispute.sol      # Day 23: Escrow with Dispute Resolution
├── LICENSE                                # MIT License
└── README.md                              # Project Documentation
```

---

## 🚀 Quick Start & Deployment Guide

### 1. Using Remix IDE (Recommended)
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file under `contracts/` and copy the desired contract code.
3. Select compiler version `^0.8.20` in the **Solidity Compiler** tab.
4. Click **Compile**.
5. Switch to **Deploy & Run Transactions**, select **Injected Provider (MetaMask)** or **Remix VM**, and click **Deploy**.

### 2. Using Hardhat / Foundry

#### Compile with Hardhat:
```bash
npm install --save-dev hardhat @openzeppelin/contracts
npx hardhat compile
```

#### Compile with Foundry:
```bash
forge build
```

---

## 🎯 Challenge Progress Tracker

- [x] **Day 01**: Hello World Contract
- [x] **Day 02**: Counter Contract
- [x] **Day 03**: Simple Storage (Structs & Mappings)
- [x] **Day 04**: Ether Wallet
- [x] **Day 05**: Ownable Access Control
- [x] **Day 06**: Simple Voting System
- [x] **Day 07**: Time-Locked Wallet
- [x] **Day 08**: Escrow Contract
- [x] **Day 09**: Crowdfunding Campaign
- [x] **Day 10**: EVM Event Logger
- [x] **Day 11**: Custom ERC-20 Token
- [x] **Day 12**: OpenZeppelin ERC-20 Token
- [x] **Day 13**: Token Faucet
- [x] **Day 14**: Token Staking Contract
- [x] **Day 15**: Subscription Payment Contract
- [ ] **Days 16–22**: *In Progress / Coming Soon* 🚀
- [x] **Day 23**: Escrow with Dispute Resolution
- [ ] **Days 24–30**: *In Progress / Coming Soon* 🚀

---

## 👨‍💻 Author & License

Developed with ❤️ by **Harsh Jeswani**.

This repository is released under the **MIT License** - see the [LICENSE](./LICENSE) file for details.

---

<div align="center">
  <sub>Built for the Web3 Developer Ecosystem • 2026</sub>
</div>
