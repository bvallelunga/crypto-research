const simHelper = require('./helper');
const genHelper = require('../src/helper');
const setup = require('../src/setup');

// In USD
const CUR_PRICE_XLM = 0.42

let costTotal = 0;
let feeTotal = 0;
let predictionsTotal = 0;

async function testPayment(numTimes) {
  const originalBalanceA = await genHelper.getBalance(setup.a.publicKey);

  const wasSuccessful = await simHelper.sendLumensNTimes(setup.a.secretKey, setup.b.publicKey, numTimes);

  console.log("");
  console.log("Status of tx:", wasSuccessful);

  const postTransactionBalanceA = await genHelper.getBalance(setup.a.publicKey);

  const differance = originalBalanceA - postTransactionBalanceA;
  const fee = (numTimes * 0.00001)
  const paymentPerUser = (differance - fee)/ numTimes

  costTotal += differance;
  feeTotal += fee;
  predictionsTotal ++;

  console.log("A paid", numTimes, "people.");
  console.log("A paid total in USD:", (differance.toFixed(5) * CUR_PRICE_XLM));
  console.log("A paid fee in USD:", (fee.toFixed(5) * CUR_PRICE_XLM));
  console.log("A paid per person in USD:", (paymentPerUser.toFixed(5) * CUR_PRICE_XLM));
}

async function costTest(numTimes, numPeople) {
  for (let i = 0; i < numTimes; i ++) {
    await testPayment(numPeople);
  }

  console.log("");
  console.log("A made", predictionsTotal, "predictions.");
  console.log("A paid total in USD:", (costTotal.toFixed(5) * CUR_PRICE_XLM));
  console.log("A paid fee in USD:", (feeTotal.toFixed(5) * CUR_PRICE_XLM));
}

costTest(10, 10);
