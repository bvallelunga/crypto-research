/// @title SubLevelC
pragma solidity ^0.4.17;

import './SubLevelC.sol';

contract DistributorC {
  address public dopplerFoundation;
  mapping (uint => Task) taskMapping;
  mapping (uint => Payment) escrowMapping;

  struct Task {
    address provider;
    address contributor;
    address appOwner;

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

  modifier isOwner() {
      if ( dopplerFoundation == msg.sender) {
          _;
      }
  }

  function DistributorC() {
    dopplerFoundation = msg.sender;
  }

  // Creates a payment object and holds it in escrow while waiting for the result.
  function addPayment(uint _taskID, uint _tempPaymentID) payable {

    uint amountSent = msg.value;
    address userAddr = msg.sender;
    uint taskID = _taskID;
    uint tempPaymentID = _tempPaymentID;

    escrowMapping[_tempPaymentID] = Payment(
      {
        amount: amountSent,
        taskID: _taskID,
        userAddress: userAddr,
        isValue: true
      });
  }

  // Returns payment info for a given user.
  function getUserPayment(uint _tempPaymentID) public returns(uint, uint, address, bool) {
    Payment userPayment = escrowMapping[_tempPaymentID];
    return (userPayment.amount, userPayment.taskID, userPayment.userAddress, userPayment.isValue);
  }

  // Creates a payment object and holds it in escrow while waiting for the result.
  function addTask(uint _taskID, address _providerAddress, address _contributorAddress, address _appOwnerAddress, uint _providerPercent, uint _contributorPercent, uint _appOwnerPercent)
  isOwner() {
    taskMapping[_taskID] = Task(
      {
         provider: _providerAddress,
         contributor: _contributorAddress,
         appOwner: _appOwnerAddress,
         providerPercent: _providerPercent,
         contributorPercent: _contributorPercent,
         appOwnerPercent: _appOwnerPercent,
         isValue: true
      });
  }

  // Returns payment info for a given user.
  function getTask(uint _taskID) returns(address, address, address, uint, uint, uint, bool) {
    Task task = taskMapping[_taskID];
    return (task.provider, task.contributor, task.appOwner, task.providerPercent, task.contributorPercent, task.appOwnerPercent, task.isValue);
  }

  function distributePayment(uint outcome, uint paymentID) public {

    // Capture sender address
    address userAddr = msg.sender;

    // Get the payment struct
    Payment storage paymentObj = escrowMapping[paymentID];

    // Get the payment amount
    uint amount = paymentObj.amount;

    // Get the pipeline id
    uint taskID = paymentObj.taskID;

    // Get the pipeline struct
    Task task = taskMapping[taskID];


    uint amountProvider;
    uint amountContributor;
    uint amountAppOwner;
    uint amountFoundation;
    uint amountUser;

    if(outcome == 1) {

      // Calculate the amount each member of the pipeline receives.
      // Split based on Pipeline percentages.
      amountProvider = (task.providerPercent);
      amount -= amountProvider;
      amountContributor = (task.contributorPercent);
      amount -= amountContributor;
      amountAppOwner = (task.appOwnerPercent);
      amount -= amountAppOwner;
      amountFoundation = amount;
      amountUser = 0;

    } else if(outcome == 2) {

      // Calculate the amount each member of the pipeline receives.
      // Split based on Pipeline percentages.
      amountProvider = (task.providerPercent);
      amount -= amountProvider;
      amountContributor = (task.contributorPercent);
      amount -= amountContributor;
      amountAppOwner = (task.appOwnerPercent);
      amount -= amountAppOwner;
      amountFoundation = amount;
      amountUser = 0;

    } else if(outcome == 3) {

      // Calculate the amount each member of the pipeline receives.
      // User gets refunded the Contributors and App Owners amount.
      amountProvider = task.providerPercent;
      amount -= amountProvider;
      amountContributor = 0;
      amountAppOwner = 0;
      amountUser = task.appOwnerPercent + task.contributorPercent;
      amount -= amountUser;
      amountFoundation = amount;

    } else if(outcome == 4) {

      // Calculate the amount each member of the pipeline receives.
      // Full refund to the user.
      amountProvider = 0;
      amountContributor = 0;
      amountAppOwner = 0;
      amountFoundation = 0;
      amountUser = amount;

    }

    // Distribute the funds.
    if(amountProvider != 0) task.provider.transfer(amountProvider);
    if(amountContributor != 0) task.contributor.transfer(amountContributor);
    if(amountAppOwner != 0) task.appOwner.transfer(amountAppOwner);
    if(amountUser != 0) userAddr.send(amountUser);

    // Delete the pending payment from escrowMapping.
    delete escrowMapping[paymentID];
  }

  // Distributes payment based on outcome
}
