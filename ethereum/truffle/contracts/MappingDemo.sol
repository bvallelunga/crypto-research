/*
  This contract is going to demonstrate the functionality of
  mappings.
*/
pragma solidity ^0.4.17;

import "./ContractToContract1.sol";

contract MappingDemo {
  // Initialize a mapping.
  mapping (uint => uint) someMapping;

  function insertToMapping(uint key, uint value) public {
    someMapping[key] = value;
  }

  function deleteMappingKey(uint key) public {
    delete someMapping[key];
  }

  function getValueByKeyMapping(uint key) public constant returns(uint) {
    return someMapping[key];
  }
}
