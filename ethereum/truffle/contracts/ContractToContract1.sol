/*
  This contract is going to demonstrate the functionality of
  communication between two contracts. This is the receiving
  contract.
*/
pragma solidity ^0.4.17;

contract ContractToContract1 {
  function func1() public constant returns(uint) {
    return 17;
  }
}
