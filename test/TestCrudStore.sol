pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "./../contracts/CrudStore.sol";

contract TestCrudStore is CrudStore {

  CrudStore crudstore = CrudStore(DeployedAddresses.CrudStore());
  uint index;

  /*
  struct StoreStruct {
    bytes32 storeName;
    address storeAddress;
    uint index;
  }
  */

  function testInsertCrudStore() public {
    insertCrudStore(0x01,"store 1");
    insertCrudStore(0x02,"store 2");
    insertCrudStore(0x03,"store 3");
    insertCrudStore(0x04,"store 4");
    insertCrudStore(0x05,"store 5");
    //try insert already existing store, tbd with js
    Assert.equal(uint256(5), getCrudStoreCount(), "5 stores inserted correctly.");
  }

  function testGetCrudStore() public {
    bytes32 recStoreName;
    bytes32 expectedStoreName = "store 2";
    //try request not a store, tbd with js
    (recStoreName, index) = getCrudStore(0x02);
    Assert.equal(bytes32(recStoreName), bytes32(expectedStoreName), "recovered and expected storeName should match");
  }

  function testGetCrudStoreAtIndex() public {
    address expectedStoreAddress = 0x02;
    address recStoreAddress = getCrudStoreAtIndex(index);
    Assert.equal(recStoreAddress, expectedStoreAddress, "recovered and expected storeName should match");
  }

  function testDeleteCrudStore() public {
    deleteCrudStore(0x01);
    deleteCrudStore(0x05);
    // try delete not a store, tbd with js
    Assert.equal(uint256(3), getCrudStoreCount(), "3 stores remaining.");

  }

  function testCrudStoreCount() public {
    deleteCrudStore(0x02);
    deleteCrudStore(0x03);
    deleteCrudStore(0x04);
    Assert.equal(uint256(0), getCrudStoreCount(), "0 store remaining.");
  }

}
