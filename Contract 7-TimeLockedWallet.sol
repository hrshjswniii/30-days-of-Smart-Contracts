// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockedWallet {

    address public owner;
    uint public unlockTime;

    // Contract must be deployed with ETH
    constructo(uint _unlockTime) payable {
      require(_unlockTime > block.timestamp, "Unlock time must be in future");

        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    // Check contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Withdraw funds after unlock time
    function withdraw() public {
        require(msg.sender == owner, "Not the owner");
        require(block.timestamp >= unlockTime, "Funds are still locked");

        payable(owner).transfer(address(this).balance);
    }
}
