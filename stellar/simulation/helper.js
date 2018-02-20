const StellarSdk = require('stellar-sdk');

const server = new StellarSdk.Server('https://horizon-testnet.stellar.org');

StellarSdk.Network.useTestNetwork();


/**
 * Send lumens n times from A --> B.
 * @param { SecretKeyA, PublicKeyB, NumberOfPayments } senderSK, receiverPK, numPayments
 * @returns { Bool }
 */

async function sendLumensNTimes(senderSK, receiverPK, numPayments) {
  // Get the user's account
  const sourceKeypair = StellarSdk.Keypair.fromSecret(senderSK);
  const account = await server.loadAccount(sourceKeypair.publicKey());

  // Build transaction
  let transaction = new StellarSdk.TransactionBuilder(account)

  // Figure out how much everyone gets
  const perPersonPaymentAmount = 0.0024/numPayments

  for (let i = 0; i < numPayments; i ++) {
    transaction = transaction.addOperation(StellarSdk.Operation.payment({
          destination: receiverPK,
          asset: StellarSdk.Asset.native(),
          amount: perPersonPaymentAmount.toFixed(7).toString(),
        }))
  }

  transaction = transaction.build();

  // Sign transaction
  transaction.sign(sourceKeypair);
  try {
    await server.submitTransaction(transaction);
    return true;
  } catch (err) {
    return false;
  }
}

module.exports = {
  sendLumensNTimes,
}
