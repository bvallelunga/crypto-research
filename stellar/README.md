# Using Stellar

As an intern now at Stellar, I have become more familiar with the inner workings of transactions on the Stellar system. I believe it may actually be easier, faster, and cheaper to implement the distribution model using Stellar over Ethereum.

Much of the motivation for this has been gained from conversations [here.](https://galactictalk.org/d/984-creating-transactions-for-a-simple-binary-distribution-model)

## Setup:
People involved:
```
A -- user
B -- Doppler
C -- App Owner
D -- Provider
E -- Contributor
```

User's current sequence number: ```X```

## Transactions:

TRANSACTION A (Sequence X+1)
```
Operation 1: Pay person B
Operation 2: Pay person C
Operation 3: Pay person D
Operation 4: Pay person E
Signature Person A
```

TRANSACTION B (Sequence X+1)
```
Operation 1: Pay person B
Operation 2: Pay person C
Operation 3: Pay person D
Signature Person A
```

## Post Prediction
After the service is complete:
```
IF SUCCESS: B broadcasts TRANSACTION A
ELSE: B broadcasts TRANSACTION B
```

## Code Structure:
```
Setup: setup.js
Transaction A: transactionA.js
Transaction B: transactionB.js
Post Prediction: postprediction.js
Helper: helper.js
-- getBalance
-- sendLumens()
```

## How to Run
```
git clone https://github.com/DopplerFoundation/crypto-research.git
cd stellar
npm install
npm test
```

## Conclusion
This is a very reasonable setup. Based on testing, the following observations were made:
```
1. Only one transaction can be broadcast
2. If user tries to double spend, preconstructed transaction becomes void
3. Can batch all the transactions and only pay one fee of 0.00001/op
4. Testnet handled 200 tx/ledger or rougly 40-50 tx/s (with very minimal infastructure)
5. Very easy to create own token
```

#### Money Considerations:
```
Fee/tx = 0.00004 * $0.45 = $0.00018
So:
  1000   tx fee's = $0.18
  100000 tx fee's = $18
```
