const chai = require('chai');
const src = require('../src/index');

const asset = chai.assert;


describe('Doppler + Stellar', async () => {
  it('all accounts should have at least 10 xlm', async () => {
    const originalBalanceA = await src.helper.getBalance(src.setup.a.publicKey);
    const originalBalanceB = await src.helper.getBalance(src.setup.b.publicKey);
    const originalBalanceC = await src.helper.getBalance(src.setup.c.publicKey);
    const originalBalanceD = await src.helper.getBalance(src.setup.d.publicKey);
    const originalBalanceE = await src.helper.getBalance(src.setup.e.publicKey);

    asset.isAbove( originalBalanceA, 10);
    asset.isAbove( originalBalanceB, 10);
    asset.isAbove( originalBalanceC, 10);
    asset.isAbove( originalBalanceD, 10);
    asset.isAbove( originalBalanceE, 10);
  });

  it('Doppler should not be able to broadcast both transaction', async () => {
    const txA = await src.transactionA.construct(src.setup);
    const txB = await src.transactionB.construct(src.setup);

    const txAResp = await src.postprediction.prediction({ txA, txB, predictionResult: true });
    const txBResp = await src.postprediction.prediction({ txA, txB, predictionResult: false });

    asset.equal( txAResp, true);
    asset.equal( txBResp, false);
  });

  it('should void if user sends tx before prediction finished', async () => {
    const txA = await src.transactionA.construct(src.setup);
    const txB = await src.transactionB.construct(src.setup);

    const tx0Resp = await src.helper.sendLumens(src.setup.a.secretKey, src.setup.b.publicKey);
    const txAResp = await src.postprediction.prediction({ txA, txB, predictionResult: true });
    const txBResp = await src.postprediction.prediction({ txA, txB, predictionResult: false });

    asset.equal( tx0Resp, true);
    asset.equal( txAResp, false);
    asset.equal( txBResp, false);
  });

  it('should distribute correctly on prediction success', async () => {
    const originalBalanceB = await src.helper.getBalance(src.setup.b.publicKey);
    const originalBalanceC = await src.helper.getBalance(src.setup.c.publicKey);
    const originalBalanceD = await src.helper.getBalance(src.setup.d.publicKey);
    const originalBalanceE = await src.helper.getBalance(src.setup.e.publicKey);

    const txA = await src.transactionA.construct(src.setup);
    const txB = await src.transactionB.construct(src.setup);

    const txAResp = await src.postprediction.prediction({ txA, txB, predictionResult: true });

    asset.equal( txAResp, true);

    const postTxABalanceB = await src.helper.getBalance(src.setup.b.publicKey);
    const postTxABalanceC = await src.helper.getBalance(src.setup.c.publicKey);
    const postTxABalanceD = await src.helper.getBalance(src.setup.d.publicKey);
    const postTxABalanceE = await src.helper.getBalance(src.setup.e.publicKey);

    asset.equal( postTxABalanceB, originalBalanceB + 1);
    asset.equal( postTxABalanceC, originalBalanceC + 1);
    asset.equal( postTxABalanceD, originalBalanceD + 1);
    asset.equal( postTxABalanceE, originalBalanceE + 1);
  });

  it('should distribute correctly on prediction failure', async () => {
    const originalBalanceB = await src.helper.getBalance(src.setup.b.publicKey);
    const originalBalanceC = await src.helper.getBalance(src.setup.c.publicKey);
    const originalBalanceD = await src.helper.getBalance(src.setup.d.publicKey);

    const txA = await src.transactionA.construct(src.setup);
    const txB = await src.transactionB.construct(src.setup);

    const txAResp = await src.postprediction.prediction({ txA, txB, predictionResult: false });

    asset.equal( txAResp, true);

    const postTxBBalanceB = await src.helper.getBalance(src.setup.b.publicKey);
    const postTxBBalanceC = await src.helper.getBalance(src.setup.c.publicKey);
    const postTxBBalanceD = await src.helper.getBalance(src.setup.d.publicKey);

    asset.equal( postTxBBalanceB, originalBalanceB + 1);
    asset.equal( postTxBBalanceC, originalBalanceC + 1);
    asset.equal( postTxBBalanceD, originalBalanceD + 1);
  });
});
