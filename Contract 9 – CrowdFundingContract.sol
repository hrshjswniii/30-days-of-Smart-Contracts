// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFunding {

    address public creator;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;

    mapping(address => uint256) public contributions;

    bool public goalReached;
    bool public withdrawn;

    construct256 _goal, uint256 _durationInSeconds){
      creator = msg.sender;
      goal = _oal;
      deadline = block.timestamp + _durationInSeconds;
      }

      // Contribute ETH to the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Send some ETH");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        if (totalRaised >= goal) {
            goalReached = true;
        }
    }

    // Creator withdraws funds if goal reached
    function withdrawFunds() external {
        require(msg.sender == creator, "Not creator");
        require(goalReached, "Goal not reached");
        require(!withdrawn, "Already withdrawn");

        withdrawn = true;

        payable(creator).transfer(address(this).balance);
    }

    // Contributors get refund if goal not reached
    function refund() external {
        require(block.timestamp >= deadline, "Campaign still active");
        require(!goalReached, "Goal was reached");

        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contribution");

        contributions[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

    
    
    
