// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasOptimized {

    // ✅ constant (stored in bytecode, no storage cost)
    uint256 public constant MAX_LIMIT = 1000;

    // ✅ immutable (set once in constructor, cheaper than storage)
    address public immutable owner;

    uint256 public total;

    // ✅ mapping for efficient storage
    mapping(address => uint256) public balances;

    // ✅ event (cheaper than storing logs on-chain)
    event Deposited(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // ✅ use calldata instead of memory (saves gas)
    function batchDeposit(uint256[] calldata amounts) external {

        uint256 length = amounts.length;

        for (uint256 i = 0; i < length;) {

            // ✅ cache storage variable
            uint256 amount = amounts[i];

            require(amount <= MAX_LIMIT, "Too large");

            balances[msg.sender] += amount;
            total += amount;

            emit Deposited(msg.sender, amount);

            // ✅ unchecked increment (saves gas)
            unchecked {
                i++;
            }
        }
    }

    // ✅ view function (no gas when called externally)
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    // ❌ inefficient version (for comparison learning)
    function inefficientLoop(uint256[] memory amounts) public {

        for (uint256 i = 0; i < amounts.length; i++) {
            balances[msg.sender] += amounts[i];
        }
    }
}