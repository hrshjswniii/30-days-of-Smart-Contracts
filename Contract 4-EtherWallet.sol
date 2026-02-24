// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EtherWallet {

    // Stores ETH balance of each user
    mapping(address => uint256) public balances;

    // Deposit ETH into contract
    function deposit() external payable {
        require(msg.value > 0, "Send ETH");
        balances[msg.sender] += msg.value;
    }

    // View your balance stored in contract
    function myBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    
