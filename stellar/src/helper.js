const StellarSdk = require('stellar-sdk');

const server = new StellarSdk.Server('https://horizon-testnet.stellar.org');

StellarSdk.Network.useTestNetwork();

/**
 * Get the balance of an account.
 * @param { PublicKey } pubKey
 * @returns { Promise } --> { Balance }
 */

async function getBalance(publickKey) {
  const resp = server.accounts()
    .accountId(publickKey)
    .call()

  const { balances } = await resp;
  // console.log(r);
  return Number(balances.filter( b => b.asset_type === 'native')[0].balance);
}

/**
 * Send lumens from A --> B.
 * @param { SecretKeyB, PublicKeyB } senderSK, receiverPK
 * @returns { Bool }
 */

async function sendLumens(senderSK, receiverPK) {
  // Get the user's account
  const sourceKeypair = StellarSdk.Keypair.fromSecret(senderSK);
  const account = await server.loadAccount(sourceKeypair.publicKey());

  // Build transaction
  const transaction = new StellarSdk.TransactionBuilder(account)
  .addOperation(StellarSdk.Operation.payment({
        destination: receiverPK,
        asset: StellarSdk.Asset.native(),
        amount: "1",
      }))
  .build();

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
  getBalance,
  sendLumens,
}
