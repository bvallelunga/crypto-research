pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DopplerDistributionFunnel_v0.sol";
import "../contracts/DopplerSubLevelDistributionContract_v0.sol";

contract TestDopplerDistributionFunnel_v0 {
  DopplerDistributionFunnel_v0 dopplerDistributionFunnel = DopplerDistributionFunnel_v0(DeployedAddresses.DopplerDistributionFunnel_v0());

  address providerAddress = new DopplerSubLevelDistributionContract_v0();
  address contributorAddress = new DopplerSubLevelDistributionContract_v0();
  address appOwnerAddress = new DopplerSubLevelDistributionContract_v0();

  function testAddPipeline() public {

    uint providerPercent = 35.0;
    uint contributorPercent = 15.0;
    uint appOwnerPercent = 30.0;

    uint pipelineIdentifier = 1010102;

    dopplerDistributionFunnel.createPipeline(pipelineIdentifier, providerAddress, contributorAddress, appOwnerAddress, providerPercent, contributorPercent, appOwnerPercent);
  }

  function testAddPayment() public {
    uint pipelineIdentifier = 1010102;
    uint amountSent = 100;

    dopplerDistributionFunnel.createPayment(pipelineIdentifier, amountSent);

    var (amount, pipelineId) = dopplerDistributionFunnel.getUserPayment();

    uint expectedAmount = 100;
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

    DopplerSubLevelDistributionContract_v0 providerContract = DopplerSubLevelDistributionContract_v0(providerAddress);
    DopplerSubLevelDistributionContract_v0 contributorContract = DopplerSubLevelDistributionContract_v0(contributorAddress);
    DopplerSubLevelDistributionContract_v0 appOwnerContract = DopplerSubLevelDistributionContract_v0(appOwnerAddress);

    uint providerBalance = providerContract.getBalance();
    uint contributorBalance = contributorContract.getBalance();
    uint appOwnerBalance = appOwnerContract.getBalance();

    uint expectedProviderBalance = 35;
    uint expectedContributorBalance = 15;
    uint expectedAppOwnerBalance = 30;

    Assert.equal(providerBalance, expectedProviderBalance, "Provider balance should be 35.");
    Assert.equal(contributorBalance, expectedContributorBalance, "Contributor balance should be 15.");
    Assert.equal(appOwnerBalance, expectedAppOwnerBalance, "App Owner balance should be 30.");
  }
}
