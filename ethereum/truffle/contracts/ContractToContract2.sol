/*
  This contract is going to demonstrate the functionality of
  communication between two contracts. This is the sending
  contract.
*/
pragma solidity ^0.4.17;

import "./ContractToContract1.sol";

contract ContractToContract2 {
  function func2(address addrCToC1) public constant returns(uint) {
        ContractToContract1 c1 = ContractToContract1(addrCToC1);
        return c1.func1();
    }
}
