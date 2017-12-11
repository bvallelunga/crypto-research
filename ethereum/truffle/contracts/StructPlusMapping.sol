/*
  This contract is going to demonstrate the combination of
  mappings and structs.
*/
pragma solidity ^0.4.17;

contract StructPlusMapping {

  // Initialize the mapping.
  struct Pipeline {
    uint disributor;
    uint contributor;
    uint appOwner;
  }

  // Define the struct.
  // key: uint
  // value: Pipeline
  mapping (uint => Pipeline) pipelines;


  function insertToMapping(uint key, uint disributor, uint contributor, uint appOwner ) public {
    pipelines[key] = Pipeline({
      disributor: disributor,
      contributor: contributor,
      appOwner: appOwner
      });
  }

  function deleteMappingKey(uint key) public {
    delete pipelines[key];
  }

  // Must specify key and then desired value
  function getValueByKeyMapping(uint key, uint returnType) public constant returns(uint) {
    if( returnType == 0) return pipelines[key].disributor;
    else if( returnType == 1) return pipelines[key].contributor;
    return pipelines[key].appOwner;
  }

}
