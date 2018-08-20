

var StoreCrud = artifacts.require("./../contracts/StoreCrud.sol");
var ItemCrud = artifacts.require("./../contracts/ItemCrud.sol");
var Marketplace = artifacts.require("./../contracts/Marketplace.sol");

  module.exports = function(deployer, network) {
    if (network == "development") {
      //deployer.deploy(StoreLogic, 0x00, "cars");
    //  deployer.deploy(ItemCrud);
      deployer.deploy(StoreCrud);
      deployer.deploy(ItemCrud);
      deployer.deploy(Marketplace);

      //deployer.deploy(MarketplaceLogic);
      //deployer.deploy(Marketplace);
    } else {
      //deployer.deploy(StoreLogic, 0x00, "cars");
      deployer.deploy(StoreCrud);
      deployer.deploy(ItemCrud);
      deployer.deploy(Marketplace);

      //deployer.deploy(MarketplaceLogic);
      //deployer.deploy(Marketplace);
      // Perform a different step otherwise.
    }
  };
