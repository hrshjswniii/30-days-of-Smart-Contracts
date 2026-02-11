//SPDX-License-Identifier:MIT

pragma solidity ^0.8.20;

contract HelloWorld{
    string public greet = "Hello World!!!";

    function speak() public view returns(string memory){
        return greet;
    }

    function setGreeting(string memory _newGreet) public {
        greet = _newGreet ;
    }
}
