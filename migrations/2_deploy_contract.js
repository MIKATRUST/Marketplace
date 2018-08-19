
var StoreLogic = artifacts.require("./../contracts/StoreLogic.sol");
var Store = artifacts.require("./../contracts/Store.sol");
var MarketplaceLogic = artifacts.require("./../contracts/MarketplaceLogic.sol");

/*
module.exports = function(deployer) {
  deployer.deploy(Store, "Cars");
  deployer.deploy(Marketplace);
};

*/

  module.exports = function(deployer, network) {
    if (network == "development") {
      deployer.deploy(StoreLogic, 0x00, "cars");
      deployer.deploy(Store, 0x00, "cars");
      deployer.deploy(MarketplaceLogic);
    } else {
      deployer.deploy(StoreLogic, 0x00, "cars");
      deployer.deploy(Store, 0x00, "cars");
      deployer.deploy(MarketplaceLogic);
      // Perform a different step otherwise.
    }
  };
