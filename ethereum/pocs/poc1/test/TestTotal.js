const DistributorC = artifacts.require("DistributorC");
const SubLevelC = artifacts.require("SubLevelC");

contract('DistributorC', async function(accounts) {

  // Define a bunch of addresses for testing
  const dopplerFoundation = accounts[0]; // The Doppler Foundation
  const user = accounts[1]; // User
  const address0 = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098f10"; // Contributor
  const address1 = "0x627306090abab3a6e1400e9345bc60c78a8bef51"; // Contributor
  const address2 = "0xf17f52151ebef6c7334fad080c5704d77216b712"; // Provider
  const address3 = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe3"; // Provider
  const address4 = "0x627306090abab3a6e1400e9345bc60c78a8bef54"; // Provider
  const address5 = "0xf17f52151ebef6c7334fad080c5704d77216b715"; // Provider
  const address6 = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe6"; // Provider
  const address7 = "0x627306090abab3a6e14e0e9345bc60c78a8bef57"; // App Owner
  const address8 = "0xf17f52151ebef6c7334fad080c5704d77216b7ee"; // Extra
  const address9 = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fe9"; // Extra


   it("should work :)", async function() {
     // Instantiate a distributor contract
     const distributorC = await DistributorC.new();
     console.log("Distributor contract created.");

     // Instantiate a contributor contract
     const contributorC = await SubLevelC.new([address0, address1])
     console.log("Contributor contract created.");

     // Instantiate a provider contract
     const providerC = await SubLevelC.new([address2, address3, address4, address5, address6])
     console.log("Provider contract created.");

     // Instantiate an app owner contract
     const appownerC = await SubLevelC.new([address7])
     console.log("App Owner contract created.");

     // Capture all starting balances
     dopplerFoundationStartBalance = distributorC.contract._eth.getBalance(dopplerFoundation).c[0];
     userStartBalance = distributorC.contract._eth.getBalance(user).c[0];
     address0StartBalance = distributorC.contract._eth.getBalance(address0).c[0];
     address1StartBalance = distributorC.contract._eth.getBalance(address1).c[0];
     address2StartBalance = distributorC.contract._eth.getBalance(address2).c[0];
     address3StartBalance = distributorC.contract._eth.getBalance(address3).c[0];
     address4StartBalance = distributorC.contract._eth.getBalance(address4).c[0];
     address5StartBalance = distributorC.contract._eth.getBalance(address5).c[0];
     address6StartBalance = distributorC.contract._eth.getBalance(address6).c[0];
     address7StartBalance = distributorC.contract._eth.getBalance(address7).c[0];
     address8StartBalance = distributorC.contract._eth.getBalance(address8).c[0];
     address9StartBalance = distributorC.contract._eth.getBalance(address9).c[0];
     distributorCStartBalance = distributorC.contract._eth.getBalance(distributorC.address).c[0];
     contributorCStartBalance = distributorC.contract._eth.getBalance(contributorC.address).c[0];
     providerCStartBalance = distributorC.contract._eth.getBalance(providerC.address).c[0];
     appownerCStartBalance = distributorC.contract._eth.getBalance(appownerC.address).c[0];

     // Define a task
     const task = {
       id: 1293829,
       addrContributorC: contributorC.address,
       addrProviderC: providerC.address,
       addrAppownerC: appownerC.address,
     }

     // Create the task
     await distributorC.addTask(task.id, task.addrProviderC, task.addrContributorC, task.addrAppownerC, 50, 20, 10);
     console.log("Task created");

     // Define a payment
     const payment = {
       id: 1392,
       taskId: task.id,
       amount: 100,
     }

    // Create a payment
    await distributorC.addPayment(payment.taskId, payment.id, { from: user, value: payment.amount, gas: 100000 });
    console.log("Payment created");

    // Define an outcome
    const outcome = {
      result: 1,
      paymentId: payment.id,
    }

    // Distribute based on a successful prediction (Outcome 1)
    await distributorC.distributePayment(outcome.result, outcome.paymentId);
    console.log("Prediction completed with outcome 1, success, payment distributed to sublevel contracts.");

    // Distribute the payments in the SubLevelC contracts
    await contributorC.distribute()
    await providerC.distribute()
    await appownerC.distribute()
    console.log("All contracts distributed funds to addresses/wallets.");

    // Capture all ending balances
    dopplerFoundationEndBalance = distributorC.contract._eth.getBalance(dopplerFoundation).c[0];
    userEndBalance = distributorC.contract._eth.getBalance(user).c[0];
    address0EndBalance = distributorC.contract._eth.getBalance(address0).c[0];
    address1EndBalance = distributorC.contract._eth.getBalance(address1).c[0];
    address2EndBalance = distributorC.contract._eth.getBalance(address2).c[0];
    address3EndBalance = distributorC.contract._eth.getBalance(address3).c[0];
    address4EndBalance = distributorC.contract._eth.getBalance(address4).c[0];
    address5EndBalance = distributorC.contract._eth.getBalance(address5).c[0];
    address6EndBalance = distributorC.contract._eth.getBalance(address6).c[0];
    address7EndBalance = distributorC.contract._eth.getBalance(address7).c[0];
    address8EndBalance = distributorC.contract._eth.getBalance(address8).c[0];
    address9EndBalance = distributorC.contract._eth.getBalance(address9).c[0];
    distributorCEndBalance = distributorC.contract._eth.getBalance(distributorC.address).c[0];
    contributorCEndBalance = distributorC.contract._eth.getBalance(contributorC.address).c[0];
    providerCEndBalance = distributorC.contract._eth.getBalance(providerC.address).c[0];
    appownerCEndBalance = distributorC.contract._eth.getBalance(appownerC.address).c[0];

    // Test to make sure all the balances paid out as expected
    // TODO: FIX THIS --> The gas is unpredictable so can't determine user or Doppler Foundation balances
    // assert.equal(dopplerFoundationEndBalance, dopplerFoundationStartBalance + 10)
    // assert.equal(userEndBalance, 0)
    assert.equal(address0EndBalance, address0StartBalance + 10, "Contributor 1")
    assert.equal(address1EndBalance, address1StartBalance + 10, "Contributor 2")
    assert.equal(address2EndBalance, address2StartBalance + 10, "Provider 5")
    assert.equal(address3EndBalance, address3StartBalance + 10, "Provider 5")
    assert.equal(address4EndBalance, address4StartBalance + 10, "Provider 5")
    assert.equal(address5EndBalance, address5StartBalance + 10, "Provider 5")
    assert.equal(address6EndBalance, address6StartBalance + 10, "Provider 5")
    assert.equal(address7EndBalance, address7StartBalance + 10, "App Owner 1")
    assert.equal(address8EndBalance, 0, "Extra 1")
    assert.equal(address9EndBalance, 0, "Extra 2")
    assert.equal(distributorCEndBalance, distributorCStartBalance + 20, "Distributor contrack")
    assert.equal(contributorCEndBalance, 0, "Contributor contrack")
    assert.equal(providerCEndBalance, 0, "Provider contrack")
    assert.equal(appownerCEndBalance, 0, "App Owner contrack")
   })

})
