# Truffle &rarr; Framework for Dapp Development

As of right now, it looks like Truffle is a great framework for building and testing smart contracts.

### Contract List
1. HelloWorld -- get/set a number <br/>
2. StructManipulation -- demonstrate how to instantiate a struct <br/>
3. MappingDemo -- demonstrate how insert/delete/get a mapping <br/>
4. ContractToContract1 (receiving contract) -- demonstrate contract to contract interaction <br/>
5. ContractToContract2 (sending contract) -- demonstrate contract to contract interaction <br/>
6. StructPlusMapping -- demonstrate a combination of mapping and struct <br/>
7. DopplerDistributionFunnel_v0 -- Version 0 of the distribution payment routing contract setup by the Doppler Foundation <br/>
8. DopplerSubLevelDistributionContract_v0 -- Version 0 of the multi-use contract for Providers, Contributors, and App Owners <br/>
9. Payments -- demonstrate how payable functions work
10. Modifiers -- demonstrate how modifiers work on functions

Install the NPM package.
```
npm install - truffle
```

Enter the Truffle Develop Console.
```
Truffle develop
```

Compile, migrate, and test the code.
```
compile
migrate
test
```

### Milestone List
- [x] Hello World Contract
- [x] Structs
- [x] Mapping
- [x] Contract to Contract
- [x] Mapping and Struct
- [x] Mapping and Struct with addresses
- [x] Mapping and Struct with addresses Contract to Contract
- [ ] Proper types (w/ correct private/public/external/internal)
- [x] Modifiers
- [ ] Events
- [x] Send Payments
- [ ] Proper Percentages by sublevel contract
- [ ] Prevent reentrancy: Reference: http://bit.ly/2nUbR8d
