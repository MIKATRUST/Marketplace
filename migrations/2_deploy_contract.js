

var CrudStore = artifacts.require("./../contracts/CrudStore.sol");
var CrudItem = artifacts.require("./../contracts/CrudItem.sol");
var Marketplace = artifacts.require("./../contracts/Marketplace.sol");

  module.exports = function(deployer, network) {
    if (network == "development") {
      //deployer.deploy(StoreLogic, 0x00, "cars");
    //  deployer.deploy(ItemCrud);
      deployer.deploy(CrudStore);
      deployer.deploy(CrudItem);
      deployer.deploy(Marketplace);

      //deployer.deploy(MarketplaceLogic);
      //deployer.deploy(Marketplace);
    } else {
      //deployer.deploy(StoreLogic, 0x00, "cars");
      deployer.deploy(CrudStore);
      deployer.deploy(CrudItem);
      deployer.deploy(Marketplace);

      //deployer.deploy(MarketplaceLogic);
      //deployer.deploy(Marketplace);
      // Perform a different step otherwise.
    }
  };
