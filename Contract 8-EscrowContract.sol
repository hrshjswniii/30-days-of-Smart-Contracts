// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {

    address public buyer;
    address public seller;
    address public arbiter;   // Optional mediator
    uint256 public amount;

    bool public isApproved;
    bool public isDeposited;

    constructor(address _seller, address _arbiter) payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;

        require(msg.value > 0, "Send ETH to start escrow");
        amount = msg.value;
        isDeposited = true;
    }

    // Buyer approves the release of funds
    function approve() external {
        require(msg.sender == buyer || msg.sender == arbiter, "Not authorized");
        require(isDeposited, "No funds deposited");
        require(!isApproved, "Already approved");

        isApproved = true;

        payable(seller).transfer(amount);
    }

    // Refund buyer (only arbiter can trigger refund)
    function refund() external {
        require(msg.sender == arbiter, "Only arbiter can refund");
        require(isDeposited, "No funds deposited");
        require(!isApproved, "Already approved");

        payable(buyer).transfer(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
