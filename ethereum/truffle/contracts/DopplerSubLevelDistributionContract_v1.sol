/*
  This contract is the sublevel distribution contract for Doppler.
  It takes in a sum of DOP and then distributes it based on certain
  criteria.
*/
/// @title Dopple Distribution Sub Level
pragma solidity ^0.4.17;

contract DopplerSubLevelDistributionContract_v1 {

  // Define state variables
  address[4] usersToPay;

  // Define modifiers
  modifier validIndex(uint index) {
      if ( usersToPay.length > index) {
          _;
      }
  }

  function DopplerSubLevelDistributionContract_v1(address[4] users) {
    usersToPay = users;
  }

  function distribute() {
    uint distributionAmount = this.balance/usersToPay.length;
    for( uint i = 0 ; i < usersToPay.length ; i++ ) {
      usersToPay[i].transfer(distributionAmount);
    }
  }

  function getUserAtIndex(uint index)
    validIndex(index)
    returns(address) {
      return usersToPay[index];
  }

  function () payable {

  }
}
