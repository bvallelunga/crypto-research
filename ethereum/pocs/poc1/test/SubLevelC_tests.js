const SubLevelC = artifacts.require("SubLevelC");

contract('SubLevelC', function(accounts) {
  let subLevelC
  beforeEach('setup contract for each test', async function () {
      subLevelC = await SubLevelC.new(accounts.slice(0,2))
  })

  it('has initial payout addresses', async function () {
    assert.deepEqual(await subLevelC.returnPayoutAddresses.call(), accounts.slice(0,2))
  })

  it('has an owner', async function () {
    assert.equal(await subLevelC.owner.call(), accounts[0])
  })

  it('adds payout address', async function () {
    await subLevelC.addOwner(accounts[2])
    assert.deepEqual(await subLevelC.returnPayoutAddresses.call(), accounts.slice(0,3))
  })

  it('deletes payout address', async function () {
    await subLevelC.removePayoutAddress(accounts[1])
    assert.deepEqual(await subLevelC.returnPayoutAddresses.call(), accounts.slice(0,1))
  })

  it('receives payment', async function () {
    subLevelC.contract._eth.sendTransaction({from:accounts[1], to:subLevelC.address, value: 100})
    assert.equal(subLevelC.contract._eth.getBalance(subLevelC.address).c[0], 100)
  })

  it('distributes payment', async function () {
    subLevelC.contract._eth.sendTransaction({from:accounts[1], to:subLevelC.address, value: 10000})

    const initAccount0Balance = subLevelC.contract._eth.getBalance(accounts[0]).c[0]
    const initAccount1Balance = subLevelC.contract._eth.getBalance(accounts[1]).c[0]

    await subLevelC.distribute.call()

    assert.equal(subLevelC.contract._eth.getBalance(accounts[0]).c[0], initAccount0Balance + 50)
    assert.equal(subLevelC.contract._eth.getBalance(accounts[1]).c[0], initAccount1Balance + 50)
  })

});
