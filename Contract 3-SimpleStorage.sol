//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

contract SimpleStorage {

  uint256 public my_favorite_Number;
  uint256[] list_of_favorite_numbers;
  
  Person[] public listOfPeople;
  struct Person {
    uint256 my_favorite_number;
    string name;
  }
  
   function store(uint256 _favorite_Number) public {
        // the variable favorite number is updated with the value that is contained into the parameter `_favoriteNumber`
        my_favorite_Number = _favorite_Number;
  }
  function retrieve() public view returns(uint256) {
    return my_favorite_Number;
  }

  mapping( string => uint256 ) public nameToFavoriteNumber;
  
  function addPerson(string memory _name, uint256 _favoriteNumber) public {
  listOfPeople.push(Person(_favoriteNumber, _name));
  nameToFavoriteNumber[_name] = _favoriteNumber;
}
}
