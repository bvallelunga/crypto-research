pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Modifiers.sol";

contract TestModifiers {
  Modifiers modifiers = Modifiers(DeployedAddresses.Modifiers());
  uint public initialBalance = 9 ether;

  function testModifierOnBid() {
    modifiers.bid.value(1)();

    uint balance = modifiers.balance;
    uint expectedBalance = 1;

    uint price = modifiers.getBid();
    uint expectedPrice = 1;

    Assert.equal(balance, expectedBalance, "Contract balance should be 1.");
    Assert.equal(price, expectedPrice, "Bid price should be 1.");
  }

  function testModifierFail() {
    modifiers.bid.value(1)();
    uint balance = modifiers.balance;
    uint expectedBalance = 2;

    uint price = modifiers.getBid();
    uint expectedPrice = 1;

    Assert.equal(balance, expectedBalance, "Contract balance should be 1.");
    Assert.equal(price, expectedPrice, "Bid price should be 2... the payment was accepted but the function did not execute.");
  }

  function testModifierBidUp() {
    modifiers.bid.value(7)();

    uint balance = modifiers.balance;
    uint expectedBalance = 9;

    uint price = modifiers.getBid();
    uint expectedPrice = 7;

    Assert.equal(balance, expectedBalance, "Contract balance should be 7.");
    Assert.equal(price, expectedPrice, "Bid price should be 9.");
  }
}
