/*
  This contract demonstrates a function where payment is received
  and action is taken (here we increment a counter).
*/

pragma solidity ^0.4.17;

contract Payments {

  uint counter;

  function Payments() {
    counter = 0;
  }

  // Payable means this function can receieve payment.
  function incrementCounter() public payable {
    counter ++;
  }

  function getCounter() public constant returns (uint) {
    return counter;
  }
}
