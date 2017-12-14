pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DopplerSendFundsToUserFunnel_v0.sol";
import "../contracts/DopplerSubLevelDistributionContract_v0.sol";

contract TestDopplerSendFundsToUserFunnel_v0 {
  DopplerSendFundsToUserFunnel_v0 dopplerDistributionFunnel = DopplerSendFundsToUserFunnel_v0(DeployedAddresses.DopplerSendFundsToUserFunnel_v0());
  uint public initialBalance = 100 ether;

  function testAddPipeline() public {
    uint contractIdentifier = 1010102;
    address[] users;
    address address1 = 0x627306090abab3a6e1400e9345bc60c78a8bef57;
    address address2 = 0xf17f52151ebef6c7334fad080c5704d77216b732;
    address address3 = 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef;
    address address4 = 0x821aea9a577a9b44299b9c15c88cf3087f3b5544;
    users.push(address1);
    users.push(address2);
    users.push(address3);
    users.push(address4);
    uint8[] distributionPercentages;
    distributionPercentages.push(20);
    distributionPercentages.push(60);
    distributionPercentages.push(10);
    distributionPercentages.push(10);


    dopplerDistributionFunnel.createTaskPipeline(contractIdentifier, users,distributionPercentages);

  }

  function testAddPayment() public {
    uint taskPipelineIdentifier = 1010102;
    uint amountSent = 100;
    dopplerDistributionFunnel.createPayment.value(100)(taskPipelineIdentifier, amountSent);
    var (amount, pipelineId) = dopplerDistributionFunnel.getUserPayment();

    uint expectedAmount = 100;
    uint expectedPipelineId = taskPipelineIdentifier;

    Assert.equal(amount, expectedAmount, "Amount should be twenty.");
    Assert.equal(pipelineId, expectedPipelineId, "Pipeline ID should be the one from above.");
  }

  function testDistributePayment() public{
    dopplerDistributionFunnel.distributePayment();
    var (amount, pipelineId) = dopplerDistributionFunnel.getUserPayment();
    uint expectedAmount = 0;
    uint expectedPipelineId = 0;
    Assert.equal(amount, expectedAmount, "Amount should be zero.");
    Assert.equal(pipelineId, expectedPipelineId, "Pipeline ID should be zero, aka deleted.");
    address user0 = 0x627306090abab3a6e1400e9345bc60c78a8bef57;
    address user1 = 0xf17f52151ebef6c7334fad080c5704d77216b732;
    address user2 = 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef;
    address user3 = 0x821aea9a577a9b44299b9c15c88cf3087f3b5544;


    uint user0Balance = user0.balance;
    uint user1Balance = user1.balance;
    uint user2Balance = user2.balance;
    uint user3Balance = user3.balance;


    Assert.equal(user0Balance, 20, "Provider balance should be 20.");
    Assert.equal(user1Balance, 60, "Provider balance should be 60.");
    Assert.equal(user2Balance, 10, "Provider balance should be 10.");
    Assert.equal(user3Balance, 10, "Provider balance should be 10.");

  }
}
