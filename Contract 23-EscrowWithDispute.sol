// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EscrowDispute {

    address public buyer;
    address public seller;
    address public arbiter;

    uint256 public amount;

    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, DISPUTED, REFUNDED }

    State public currentState;

    constructor(address _seller, address _arbiter) {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        currentState = State.AWAITING_PAYMENT;
    }

    // Buyer deposits ETH
    function deposit() external payable {
        require(msg.sender == buyer, "Only buyer can deposit");
        require(currentState == State.AWAITING_PAYMENT, "Already funded");
        require(msg.value > 0, "Send ETH");

        amount = msg.value;
        currentState = State.AWAITING_DELIVERY;
    }

    // Buyer approves payment
    function confirmDelivery() external {
        require(msg.sender == buyer, "Only buyer");
        require(currentState == State.AWAITING_DELIVERY, "Invalid state");

        currentState = State.COMPLETE;
        payable(seller).transfer(amount);
    }

    // Buyer raises dispute
    function raiseDispute() external {
        require(msg.sender == buyer, "Only buyer");
        require(currentState == State.AWAITING_DELIVERY, "Cannot dispute now");

        currentState = State.DISPUTED;
    }

    // Arbiter resolves dispute → seller wins
    function resolveToSeller() external {
        require(msg.sender == arbiter, "Only arbiter");
        require(currentState == State.DISPUTED, "No dispute");

        currentState = State.COMPLETE;
        payable(seller).transfer(amount);
    }

    // Arbiter resolves dispute → buyer refund
    function refundBuyer() external {
        require(msg.sender == arbiter, "Only arbiter");
        require(currentState == State.DISPUTED, "No dispute");

        currentState = State.REFUNDED;
        payable(buyer).transfer(amount);
    }

    // View contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}