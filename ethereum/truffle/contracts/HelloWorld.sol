/*
  While this is obviously overkill for production code, I am going to use a
  generous amount of comments with this first contract to establish the
  reasoning behind certain choices and also highlight the basic structure
  of a smart contract for anyone who may, in the future look at this crypto
  research folder.
*/

// [PART 1] Specify which version of Solidity we want to use.
pragma solidity ^0.4.17;

// [PART 2] Import other Sol files and smart contracts.

// [PART 3] Title Comment
/// @title Hello World

// [PART 4] The contract class constructor.
contract HelloWorld {

  /*
    [PART 5] State Variables.

    There are three basic parts to a state variable.

    1) Type
    2) Public/Private/External/Inherited
    3) Variable Name
  */
  uint private greeting;

  // [PART 6] Events.
  // Used to log values in the interface, useful for debugging.

  // [PART 7] Function Modifiers.
  // Way to put restrictions on certain functions i.e. only owner can do x.

  // [PART 8] Structs/Enums/Mappings.

  // [PART 9] The smart contract Constructor.
  function HelloWorld() public {

  }

  // [PART 10] Other functions.
  function setGreeting(uint newGreeting) public {
    greeting = newGreeting;
  }

  function getGreeting() public constant returns (uint) {
    return greeting;
  }

  // [PART 11] The default function.

}
