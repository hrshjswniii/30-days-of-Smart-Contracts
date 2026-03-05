// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenFaucet {

    IERC20 public token;
    uint256 public dripAmount = 10 * 10**18; // 10 tokens per claim
    uint256 public cooldown = 1 hours;

    mapping(address => uint256) public lastClaim;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function requestTokens() external {

        require(
            block.timestamp >= lastClaim[msg.sender] + cooldown,
            "Wait before requesting again"
        );

        lastClaim[msg.sender] = block.timestamp;

        require(
            token.transfer(msg.sender, dripAmount),
            "Token transfer failed"
        );
    }
}