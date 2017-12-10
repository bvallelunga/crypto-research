var HelloWorld = artifacts.require("HelloWorld");
var StructManipulation = artifacts.require("StructManipulation");

module.exports = function(deployer) {
  deployer.deploy(HelloWorld);
  deployer.deploy(StructManipulation);
};
