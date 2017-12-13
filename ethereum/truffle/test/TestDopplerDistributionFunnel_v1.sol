pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DopplerDistributionFunnel_v1.sol";
import "../contracts/DopplerSubLevelDistributionContract_v1.sol";

contract TestDopplerDistributionFunnel_v1 {
  DopplerDistributionFunnel_v1 dopplerDistributionFunnel = DopplerDistributionFunnel_v1(DeployedAddresses.DopplerDistributionFunnel_v1());

  uint public initialBalance = 30 ether;

  address providerAddress = new DopplerSubLevelDistributionContract_v1();
  address contributorAddress = new DopplerSubLevelDistributionContract_v1();
  address appOwnerAddress = new DopplerSubLevelDistributionContract_v1();

  function testAddPipeline() public {

    uint providerPercent = 5;
    uint contributorPercent = 15;
    uint appOwnerPercent = 5;

    uint pipelineIdentifier = 1010102;

    dopplerDistributionFunnel.createPipeline(pipelineIdentifier, providerAddress, contributorAddress, appOwnerAddress, providerPercent, contributorPercent, appOwnerPercent);
  }

  function testAddPayment() public {
    uint pipelineIdentifier = 1010102;
    uint amountSent = 30;

    dopplerDistributionFunnel.createPayment.value(amountSent)(pipelineIdentifier);

    var (amount, pipelineId) = dopplerDistributionFunnel.getUserPayment();

    uint expectedAmount = 30;
    uint expectedPipelineId = pipelineIdentifier;

    Assert.equal(amount, expectedAmount, "Amount should be twenty.");
    Assert.equal(pipelineId, expectedPipelineId, "Pipeline ID should be the one from above.");
  }

  function testDistributePayment() public {
    dopplerDistributionFunnel.distributePayment();

    var (amount, pipelineId) = dopplerDistributionFunnel.getUserPayment();

    uint expectedAmount = 0;
    uint expectedPipelineId = 0;

    Assert.equal(amount, expectedAmount, "Amount should be zero.");
    Assert.equal(pipelineId, expectedPipelineId, "Pipeline ID should be zero, aka deleted.");

    DopplerSubLevelDistributionContract_v1 providerContract = DopplerSubLevelDistributionContract_v1(providerAddress);
    DopplerSubLevelDistributionContract_v1 contributorContract = DopplerSubLevelDistributionContract_v1(contributorAddress);
    DopplerSubLevelDistributionContract_v1 appOwnerContract = DopplerSubLevelDistributionContract_v1(appOwnerAddress);

    uint providerBalance = providerContract.balance;
    uint contributorBalance = contributorContract.balance;
    uint appOwnerBalance = appOwnerContract.balance;
    uint foundationBalance = dopplerDistributionFunnel.balance;

    Assert.equal(providerBalance, 5, "Provider balance should be 5.");
    Assert.equal(contributorBalance, 15, "Contributor balance should be 15.");
    Assert.equal(appOwnerBalance, 5, "App Owner balance should be 5.");
    Assert.equal(foundationBalance, 5, "Foundation balance should be 10.");
  }
}
