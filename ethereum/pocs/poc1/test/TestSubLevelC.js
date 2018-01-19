const SubLevelC = artifacts.require("SubLevelC");

contract('SubLevelC -- JS tests', function(accounts) {
  let subLevelC
  const address1 = "0x627306090abab3a6e1400e9345bc60c78a8bef50";
  const address2 = "0xf17f52151ebef6c7334fad080c5704d77216b712";
  const address3 = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe2";

  beforeEach('setup contract for each test', async function () {
      subLevelC = await SubLevelC.new([address1, address2])
  })

  it('has initial payout addresses', async function () {
    assert.deepEqual(await subLevelC.returnPayoutAddresses.call(),[address1, address2])
  })

  it('has an owner', async function () {
    assert.equal(await subLevelC.owner.call(), accounts[0])
  })

  it('adds payout address', async function () {
    await subLevelC.addPayoutAddress(address3)
    assert.deepEqual(await subLevelC.returnPayoutAddresses.call(), [address1, address2, address3])
  })

  it('deletes payout address', async function () {
    await subLevelC.removePayoutAddress(address2)
    assert.deepEqual(await subLevelC.returnPayoutAddresses.call(),[address1])
  })

  it('receives payment', async function () {
    subLevelC.contract._eth.sendTransaction({from:accounts[1], to:subLevelC.address, value: 100})
    assert.equal(subLevelC.contract._eth.getBalance(subLevelC.address).c[0], 100)
  })

  it('distributes payment', async function () {
    subLevelC.contract._eth.sendTransaction({from:accounts[1], to:subLevelC.address, value: 100})

    const origBalanceAddress1 = subLevelC.contract._eth.getBalance(address1).c[0];
    const origBalanceAddress2 = subLevelC.contract._eth.getBalance(address2).c[0];

    assert.equal(subLevelC.contract._eth.getBalance(subLevelC.address).c[0], 100)

    await subLevelC.distribute()
    assert.equal(subLevelC.contract._eth.getBalance(address1).c[0], 50 + origBalanceAddress1)
    assert.equal(subLevelC.contract._eth.getBalance(address2).c[0], 50 + origBalanceAddress2)
    assert.equal(subLevelC.contract._eth.getBalance(subLevelC.address).c[0], 0)
  })

});
