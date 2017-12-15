pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DopplerDistributionFunnel_v1.sol";
import "../contracts/DopplerSubLevelDistributionContract_v1.sol";

contract TestDopplerDistributionFunnel_v1 {
  DopplerDistributionFunnel_v1 dopplerDistributionFunnel = DopplerDistributionFunnel_v1(DeployedAddresses.DopplerDistributionFunnel_v1());

  uint public initialBalance = 1 ether;

  address address1 = 0x627306090abab3a6e1400e9345bc60c78a8bef50;
  address address2 = 0xf17f52151ebef6c7334fad080c5704d77216b712;
  address address3 = 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe2;
  address address4 = 0x821aea9a577a9b44299b9c15c88cf3087f3b5541;
  address address5 = 0x627306090abab3a6e1400e9345bc60c78a8bef55;
  address address6 = 0xf17f52151ebef6c7334fad080c5704d77216b736;
  address address7 = 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe7;
  address address8 = 0x821aea9a577a9b44299b9c15c88cf3087f3b5548;
  address address9 = 0x627306090abab3a6e1400e9345bc60c78a8bef59;
  address address10 = 0xf17f52151ebef6c7334fad080c5704d77216b733;
  address address11 = 0xc5fdf4076b8f3a5357c5e395ab970b5b54098f34;
  address address12 = 0x821aea9a577a9b44299b9c15c88cf3087f3b5543;

  address providerAddress = new DopplerSubLevelDistributionContract_v1([address1, address2, address3, address4]);
  address contributorAddress = new DopplerSubLevelDistributionContract_v1([address5, address6, address7, address8]);
  address appOwnerAddress = new DopplerSubLevelDistributionContract_v1([address9, address10, address11, address12]);

  function testAddPipeline() public {

    uint providerPercent = 4;
    uint contributorPercent = 12;
    uint appOwnerPercent = 4;

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

  function testDistributePaymentToContracts() public {
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

    Assert.equal(providerBalance, 4, "Provider balance should be 5.");
    Assert.equal(contributorBalance, 12, "Contributor balance should be 15.");
    Assert.equal(appOwnerBalance, 4, "App Owner balance should be 5.");
    Assert.equal(foundationBalance, 10, "Foundation balance should be 10.");
  }

  function testDistributePaymentToRecipients() public {
    DopplerSubLevelDistributionContract_v1 providerContract = DopplerSubLevelDistributionContract_v1(providerAddress);

    providerContract.distribute();

    uint providerContractBalance = providerContract.balance;
    address providerUserAddress_0 = providerContract.getUserAtIndex(0);
    uint providerUserBalance_0 = providerUserAddress_0.balance;
    address providerUserAddress_1 = providerContract.getUserAtIndex(1);
    uint providerUserBalance_1 = providerUserAddress_1.balance;
    address providerUserAddress_2 = providerContract.getUserAtIndex(2);
    uint providerUserBalance_2 = providerUserAddress_2.balance;
    address providerUserAddress_3 = providerContract.getUserAtIndex(3);
    uint providerUserBalance_3 = providerUserAddress_3.balance;

    Assert.equal(providerContractBalance, 0, "Provider balance should be 0.");
    Assert.equal(providerUserBalance_0, 1, "Provider user balance should be 1.");
    Assert.equal(providerUserBalance_1, 1, "Provider user balance should be 1.");
    Assert.equal(providerUserBalance_2, 1, "Provider user balance should be 1.");
    Assert.equal(providerUserBalance_3, 1, "Provider user balance should be 1.");
  }

  function checkProviders() {

  }
}
