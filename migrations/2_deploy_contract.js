var Store = artifacts.require("./../contracts/Store.sol");
var Marketplace = artifacts.require("./../contracts/Marketplace.sol");

module.exports = function(deployer) {
  deployer.deploy(Store);
  deployer.deploy(Marketplace);
};
