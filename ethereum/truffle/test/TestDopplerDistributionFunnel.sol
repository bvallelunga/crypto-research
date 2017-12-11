pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DopplerDistributionFunnel.sol";

contract TestDopplerDistributionFunnel {
  DopplerDistributionFunnel dopplerDistributionFunnel = DopplerDistributionFunnel(DeployedAddresses.DopplerDistributionFunnel());

  function testInitialState() public {

  }

  function testAddPipeline() public {
    address providerAddress = 0x627306090abab3a6e1400e9345bc60c78a8bef57;
    address contributorAddress = 0xf17f52151ebef6c7334fad080c5704d77216b732;
    address appOwnerAddress = 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef;

    uint providerPercent = 35.0;
    uint contributorPercent = 15.0;
    uint appOwnerPercent = 30.0;

    uint pipelineIdentifier = 1010102;

    dopplerDistributionFunnel.createPipeline(pipelineIdentifier, providerAddress, contributorAddress, appOwnerAddress, providerPercent, contributorPercent, appOwnerPercent);

  }

  function testAddPayment() public {
    uint pipelineIdentifier = 1010102;

    dopplerDistributionFunnel.createPayment(pipelineIdentifier);

    var (amount, pipelineId) = dopplerDistributionFunnel.getPaymentById();

    uint expectedAmount = 0;
    uint expectedPipelineId = pipelineIdentifier;

    Assert.equal(amount, expectedAmount, "Amount should be zero???");
    Assert.equal(pipelineId, expectedPipelineId, "Pipeline ID should be the one from above.");
  }

  function testDistributePayment() public {

  }
}
