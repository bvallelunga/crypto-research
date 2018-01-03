/// @title SubLevelC
pragma solidity ^0.4.17;

contract SubLevelC {
  address[] owners = new address[](1);

  function SubLevelC(address[] owner) {
    owners = owner;
  }

  function returnOwners() returns (address[]) {
    return owners;
  }
}
