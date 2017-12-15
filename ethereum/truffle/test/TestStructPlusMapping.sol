pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/StructPlusMapping.sol";

contract TestStructPlusMapping {
  StructPlusMapping structPlusMapping = StructPlusMapping(DeployedAddresses.StructPlusMapping());

  function testGetMappingatIndex() public {
    uint returnedMappingAtZeroDistributor = structPlusMapping.getValueByKeyMapping(0,0);
    uint returnedMappingAtZeroContributor = structPlusMapping.getValueByKeyMapping(0,1);
    uint returnedMappingAtZeroAppOwner = structPlusMapping.getValueByKeyMapping(0,2);

    uint expected = 0;

    Assert.equal(returnedMappingAtZeroDistributor, expected, "Initial zeroth element distributor should be 0, aka empty.");
    Assert.equal(returnedMappingAtZeroContributor, expected, "Initial zeroth element contributor should be 0, aka empty.");
    Assert.equal(returnedMappingAtZeroAppOwner, expected, "Initial zeroth element appOwner should be 0, aka empty.");
  }

  function testPushMapping() public {
    structPlusMapping.insertToMapping(17, 38, 52, 43);

    uint returnedMappingDistributor = structPlusMapping.getValueByKeyMapping(17,0);
    uint returnedMappingContributor = structPlusMapping.getValueByKeyMapping(17,1);
    uint returnedMappingAppOwner = structPlusMapping.getValueByKeyMapping(17,2);

    uint expectedDistributor = 38;
    uint expectedContributor = 52;
    uint expectedAppOwner = 43;

    Assert.equal(returnedMappingDistributor, expectedDistributor, "17th element distributor should be 38, aka empty.");
    Assert.equal(returnedMappingContributor, expectedContributor, "17th element contributor should be 52, aka empty.");
    Assert.equal(returnedMappingAppOwner, expectedAppOwner, "17th element appOwner should be 43, aka empty.");
  }

  function testDeleteMapping() public {
    structPlusMapping.deleteMappingKey(17);

    uint returnedMappingDistributor = structPlusMapping.getValueByKeyMapping(17,0);
    uint returnedMappingContributor = structPlusMapping.getValueByKeyMapping(17,1);
    uint returnedMappingAppOwner = structPlusMapping.getValueByKeyMapping(17,2);

    uint expected = 0;

    Assert.equal(returnedMappingDistributor, expected, "17th element distributor should be 0, aka empty.");
    Assert.equal(returnedMappingContributor, expected, "17th element contributor should be 0, aka empty.");
    Assert.equal(returnedMappingAppOwner, expected, "17th element appOwner should be 0, aka empty.");
  }
}
