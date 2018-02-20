const StellarSdk = require('stellar-sdk');

const KeyPair = StellarSdk.KeyPair
const server = new StellarSdk.Server('https://horizon-testnet.stellar.org');

StellarSdk.Network.useTestNetwork();

/**
 * Build and sign a transaction.
 * @param { User, Doppler, AppOwner, Provider, Contributor } a,b,c,d,e
 * @returns { SignedTransaction }
 */

async function construct({ a, b, c, d, e }) {

  // Get the user's account
  const sourceKeypair = StellarSdk.Keypair.fromSecret(a.secretKey);
  const account = await server.loadAccount(sourceKeypair.publicKey());

  // Build transaction
  const transaction = new StellarSdk.TransactionBuilder(account)
  .addOperation(StellarSdk.Operation.payment({
        destination: b.publicKey,
        asset: StellarSdk.Asset.native(),
        amount: "1",
      }))
  .addOperation(StellarSdk.Operation.payment({
        destination: c.publicKey,
        asset: StellarSdk.Asset.native(),
        amount: "1",
      }))
  .addOperation(StellarSdk.Operation.payment({
        destination: d.publicKey,
        asset: StellarSdk.Asset.native(),
        amount: "1",
      }))
  .addOperation(StellarSdk.Operation.payment({
        destination: e.publicKey,
        asset: StellarSdk.Asset.native(),
        amount: "1",
      }))
  .build();

  // Sign transaction
  transaction.sign(sourceKeypair);

  return transaction
}

module.exports = {
  construct,
}
