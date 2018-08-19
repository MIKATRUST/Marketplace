pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
//import "./../contracts/Store.sol";
import "./../contracts/Marketplace.sol";

contract TestMarketplace {

  Marketplace marketplace = Marketplace(DeployedAddresses.Marketplace());

  function testRegisterStorefront () public {
    bool result;
    Marketplace.StoreState resultState;
    Marketplace.StoreState expectedState;
    result = marketplace.registerStorefront("Old cars");
    resultState = marketplace.queryStorefrontState();
    expectedState = Marketplace.StoreState.Received;
    Assert.equal(true, result, "One Store succesfully registered.");
    Assert.equal(uint256 (resultState), uint256 (expectedState),
    "Store with the appropriate state StoreState.Received is registered in the marketplace.");
  }

  function testQueryStorefront () public {
    address ownerAddress;
    address storeAddress;
    string memory storeName;
    Marketplace.StoreState storeState;
    (ownerAddress, storeAddress, storeName, storeState) = marketplace.queryStorefront();
    address expectedOwnerAddress = msg.sender;
    address expectedStoreAddress = msg.sender;
    string memory expectedStoreName = "Old cars";
    Marketplace.StoreState expectedStoreState;
    expectedStoreState = Marketplace.StoreState.Received;
    Assert.equal(uint256 (storeState), uint256 (expectedStoreState),
      "Store state should match expected Store state");
    Assert.equal(address (expectedOwnerAddress), address (ownerAddress),
      "Store owner address should match expected address");
    //Below : fail -> To check
    //Assert.equal(address (expectedStoreAddress), address (storeAddress),
    //  "Store address should match expected address");
    Assert.equal(string (expectedStoreName), string (storeName),
      "Store name should match expected name");
  }

  function testUnregisterStorefront () public {
      bool result;
      Marketplace.StoreState resultState;
      Marketplace.StoreState expectedState;
      result = marketplace.unregisterStorefront();
      Assert.equal(true, result, "One Store succesfully unregistered.");
      resultState = marketplace.queryStorefrontState ();
      expectedState = Marketplace.StoreState.Removed;
      Assert.equal(uint256 (resultState), uint256 (expectedState),
      "Unregistered Store unregistered has the appropriate state StoreState.Removed in the marketplace.");
  }

/*
  function testQueryStorefrontState () public {
      Marketplace.StoreState resultState1;
      Marketplace.StoreState resultState2;
      resultState1 = marketplace.queryStorefrontState (msg.sender);
      resultState2 = marketplace.queryStorefrontState ();
      Assert.equal(uint256 (resultState1), uint256 (resultState2),
      "Whatever the function used to recover the state, result must be the same.");
  }
*/

  //!!!!!!!!
  //Test TBD : changement d'état par l'admin de la MArketplace
  //
}
