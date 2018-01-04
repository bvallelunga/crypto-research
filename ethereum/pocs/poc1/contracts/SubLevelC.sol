/// @title SubLevelC
pragma solidity ^0.4.17;

contract SubLevelC {
  address[] private payoutAddresses;
  address public owner;

  modifier isOwner() {
      if ( owner == msg.sender) {
          _;
      }
  }

  function SubLevelC(address[] initialPayoutAddresses) {
    owner = msg.sender;
    payoutAddresses = initialPayoutAddresses;
  }

  function addOwner(address payoutAddress)
  isOwner()
  {
    payoutAddresses.push(payoutAddress);
  }

  function removePayoutAddress(address payoutAddress)
  isOwner()
  {
    for (uint i = 0; i < payoutAddresses.length; i ++) {
      if (payoutAddresses[i] == payoutAddress) {
        delete payoutAddresses[i];
        payoutAddresses.length --;
        return;
      }
    }
  }

  function returnPayoutAddresses()
  isOwner()
  returns (address[]) {
    return payoutAddresses;
  }

  function distribute()
  isOwner() {
    uint sendAmount = this.balance/payoutAddresses.length;
    for (uint i = 0; i < payoutAddresses.length; i ++) {
      payoutAddresses[i].transfer(sendAmount);
    }
  }

  function () payable {}
}
