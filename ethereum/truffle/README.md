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
9. Payments -- demonstrate how payable functions work <br />
10. Modifiers -- demonstrate how modifiers work on functions <br />
11. DopplerSubLevelDistributionContract_v1 -- distribute money down the entire pipeline <br/>
12. DopplerSubLevelDistributionContract_v2 -- distribute money based on consensus result <br/>

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

### Milestone List (12/20)
- [x] Hello World Contract
- [x] Structs
- [x] Mapping
- [x] Contract to Contract
- [x] Mapping and Struct
- [x] Mapping and Struct with addresses
- [x] Mapping and Struct with addresses Contract to Contract
- [x] Modifiers
- [x] Send Payments
- [x] Distribution from Sub Level contracts
- [x] Send money &rarr; Mapping and Struct with addresses Contract to Contract
- [x] Distribute based on prediction result
- [ ] Events
- [ ] Proper types (w/ correct private/public/external/internal)
- [ ] Dynamically sized arrays for sub level contracts user arrays
- [ ] Proper Percentages by sublevel contract
- [ ] Enums
- [ ] Send payment to external Doppler Foundation address
- [ ] Actually refund payment back to user
- [ ] DOP ICO contract
