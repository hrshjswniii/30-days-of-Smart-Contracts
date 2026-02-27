// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OwnableExample {

    address public owner;
    uint public value;

    // Set deployer as owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Only owner can change value
    function setValue(uint _newValue) public onlyOwner {
        value = _newValue;
    }

    // Anyone can read value
    function getValue() public view returns (uint) {
        return value;
    }

    // Transfer ownership to new address
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }
}
