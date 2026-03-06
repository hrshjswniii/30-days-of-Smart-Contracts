// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract SimpleStaking {

    IERC20 public stakingToken;

    uint256 public rewardRate = 1e16; 
    // reward per token per second (0.01 tokens per second)

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public stakeTimestamp;

    constructor(address _token) {
        stakingToken = IERC20(_token);
    }

    // Stake tokens
    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");

        stakingToken.transferFrom(msg.sender, address(this), _amount);

        stakedBalance[msg.sender] += _amount;
        stakeTimestamp[msg.sender] = block.timestamp;
    }

    // Calculate rewards
    function calculateReward(address _user) public view returns (uint256) {

        uint256 stakingTime = block.timestamp - stakeTimestamp[_user];
        uint256 reward = stakingTime * rewardRate * stakedBalance[_user] / 1e18;

        return reward;
    }

    // Withdraw staked tokens + rewards
    function withdraw() external {

        uint256 staked = stakedBalance[msg.sender];
        require(staked > 0, "No tokens staked");

        uint256 reward = calculateReward(msg.sender);

        stakedBalance[msg.sender] = 0;
        stakeTimestamp[msg.sender] = 0;

        stakingToken.transfer(msg.sender, staked + reward);
    }
}