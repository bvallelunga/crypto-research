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
// Sublevel contract for second level distribution.
import './DopplerSubLevelDistributionContract_v2.sol';

// [PART 3] Title Comment
/// @title Dopple Distribution Funnel

// [PART 4] The contract class constructor.
contract DopplerDistributionFunnel_v2 {

  // [PART 5] State Variables.

  // Since Doppler will be the one initiating this contract,
  // we will use the typical "owner" variable to be
  // the Doppler Foundation.
  address DopplerFoundation;

  // [PART 6] Events.

  // [PART 7] Function Modifiers.

  // [PART 8] Structs/Enums/Mappings.
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
    DopplerSubLevelDistributionContract_v2 provider;
    DopplerSubLevelDistributionContract_v2 contributor;
    DopplerSubLevelDistributionContract_v2 appOwner;

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
    A Payment holds the information according to one payment by a user.
    This is stored since the payment must be "held" while the user
    waits for a prediction result.
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

  /*
    Enum for the different outcomes of a prediction.
    Possible outcomes:

    1) ROUND_1_SUCCESS: consensus passes on first round.
        Providers: PAID
        Contributors: PAID
        App Owner: PAID
        Doppler Foundation: PAID

    2) ROUND_2_SUCCESS: consensus fails first round and passes second round.
        Providers: PAID (only 2nd round)
        Contributors: PAID
        App Owner: PAID
        Doppler Foundation: PAID

    3) BOTH_ROUNDS_FAIL: booth rounds of conensus fail.
        Providers: NONE
        Contributors: NONE
        App Owner: NONE
        Doppler Foundation: NONE

        ^^^ PARTIAL refund for user ^^^

    4) ELSE: for timeouts, etc.
        Providers:
        Contributors:
        App Owner:
        Doppler Foundation:

        ^^^ FULL refund for user ^^^
  */
  enum PredictionOutcome {
    ROUND_1_SUCCESS,
    ROUND_2_SUCCESS,
    BOTH_ROUNDS_FAIL,
    ELSE
  }

  // [PART 9] The smart contract Constructor.
  function DopplerDistributionFunnel_v0() public {
    // The creator of the contract is the Doppler Foundation.
    DopplerFoundation = msg.sender;
  }

  // [PART 10] Other functions.

  // Create a new pipeline.
  function createPipeline(uint pipelineIdentifier, address providerContractAddress,
    address contributorContractAddress, address appOwnerContractAddress, uint providerPercentNum,
    uint contributorPercentNum, uint appOwnerPercentNum) {
    /*require(msg.sender == DopplerFoundation);*/
    /*require(providerPercentNum + contributorPercentNum + appOwnerPercentNum <= 100);*/

    DopplerSubLevelDistributionContract_v2 providerContract = DopplerSubLevelDistributionContract_v2(providerContractAddress);
    DopplerSubLevelDistributionContract_v2 contributorContract = DopplerSubLevelDistributionContract_v2(contributorContractAddress);
    DopplerSubLevelDistributionContract_v2 appOwnerContract = DopplerSubLevelDistributionContract_v2(appOwnerContractAddress);

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
  function createPayment(uint _pipelineId) public payable {

    uint amountSent = msg.value;
    address userAddr = msg.sender;
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
  function getUserPayment() public returns(uint, uint) {
    address userAddr = msg.sender;
    return (escrowMapping[userAddr].amount, escrowMapping[userAddr].pipelineId);
  }

  // Finds the payment object in question and then distributes the
  // payment based on the result.
  // TODO: require that a trusted source made this request.
  function distributePayment(uint outcome) public {

    // Capture sender address
    address userAddr = msg.sender;

    // Get the payment struct
    Payment storage paymentObj = escrowMapping[userAddr];

    // Get the payment amount
    uint amount = paymentObj.amount;

    // Get the pipeline id
    uint pipelineId = paymentObj.pipelineId;

    // Get the pipeline struct
    Pipeline storage pipeline = pipelineMapping[pipelineId];


    uint amountProvider;
    uint amountContributor;
    uint amountAppOwner;
    uint amountFoundation;
    uint amountUser;

    if(outcome == 1) {

      // Calculate the amount each member of the pipeline receives.
      // Split based on Pipeline percentages.
      amountProvider = (pipeline.providerPercent);
      amount -= amountProvider;
      amountContributor = (pipeline.contributorPercent);
      amount -= amountContributor;
      amountAppOwner = (pipeline.appOwnerPercent);
      amount -= amountAppOwner;
      amountFoundation = amount;
      amountUser = 0;

    } else if(outcome == 2) {

      // Calculate the amount each member of the pipeline receives.
      // Split based on Pipeline percentages.
      amountProvider = (pipeline.providerPercent);
      amount -= amountProvider;
      amountContributor = (pipeline.contributorPercent);
      amount -= amountContributor;
      amountAppOwner = (pipeline.appOwnerPercent);
      amount -= amountAppOwner;
      amountFoundation = amount;
      amountUser = 0;

    } else if(outcome == 3) {

      // Calculate the amount each member of the pipeline receives.
      // User gets refunded the Contributors and App Owners amount.
      amountProvider = pipeline.providerPercent;
      amount -= amountProvider;
      amountContributor = 0;
      amountAppOwner = 0;
      amountUser = pipeline.appOwnerPercent + pipeline.contributorPercent;
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
    if(amountProvider != 0) pipeline.provider.transfer(amountProvider);
    if(amountContributor != 0) pipeline.contributor.transfer(amountContributor);
    if(amountAppOwner != 0) pipeline.appOwner.transfer(amountAppOwner);
    /* if(amountUser != 0) userAddr.send(amountUser); */

    // Delete the pending payment from escrowMapping.
    delete escrowMapping[userAddr];
  }

  // [PART 11] The default function.

}
