var SubLevelC = artifacts.require("SubLevelC");
var DistributorC = artifacts.require("DistributorC");

module.exports = function(deployer) {
 deployer.deploy(SubLevelC);
 deployer.deploy(DistributorC);
};
