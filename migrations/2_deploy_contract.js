var CrudStore = artifacts.require("./../contracts/CrudStore.sol");
var CrudItem = artifacts.require("./../contracts/CrudItem.sol");
var Marketplace = artifacts.require("./../contracts/Marketplace.sol");

module.exports = function(deployer, network) {
  if (network == "development") {
    deployer.deploy(CrudStore);
    deployer.deploy(CrudItem);
    deployer.deploy(Marketplace);
  } else {
    deployer.deploy(CrudStore);
    deployer.deploy(CrudItem);
    deployer.deploy(Marketplace);
  }
};