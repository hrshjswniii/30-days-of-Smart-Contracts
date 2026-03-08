// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionPayment {

    address public owner;
    uint256 public subscriptionPrice = 0.01 ether;
    uint256 public subscriptionDuration = 30 days;

    mapping(address => uint256) public subscriptionExpiry;

    constructor() {
        owner = msg.sender;
    }

    // Subscribe to service
    function subscribe() external payable {
        require(msg.value >= subscriptionPrice, "Insufficient payment");

        subscriptionExpiry[msg.sender] = block.timestamp + subscriptionDuration;
    }

    // Renew subscription
    function renewSubscription() external payable {
        require(msg.value >= subscriptionPrice, "Insufficient payment");

        if (subscriptionExpiry[msg.sender] > block.timestamp) {
            subscriptionExpiry[msg.sender] += subscriptionDuration;
        } else {
            subscriptionExpiry[msg.sender] = block.timestamp + subscriptionDuration;
        }
    }

    // Check if subscription is active
    function isSubscribed(address user) public view returns (bool) {
        return subscriptionExpiry[user] >= block.timestamp;
    }

    // Owner withdraws collected payments
    function withdraw() external {
        require(msg.sender == owner, "Not owner");

        payable(owner).transfer(address(this).balance);
    }
}