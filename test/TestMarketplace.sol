pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
//import "./../contracts/Store.sol";
import "./../contracts/Marketplace.sol";

contract TestMarketplace {

  Marketplace marketplace = Marketplace(DeployedAddresses.Marketplace());

//  function testRegisterMktStore () public {
    //bool ret = marketplace.registerStorefront("Old cars");

    //bool ret = marketplace.registerStorefront("James Bond cars");
    //Assert.equal(uint256(1), uint256(1), "Store should have 2 product");
  //}

  function testRegisterStorefront () public {
    bool result;
    result = marketplace.registerStorefront("Old cars");
    Assert.equal(true, result, "One Store registered");

    Marketplace.StoreState tmpState;
    Marketplace.StoreState expectedState;

    tmpState = marketplace.queryStorefrontState ();

    expectedState = Marketplace.StoreState.Received;

    Assert.equal(uint256 (tmpState), uint256 (expectedState),
    "Store exists in the marketplace and has the appropriate state.");
  }

  function testNumberOfStoreOpen () public {
      uint256 numberOfStoreOpen;
      numberOfStoreOpen = marketplace.queryNumberOfStoreWithState (Marketplace.StoreState.Received);
      //Assert.equal(numberOfStoreOpen, uint256(1), "1 Store exists in the markeplace");
      Assert.equal(uint(1), uint(2), "blabla");
  }

}
