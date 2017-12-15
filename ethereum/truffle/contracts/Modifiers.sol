/*
  This contract demonstrates a the use of modifiers.

  Here is the definition of modifiers from solidity docs:

    Modifiers can be used to easily change
    the behaviour of functions. For example,
    they can automatically check a condition
    prior to executing the function. Modifiers
    are inheritable properties of contracts
    and may be overridden by derived contracts.
*/

pragma solidity ^0.4.17;

contract Modifiers {

  // Define state variables
  uint price;

  // Define modifiers
  modifier validBid(uint price) {
      if (msg.value > price) {
          _;
      }
  }

  function Modifiers() {
    price = 0;
  }

  function bid()
  payable
  validBid(price) {
    price = msg.value;
  }

  function getBid() returns (uint) {
    return price;
  }
}
