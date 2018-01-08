/* /// @title SubLevelC
pragma solidity ^0.4.17;

import './SubLevelC.sol';

contract DistributorC {
  address public dopplerFoundation;
  mapping (uint => Task) taskMapping;
  mapping (uint => Payment) escrowMapping;

  struct Task {
    SubLevelC provider;
    SubLevelC contributor;
    SubLevelC appOwner;

    uint providerPercent;
    uint contributorPercent;
    uint appOwnerPercent;

    bool isValue;
  }

  struct Payment {
    uint amount;
    uint taskID;
    address userAddress;

    bool isValue;
  }

  function DistributorC() {
    dopplerFoundation = msg.sender;
  }

  // Creates a payment object and holds it in escrow while waiting for the result.
  function addPayment(uint _taskID, uint _tempPaymentID) {

    uint amountSent = msg.value;
    address userAddr = msg.sender;
    uint taskID = _taskID;
    uint tempPaymentID = _tempPaymentID;

    escrowMapping[1] = Payment(
      {
        amount: amountSent,
        taskID: _taskID,
        userAddress: userAddr,
        isValue: true
      });
  }

  // Returns payment info for a given user.
  function getUserPayment(uint _tempPaymentID) public returns(uint, uint, address, bool) {
    Payment userPayment = escrowMapping[1];
    return (userPayment.amount, userPayment.taskID, userPayment.userAddress, userPayment.isValue);
  }
} */
