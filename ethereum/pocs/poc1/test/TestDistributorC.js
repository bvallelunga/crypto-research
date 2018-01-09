const DistributorC = artifacts.require("DistributorC");

const address1 = "0x627306090abab3a6e1400e9345bc60c78a8bef50";
const address2 = "0xf17f52151ebef6c7334fad080c5704d77216b712";
const address3 = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe2";

contract('DistributorC', function(accounts) {
  let distributorC

  it('has an owner', async function () {
    distributorC = await DistributorC.new()
    assert.equal(await distributorC.dopplerFoundation.call(), accounts[0])
  })

  it('adds task', async function(){
    await distributorC.addTask(1, address1, address2, address3, 30, 30, 30)
    const resp = await distributorC.getTask.call(1)
    assert.deepEqual([resp[0], resp[1], resp[2], resp[3].c[0], resp[4].c[0], resp[5].c[0], resp[6]], [address1, address2, address3, 30, 30, 30, true])
  })

  it('adds payment', async function () {
    await distributorC.addPayment(1,1, { from: accounts[0], value: 100, gas: 100000 })
    const resp = await distributorC.getUserPayment.call(1)
    assert.deepEqual([resp[0].c[0], resp[1].c[0], resp[2], resp[3]], [100, 1, accounts[0], true])
  })

  it('distribute -- outcome 1', async function() {
    await distributorC.addTask(1, address1, address2, address3, 30, 30, 30)
    await distributorC.addPayment(1,1, { from: accounts[0], value: 100, gas: 100000 })

    const origBalanceAddress1 = distributorC.contract._eth.getBalance(address1).c[0];
    const origBalanceAddress2 = distributorC.contract._eth.getBalance(address2).c[0];
    const origBalanceAddress3 = distributorC.contract._eth.getBalance(address3).c[0];

    await distributorC.distributePayment(1,1)

    assert.equal(distributorC.contract._eth.getBalance(address1).c[0], 30 + origBalanceAddress1)
    assert.equal(distributorC.contract._eth.getBalance(address2).c[0], 30 + origBalanceAddress2)
    assert.equal(distributorC.contract._eth.getBalance(address3).c[0], 30 + origBalanceAddress3)
  })

  it('distribute -- outcome 2', async function() {
    await distributorC.addPayment(1,2, { from: accounts[0], value: 100, gas: 100000 })

    const origBalanceAddress1 = distributorC.contract._eth.getBalance(address1).c[0];
    const origBalanceAddress2 = distributorC.contract._eth.getBalance(address2).c[0];
    const origBalanceAddress3 = distributorC.contract._eth.getBalance(address3).c[0];

    await distributorC.distributePayment(2,2)

    assert.equal(distributorC.contract._eth.getBalance(address1).c[0], 30 + origBalanceAddress1)
    assert.equal(distributorC.contract._eth.getBalance(address2).c[0], 30 + origBalanceAddress2)
    assert.equal(distributorC.contract._eth.getBalance(address3).c[0], 30 + origBalanceAddress3)
  })

  it('distribute -- outcome 3', async function() {
    await distributorC.addPayment(1,3, { from: accounts[0], value: 100, gas: 100000 })

    const origBalanceAddress1 = distributorC.contract._eth.getBalance(address1).c[0];
    const origBalanceAddress2 = distributorC.contract._eth.getBalance(address2).c[0];
    const origBalanceAddress3 = distributorC.contract._eth.getBalance(address3).c[0];

    await distributorC.distributePayment(3,3)

    assert.equal(distributorC.contract._eth.getBalance(address1).c[0], 30 + origBalanceAddress1)
    assert.equal(distributorC.contract._eth.getBalance(address2).c[0], 0 + origBalanceAddress2)
    assert.equal(distributorC.contract._eth.getBalance(address3).c[0], 0 + origBalanceAddress3)
  })

  it('distribute -- outcome 4', async function() {
    await distributorC.addPayment(1,4, { from: accounts[0], value: 100, gas: 100000 })

    const origBalanceAddress1 = distributorC.contract._eth.getBalance(address1).c[0];
    const origBalanceAddress2 = distributorC.contract._eth.getBalance(address2).c[0];
    const origBalanceAddress3 = distributorC.contract._eth.getBalance(address3).c[0];

    await distributorC.distributePayment(4,4)

    assert.equal(distributorC.contract._eth.getBalance(address1).c[0], 0 + origBalanceAddress1)
    assert.equal(distributorC.contract._eth.getBalance(address2).c[0], 0 + origBalanceAddress2)
    assert.equal(distributorC.contract._eth.getBalance(address3).c[0], 0 + origBalanceAddress3)
  })

});
