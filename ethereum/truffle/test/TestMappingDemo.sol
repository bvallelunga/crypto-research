pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MappingDemo.sol";

contract TestMappingDemo {
  MappingDemo mappingDemo = MappingDemo(DeployedAddresses.MappingDemo());

  function testGetMappingatIndex() public {
    uint returnedMappingAtZero = mappingDemo.getValueByKeyMapping(0);
    uint expected = 0;
    Assert.equal(returnedMappingAtZero, expected, "Initial zeroth element should be 0, aka empty.");
  }

  function testPushMapping() public {
    mappingDemo.insertToMapping(0, 17);
    uint returnedMappingAtZero = mappingDemo.getValueByKeyMapping(0);
    uint expected = 17;
    Assert.equal(returnedMappingAtZero, expected, "Zeroth element should be 17 after inserting an element.");
  }

  function testDeleteMapping() public {
    mappingDemo.deleteMappingKey(0);
    uint returnedMappingAtZero = mappingDemo.getValueByKeyMapping(0);
    uint expected = 0;
    Assert.equal(returnedMappingAtZero, expected, "Zeroth element should be 0, aka empty, after deletion.");
  }
}
