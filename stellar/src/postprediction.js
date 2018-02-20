const StellarSdk = require('stellar-sdk');

const server = new StellarSdk.Server('https://horizon-testnet.stellar.org');

StellarSdk.Network.useTestNetwork();

/**
 * Make a predication and broadcast transaction based on outcome.
 * @param {TransactionA, TransactionB, PredictionResult } txA, txB, predictionResult
 * @returns { Bool }
 */

async function prediction({ txA, txB, predictionResult }) {
  let transaction;
  if (predictionResult) {
    transaction = txA
  } else {
    transaction = txB;
  }

  try {
    await server.submitTransaction(transaction);
    return true;
  } catch (err) {
    return false;
  }
}

module.exports = {
  prediction,
}
