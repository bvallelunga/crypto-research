/*
  This contract is the sublevel distribution contract for Doppler.
  It takes in a sum of DOP and then distributes it based on certain
  criteria.
*/
pragma solidity ^0.4.17;

contract DopplerSubLevelDistributionContract_v0 {
  uint private balance;

  function acceptDOP(uint amount) public {
    balance += amount;
  }

  function getBalance() public constant returns(uint) {
    return balance;
  }
}
