//This contract handles sending funds from contracts to an array of users addresses.
pragma solidity ^0.4.17;

import './DopplerSubLevelDistributionContract_v0.sol';

contract DopplerSendFundsToUserFunnel_v0 {

  //source contract
  address source;

  struct ContractUserTask {
    address[] users;

    uint8[] distributionPercent;

    bool isValue;
  }

  //mapping a contract id to the pipeline
  mapping(uint => ContractUserTask) taskMapping;

  struct Payment {
    uint amount;
    uint pipelineId;

    bool isValue;
  }

  mapping (address => Payment) escrowMapping;

  function DopplerSubLevelDistributionContract_v0() public {
    //the creator of the contract will be Doppler foundation again.
    source = msg.sender;
  }

  function createTaskPipeline(uint contractIdentifier, address[] userAddresses, uint8[] distributionPercentages ) public {
    taskMapping[contractIdentifier] = ContractUserTask(
        {
          users: userAddresses,
          distributionPercent: distributionPercentages,
          isValue: true
        }
      );

  }

  function createPayment(uint taskPipelineId, uint amountSent) public payable {
    address contractAddr = msg.sender;
    uint taskPipelineIdentifier = taskPipelineId;

    // If user already has a payment, delete it
    // TODO: allow for more than 1 payment in escrow per user.
    if(escrowMapping[contractAddr].isValue) {
      delete escrowMapping[contractAddr];
    }

    escrowMapping[contractAddr] = Payment(
      {
        amount: amountSent,
        pipelineId: taskPipelineIdentifier,
        isValue: true
      });
  }

  function getUserPayment() public returns(uint, uint) {
    address userAddr = msg.sender;
    return (escrowMapping[userAddr].amount, escrowMapping[userAddr].pipelineId);
  }

  function distributePayment() public {
    address contractAddr = msg.sender;

    Payment storage paymentObj = escrowMapping[contractAddr];

    uint amount = paymentObj.amount;
    uint pipelineId = paymentObj.pipelineId;

    ContractUserTask storage pipeline = taskMapping[pipelineId];
    uint8[] storage distributionPercent = (pipeline.distributionPercent);
    for(uint8 i = 0; i< pipeline.users.length; i++) {
      amount -= distributionPercent[i];

      pipeline.users[i].transfer(distributionPercent[i]);
    }

    delete escrowMapping[contractAddr];
  }

}
