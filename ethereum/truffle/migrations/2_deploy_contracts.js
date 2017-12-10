var HelloWorld = artifacts.require("HelloWorld");
var StructManipulation = artifacts.require("StructManipulation");
var ContractToContract1 = artifacts.require("ContractToContract1");
var ContractToContract2 = artifacts.require("ContractToContract2");

module.exports = function(deployer) {
  deployer.deploy(HelloWorld);
  deployer.deploy(StructManipulation);
  deployer.deploy(ContractToContract1);
  deployer.deploy(ContractToContract2);
};
