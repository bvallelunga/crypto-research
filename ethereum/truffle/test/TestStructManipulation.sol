pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/StructManipulation.sol";

contract TestStructManipulation {
  StructManipulation structManipulation = StructManipulation(DeployedAddresses.StructManipulation());



  function testSetStruct() public {
    structManipulation.setPipeline(1,2,3);

    uint distributor = structManipulation.getPipelineDistributor();
    uint contributor = structManipulation.getPipelineContributor();
    uint appOwner = structManipulation.getPipelineAppOwner();

    uint expectedDistributor = 1;
    uint expectedContributor = 2;
    uint expectedAppOwner = 3;

    Assert.equal(distributor, expectedDistributor, "Get Pipeline distributor expected to be 1 after setPipeline called.");
    Assert.equal(contributor, expectedContributor, "Get Pipeline contributor expected to be 2 after setPipeline called.");
    Assert.equal(appOwner, expectedAppOwner, "Get Pipeline appOwner expected to be 3 after setPipeline called.");
  }
}
