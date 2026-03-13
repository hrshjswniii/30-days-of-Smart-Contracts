// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSigWallet {

    address[] public owners;
    uint public requiredApprovals;

    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint approvalCount;
    }

    Transaction[] public transactions;

    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        bool isOwner = false;

        for(uint i = 0; i < owners.length; i++){
            if(owners[i] == msg.sender){
                isOwner = true;
                break;
            }
        }

        require(isOwner, "Not owner");
        _;
    }

    constructor(address[] memory _owners, uint _requiredApprovals) {
        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }

    function submitTransaction(address _to, uint _value) public onlyOwner {

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                executed: false,
                approvalCount: 0
            })
        );
    }

    function approveTransaction(uint txId) public onlyOwner {

        require(!approved[txId][msg.sender], "Already approved");

        approved[txId][msg.sender] = true;

        transactions[txId].approvalCount += 1;
    }

    function executeTransaction(uint txId) public onlyOwner {

        Transaction storage txn = transactions[txId];

        require(!txn.executed, "Already executed");
        require(txn.approvalCount >= requiredApprovals, "Not enough approvals");

        txn.executed = true;

        payable(txn.to).transfer(txn.value);
    }

    receive() external payable {}
}