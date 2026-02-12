//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

contract CounterContract{

    uint256 public count ; // state variable to store count variable

    /* @dev Function to get the current count 
       public visibility already creates a getter function but it's okay to create an explicit one
    */
    function getCount() public view returns(uint256){
        return count;
    }

    /* @dev Function to increment the counter by 1 */
    
    function increment() public returns(uint256){
        count+=1;
        return count;
    }
    
    
    /* @dev Function to decrement the counter by 1 */
    function decrement() public returns(uint256){
        count-=1;
        return count;
    }

    
    /* @dev Function to reset the value to 0, or anything user likes to */
    function reset() public returns(uint256){
        count=0;
        return count;
    }


}
