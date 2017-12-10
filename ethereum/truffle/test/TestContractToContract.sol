pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ContractToContract1.sol";
import "../contracts/ContractToContract2.sol";

contract TestContractToContract {
  ContractToContract2 contractToContract2 = ContractToContract2(DeployedAddresses.ContractToContract2());

  function testContractToContractFunctionCall() public {
    address addrContractToContract1 = DeployedAddresses.ContractToContract1();
    uint returnedNum = contractToContract2.func2(addrContractToContract1);
    uint expected = 17;
    Assert.equal(returnedNum, expected, "Calling func 2 which calls func 1 which should return 17.");
  }
}
