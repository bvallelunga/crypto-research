pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payments.sol";

contract TestPayments {
  Payments payments = Payments(DeployedAddresses.Payments());
  uint public initialBalance = 10 ether;

  function testPaymentAndCounterIncrement() {
    Assert.equal(payments.balance, 0, "Contract should have an initial balance of 0.");

    payments.incrementCounter.value(1)();

    uint balanceInitial = payments.balance;
    uint expectedBalanceInitial = 1;

    Assert.equal(balanceInitial, expectedBalanceInitial, "Contract should have received payment and have a balance of 1.");

    payments.incrementCounter.value(1)();
    payments.incrementCounter.value(1)();
    payments.incrementCounter.value(1)();
    payments.incrementCounter.value(1)();
    payments.incrementCounter.value(1)();
    payments.incrementCounter.value(1)();

    uint balanceFinal = payments.balance;
    uint expectedBalanceFinal = 7;

    Assert.equal(balanceFinal, expectedBalanceFinal, "Contract should have received payment and have a balance of 7.");

    uint counter = payments.getCounter();
    uint expectedCounter = 7;
    Assert.equal(counter, expectedCounter, "Counter should be 7.");
  }
}
