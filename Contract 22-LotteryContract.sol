// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lottery {

    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    // Enter lottery by sending ETH
    function enter() public payable {
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH required");

        players.push(msg.sender);
    }

    // Generate pseudo random number
    function random() private view returns (uint) {
        return uint(
            keccak256(
                abi.encodePacked(block.timestamp, players.length)
            )
        );
    }

    // Pick winner
    function pickWinner() public {

        require(msg.sender == manager, "Only manager can pick winner");
        require(players.length > 0, "No players in lottery");

        uint index = random() % players.length;

        address winner = players[index];

        payable(winner).transfer(address(this).balance);

        // reset lottery
        players = new address;
    }

    // View players
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}