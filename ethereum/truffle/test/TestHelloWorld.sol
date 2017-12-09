pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract TestHelloWorld {
  HelloWorld helloWorld = HelloWorld(DeployedAddresses.HelloWorld());

  // Testing the adopt() function
  function testSetGreeting() {
    uint i_returnedGreeting = helloWorld.getGreeting();
    Assert.isZero(i_returnedGreeting, "Get Greeting message expected to be 0, or undefined, initially.");

    helloWorld.setGreeting(17);
    uint returnedGreeting = helloWorld.getGreeting();
    uint expected = 17;
    Assert.equal(returnedGreeting, expected, "Get Greeting message expected to be 17 after setMessage called.");
  }
}
