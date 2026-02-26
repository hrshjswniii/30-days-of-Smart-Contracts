// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleVoting {

    // Vote counts
    uint public votesForA;
    uint public votesForB;

    // Track if an address has voted
    mapping(address => bool) public hasVoted;

    // Vote for Candidate A
    function voteForA() public {
        require(!hasVoted[msg.sender], "Already voted");

        votesForA += 1;
        hasVoted[msg.sender] = true;
    }

    // Vote for Candidate B
    function voteForB() public {
        require(!hasVoted[msg.sender], "Already voted");

        votesForB += 1;
        hasVoted[msg.sender] = true;
    }

    // Get total votes
    function getTotalVotes() public view returns (uint) {
        return votesForA + votesForB;
    }
}
