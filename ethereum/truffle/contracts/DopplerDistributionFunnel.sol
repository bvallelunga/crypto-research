/*
  This contract is the distribution funnel for Doppler. It acts as a
  sort of payments routing interface between users and the app
  marketplace. It takes a micropayment from a user, holds it while
  a prediction is taking place, and then distributes the payment
  according to the results of the prediction.
*/

// [PART 1] Specify which version of Solidity we want to use.
pragma solidity ^0.4.17;

// [PART 2] Import other Sol files and smart contracts.

// [PART 3] Title Comment
/// @title Dopple Distribution Funnel

// [PART 4] The contract class constructor.
contract DopplerDistributionFunnel {

  // [PART 5] State Variables.

  // Since Doppler will be the one initiating this contract,
  // we will use the typical "owner" variable to be
  // the Doppler Foundation.
  address DopplerFoundation;

  // [PART 6] Events.

  // [PART 7] Function Modifiers.

  // [PART 8] Structs/Enums/Mappings.

  // The possible outcomes for a prediction.
  enum PredictionOutcome {
    SUCCESSFUL,
    ROUND_1_FAIL,
    FAIL,
    ELSE
  }

  /*
    A Pipeline is an object that holds the addresses of the
    different parts of a single payment funnel. Each payment
    will go four places:

    1) Providers
    2) Contributors
    3) App Owners
    4) Doppler Foundation
  */
  struct Pipeline {
    address provider;
    address contributor;
    address appOwner;

    uint providerPercent;
    uint contributorPercent;
    uint appOwnerPercent;

    bool isValue;
  }

  // This data structure maps app identifiers to pipelines.
  // Key: app identifier
  // Value: Pipeline object
  mapping (uint => Pipeline) pipelineMapping;

  /*
    A Pipeline is an object that holds a user payment until
    the prediction results are known. It will then distribute
    the payment down the pipeline. These are the payment
    attributes:

    1) Amount
    2) Pipeline identifier
    3) User address
  */
  struct Payment {
    uint amount;
    uint pipelineId;

    bool isValue;
  }

  // This data structure holds payments in escrow.
  // Key: User Id
  // Value: Payment mapping
  mapping (address => Payment) escrowMapping;


  // [PART 9] The smart contract Constructor.
  function DopplerDistributionFunnel() public {
    // The creator of the contract is the Doppler Foundation.
    DopplerFoundation = msg.sender;
  }

  // [PART 10] Other functions.

  // Create a new pipeline.
  function createPipeline(uint pipelineIdentifier, address providerContract,
    address contributorContract, address appOwnerContract, uint providerPercentNum,
    uint contributorPercentNum, uint appOwnerPercentNum) {
    /*require(msg.sender == DopplerFoundation);*/
    /*require(providerPercentNum + contributorPercentNum + appOwnerPercentNum <= 100);*/
    pipelineMapping[pipelineIdentifier] = Pipeline(
      {
        provider: providerContract,
        contributor: contributorContract,
        appOwner: appOwnerContract,
        providerPercent: providerPercentNum,
        contributorPercent: contributorPercentNum,
        appOwnerPercent: appOwnerPercentNum,
        isValue: true
      });
  }

  // Creates a payment object and holds it in escrow while waiting for the result.
  function createPayment(uint _pipelineId) public payable{
    address userAddr = msg.sender;
    uint amountSent = msg.value;
    uint pipelineIdentifier = _pipelineId;

    // If user already has a payment, delete it
    // TODO: allow for more than 1 payment in escrow per user.
    if(escrowMapping[userAddr].isValue) {
      delete escrowMapping[userAddr];
    }

    escrowMapping[userAddr] = Payment(
      {
        amount: amountSent,
        pipelineId: pipelineIdentifier,
        isValue: true
      });
  }

  // Returns payment info for a given user.
  function getPaymentById() public returns(uint, uint) {
    address userAddr = msg.sender;
    return (escrowMapping[userAddr].amount, escrowMapping[userAddr].pipelineId);
  }

  // Finds the payment object in question and then distributes the
  // payment based on the result.
  // TODO: require that a trusted source made this request.
  function distributePayment(address userAddress) public {
    address userAddr = userAddress;
    Payment storage paymentObj = escrowMapping[userAddr];
    uint amount = paymentObj.amount;
    uint pipelineId = paymentObj.pipelineId;
    Pipeline storage pipeline = pipelineMapping[pipelineId];

    // Calculate the amount each member of the pipeline receives.
    uint amountProvider = amount - (amount * pipeline.providerPercent);
    uint amountContributor = amount - (amount * pipeline.contributorPercent);
    uint amountAppOwner = amount - (amount * pipeline.appOwnerPercent);
    uint amountFoundation = amount;

    // Distribute the funds.
    pipeline.provider.transfer(amountProvider);
    pipeline.contributor.transfer(amountContributor);
    pipeline.appOwner.transfer(amountAppOwner);
    DopplerFoundation.transfer(amountFoundation);
  }

  // [PART 11] The default function.

}
