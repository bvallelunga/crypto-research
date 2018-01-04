const DistributorC = artifacts.require("DistributorC");

contract('DistributorC', function(accounts) {
  let distributorC
  beforeEach('setup contract for each test', async function () {
      distributorC = await DistributorC.new()
  })

  it('has an owner', async function () {
    assert.equal(await distributorC.owner.call(), accounts[0])
  })

});
