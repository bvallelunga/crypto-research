// Specifically request an abstraction for MetaCoin
const SubLevelC = artifacts.require("SubLevelC");

contract('SubLevelC', function(accounts) {
  let subLevelC
  beforeEach('setup contract for each test', async function () {
      subLevelC = await SubLevelC.new(accounts)
  })

  it('has an owner', async function () {
    // console.log(subLevelC.returnOwners.call());
    // subLevelC.returnOwners.call().then(d => console.log(d)).catch(err => console.log(err))
    // assert.equal(owners, accounts)
  })

});
