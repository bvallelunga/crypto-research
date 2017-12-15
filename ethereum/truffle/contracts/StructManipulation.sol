/*
  This contract is going to demonstrate the functionality of
  using structs and a mapping.
*/

pragma solidity ^0.4.17;

contract StructManipulation {

  // Here define the owner, this is common practice in many smart contracts.
  address owner;

  // Here define an instance of the Pipeline. You can treat structs as types.
  Pipeline pipeline;

  // Define the struct. We give it three attributes.
  struct Pipeline{
    uint disributor;
    uint contributor;
    uint appOwner;
  }

  // The constructor function, here we initialize the owner as the one who creates the contract.
  function StructManipulation() public {
    owner = msg.sender;
  }

  // Set function for the pipeline.
  function setPipeline(uint d, uint c, uint a) public {
    pipeline = Pipeline(
      {
        disributor: d,
        contributor: c,
        appOwner: a
      }
    );
  }

  // The following are numerous get functions for the current pipeline instance.

  function getPipelineDistributor() public constant returns(uint) {
    return pipeline.disributor;
  }

  function getPipelineContributor() public constant returns(uint) {
    return pipeline.contributor;
  }

  function getPipelineAppOwner() public constant returns(uint) {
    return pipeline.appOwner;
  }

}
