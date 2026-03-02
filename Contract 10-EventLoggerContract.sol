// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EventLogger {

    mapping(address => uint256) public balances;

    // 🔔 Event definitions
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event MessageLogged(address indexed sender, string message, uint256 timestamp);

    // Deposit ETH and emit event
    function deposit() external payable {
        require(msg.value > 0, "Send ETH");

        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ETH and emit event
    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Invalid amount");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;

        payable(msg.sender).transfer(_amount);

        emit Withdraw(msg.sender, _amount);
    }

    // Log a custom message
    function logMessage(string memory _message) external {
        emit MessageLogged(msg.sender, _message, block.timestamp);
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
