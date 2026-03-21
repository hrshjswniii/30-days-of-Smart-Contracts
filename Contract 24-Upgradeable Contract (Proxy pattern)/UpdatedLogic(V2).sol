// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogicV2 {

    uint public value;

    function setValue(uint _value) public {
        value = _value * 2; // upgraded logic
    }
}
