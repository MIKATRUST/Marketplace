pragma solidity ^0.4.24;

// Strategy for using event injavascript
//https://ethereum.stackexchange.com/questions/39171/how-to-check-events-in-truffle-tests

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "./../contracts/CrudStore.sol";

contract TestCrudStore is CrudStore {

  CrudStore crudstore = CrudStore(DeployedAddresses.CrudStore());
  uint index;

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

/*
  function testHeartBeat() public {
    uint n = storelogic.heartBeat();
    Assert.equal(uint(n), uint(2), "heartBeat, Not 2.");
  }

  function testUseSub() public {
    Assert.equal(storelogic.useSub(), uint(5), "lolSub, Not 5.");
  }

   function testIdenticalProduct () public {
     Assert.equal(bool(true), storelogic.identicalProduct(
       uint256(0), bytes32("a"), bytes32("b"), uint256(1),
       uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
       "Product are identical.");
     Assert.equal(bool(false), storelogic.identicalProduct(
       uint256(2), bytes32("a"), bytes32("b"), uint256(1),
       uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
       "Product are not identical (2).");
     Assert.equal(bool(false), storelogic.identicalProduct(
       uint256(0), bytes32("y"), bytes32("b"), uint256(1),
       uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
       "Product are not identical (y).");
     Assert.equal(bool(false), storelogic.identicalProduct(
       uint256(0), bytes32("a"), bytes32("z"), uint256(1),
       uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
       "Product are not identical (z).");
     Assert.equal(bool(false), storelogic.identicalProduct(
       uint256(0), bytes32("a"), bytes32("b"), uint256(3),
       uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
       "Product are not identical (3).");
   }

   function testAddProduct () public {
     uint256 n0 = storelogic.nProductsForSale();
     Assert.equal(n0, uint(0), "Store should be empty.");

     uint256 expectedId = 0;
     bytes32 expectedName = "bike";
     uint256 expectedQuantity = 5;
     bytes32 expectedDescription = "A very nice bike !";
     uint256 expectedPrice = 220;

     uint256 retId = storelogic.addProduct (expectedName, expectedQuantity, expectedDescription, expectedPrice);

     uint n1 = storelogic.nProductsForSale();
     Assert.equal(retId, uint(0), "Product Id should be 0.");
     Assert.equal(n1, uint(1), "1 product for sale.");

     (bytes32 retName, uint256 retQuantity, bytes32 retDescription, uint256 retPrice) = storelogic.getProduct (retId);

     bool resIdenticalProduct = storelogic.identicalProduct(expectedId, expectedName, expectedDescription, expectedPrice, retId, retName, retDescription, retPrice);

     Assert.equal(bool(true), resIdenticalProduct, "1 product added correctly.");

     Assert.equal(uint(expectedQuantity), uint(retQuantity), "quantity injected in store and available in store must be the same.");
   }

 function testAddProduct2 () public {
     uint256 n0 = storelogic.nProductsForSale();
     Assert.equal(n0, uint(1), "Store should have 1 product.");

     uint256 expectedId = 1;
     bytes32 expectedName = "Big bike";
     uint256 expectedQuantity = 2;
     bytes32 expectedDescription = "A very nice big bike !";
     uint256 expectedPrice = 500;

     uint256 retId = storelogic.addProduct (expectedName, expectedQuantity, expectedDescription, expectedPrice);

     uint256 n1 = storelogic.nProductsForSale();
     Assert.equal(n1, uint(2), "1 product for sale.");
     Assert.equal(retId, uint(1), "Product Id should be 1.");

     (bytes32 retName, uint256 retQuantity, bytes32 retDescription, uint256 retPrice) = storelogic.getProduct (retId);

     bool resIdenticalProduct = storelogic.identicalProduct(expectedId, expectedName, expectedDescription, expectedPrice, retId, retName, retDescription, retPrice);

     Assert.equal(bool(true), resIdenticalProduct, "1 product added correctly.");

     Assert.equal(uint(expectedQuantity), uint(retQuantity), "quantity injected in store and available in store must be the same.");
 }

   function testNumberOfProducts () public {
       uint256 n = storelogic.productNumber();
       Assert.equal(uint256(n), uint256(2), "Store should have 2 products.");
     }

   function testNumberOfProductsForSale () public {
     uint256 n = storelogic.nProductsForSale();
     Assert.equal(uint256(n), uint256(2), "Store should have 2 products for sale.");
   }

   function testUpdatePrice () public {
     uint256 expected = 2048;
     Assert.notEqual(expected, initialPrice, "initial price and expected price must be different.");
     (bytes32 initialName, uint256 initialQuantity, bytes32 initialDescription, uint256 initialPrice) = storelogic.getProduct (1);
     storelogic.updatePrice (1, expected);
     (bytes32 name, uint256 quantity, bytes32 description, uint256 price) = storelogic.getProduct (1);
     Assert.equal(initialName, name,"name must not be changed.");
     Assert.equal(initialQuantity, quantity, "quantity must not be changed.");
     Assert.equal(initialDescription, description, "description must not be changed.");
     Assert.equal(price, expected, "price must be updated.");
   }
//(bytes32 name, uint256 quantity, bytes32 description, uint256 price)
   function testUpdateQuantity () public {
     uint256 expected = 15;
     (bytes32 initialName, uint256 initialQuantity, bytes32 initialDescription, uint256 initialPrice) = storelogic.getProduct (1);
     Assert.notEqual(expected, initialQuantity, "initial quantity and expected quantity must be different.");
     storelogic.updateQuantity (1, expected);
     (bytes32 name, uint256 quantity, bytes32 description, uint256 price) = storelogic.getProduct (1);
     Assert.equal(initialName, name,"name must not be changed.");
     Assert.equal(initialDescription, description, "description must not be changed.");
     Assert.equal(initialPrice, price, "price must not be changed.");
     Assert.equal(quantity, expected, "quantity must be updated.");
   }

   function testUpdateDescription () public {
     bytes32 expected = "Big big bike";
     (bytes32 initialName, uint256 initialQuantity, bytes32 initialDescription, uint256 initialPrice) = storelogic.getProduct (1);
     Assert.notEqual(expected, initialDescription, "initial description and expected description must be different.");
     storelogic.updateDescription (1, expected);
     (bytes32 name, uint256 quantity, bytes32 description, uint256 price) = storelogic.getProduct (1);
     Assert.equal(initialName, name,"name must not be changed.");
     Assert.equal(initialQuantity, quantity, "quantity must not be changed.");
     Assert.equal(initialPrice, price, "price must not be changed.");
     Assert.equal(description, expected, "description must be updated.");
   }

   function testStoreRemoveProduct () public {
     //get number of product in the shop
     uint nProductBefore = storelogic.nProductsForSale();
     Assert.equal(nProductBefore, uint256(2), "Store must have 2 products.");
     storelogic.removeProduct (uint (1));
     //get number of product in the shop
     uint nProductAfter = storelogic.nProductsForSale();
     //Asser that minus 1
     Assert.equal(uint(nProductAfter), uint(nProductBefore-1), "Product deletion must work.");
   }


 }
 */
