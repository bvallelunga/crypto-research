// const DistributorC = artifacts.require("DistributorC");
//
// contract('DistributorC', function(accounts) {
//   let distributorC
//
//   it('has an owner', async function () {
//     distributorC = await DistributorC.new()
//     assert.equal(await distributorC.dopplerFoundation.call(), accounts[0])
//   })
//
//   it('adds payment', async function () {
//     await distributorC.addPayment.call(1,1)
//     const resp = await distributorC.getUserPayment.call(1)
//     console.log(resp);
//     // assert.deepEqual(await distributorC.getUserPayment.call(1), [0, 1, accounts[0]])
//   })
//
// });
