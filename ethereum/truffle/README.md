# Truffle &rarr; Framework for Dapp Development

As of right now, it looks like Truffle is a great framework for building and testing smart contracts.

### Contract List
a) HelloWorld -- get/set a number <br/>
b) StructManipulation -- demonstrate how to instantiate a struct <br/>
c) MappingDemo -- demonstrate how insert/delete/get a mapping <br/>
d) ContractToContract1 (receiving contract) -- demonstrate contract to contract interaction <br/>
e) ContractToContract2 (sending contract) -- demonstrate contract to contract interaction <br/>
f) StructPlusMapping -- demonstrate a combination of mapping and struct <br/>
g) DopplerDistributionFunnel_v0 -- Version 0 of the distribution payment routing contract setup by the Doppler Foundation <br/>
h) DopplerSubLevelDistributionContract_v0 -- Version 0 of the multi-use contract for Providers, Contributors, and App Owners <br/>

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
- [ ] Modifiers
- [ ] Events
- [ ] Send Payments
- [ ] Proper Percentages by sublevel contract
