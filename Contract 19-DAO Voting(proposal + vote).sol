// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleDAO {

    struct Proposal {
        string description;
        uint voteCount;
        bool executed;
    }

    Proposal[] public proposals;

    mapping(uint => mapping(address => bool)) public hasVoted;

    // Create a new proposal
    function createProposal(string memory _description) public {

        proposals.push(
            Proposal({
                description: _description,
                voteCount: 0,
                executed: false
            })
        );
    }

    // Vote on a proposal
    function vote(uint proposalId) public {

        require(!hasVoted[proposalId][msg.sender], "Already voted");

        proposals[proposalId].voteCount += 1;

        hasVoted[proposalId][msg.sender] = true;
    }

    // View proposal details
    function getProposal(uint proposalId) public view returns (
        string memory description,
        uint voteCount,
        bool executed
    ) {
        Proposal memory proposal = proposals[proposalId];

        return (
            proposal.description,
            proposal.voteCount,
            proposal.executed
        );
    }
}