pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "./../contracts/Store.sol";

contract TestStore {

  Store store = Store(DeployedAddresses.Store());

  function testIdenticalProduct () public {
    Assert.equal(bool(true), store.identicalProduct(
      uint256(0), bytes32("a"), bytes32("b"), uint256(1),
      uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
      "Product are identical.");
    Assert.equal(bool(false), store.identicalProduct(
      uint256(2), bytes32("a"), bytes32("b"), uint256(1),
      uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
      "Product are not identical (2).");
    Assert.equal(bool(false), store.identicalProduct(
      uint256(0), bytes32("y"), bytes32("b"), uint256(1),
      uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
      "Product are not identical (y).");
    Assert.equal(bool(false), store.identicalProduct(
      uint256(0), bytes32("a"), bytes32("z"), uint256(1),
      uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
      "Product are not identical (z).");
    Assert.equal(bool(false), store.identicalProduct(
      uint256(0), bytes32("a"), bytes32("b"), uint256(3),
      uint256(0), bytes32("a"), bytes32("b"), uint256(1)),
      "Product are not identical (3).");
  }

  function testAddProduct () public {
    uint256 n0 = store.nProductsForSale();
    Assert.equal(n0, uint(0), "Store should be empty.");

    uint256 expectedId = 0;
    bytes32 expectedName = "bike";
    uint256 expectedQuantity = 5;
    bytes32 expectedDescription = "A very nice bike !";
    uint256 expectedPrice = 220;

    uint256 retId = store.addProduct (expectedName, expectedQuantity, expectedDescription, expectedPrice);

    uint n1 = store.nProductsForSale();
    Assert.equal(retId, uint(0), "Product Id should be 0.");

    (bytes32 retName, uint256 retQuantity, bytes32 retDescription, uint256 retPrice) = store.getProduct (retId);

    bool resIdenticalProduct = store.identicalProduct(expectedId, expectedName, expectedDescription, expectedPrice, retId, retName, retDescription, retPrice);

    Assert.equal(bool(true), resIdenticalProduct, "1 product added correctly.");
  }

function testAddProduct2 () public {
    uint256 n0 = store.nProductsForSale();
    Assert.equal(n0, uint(1), "Store should have 1 product.");

    uint256 expectedId = 1;
    bytes32 expectedName = "Big bike";
    uint256 expectedQuantity = 2;
    bytes32 expectedDescription = "A very nice big bike !";
    uint256 expectedPrice = 500;

    uint256 retId = store.addProduct (expectedName, expectedQuantity, expectedDescription, expectedPrice);

    uint256 n1 = store.nProductsForSale();
    Assert.equal(retId, uint(1), "Product Id should be 1.");

    (bytes32 retName, uint256 retQuantity, bytes32 retDescription, uint256 retPrice) = store.getProduct (retId);

    bool resIdenticalProduct = store.identicalProduct(expectedId, expectedName, expectedDescription, expectedPrice, retId, retName, retDescription, retPrice);

    Assert.equal(bool(true), resIdenticalProduct, "1 product added correctly.");
}

  function testNumberOfProducts () public {
      uint256 n = store.productNumber();
      Assert.equal(uint256(n), uint256(2), "Store should have 2 products.");
    }

  function testNumberOfProductsForSale () public {
    uint256 n = store.nProductsForSale();
    Assert.equal(uint256(n), uint256(2), "Store should have 2 products for sale.");
  }

  function testUpdatePrice () public {
    uint256 expected = 2048;
    store.updatePrice (1, expected);
    (bytes32 name, uint256 quantity, bytes32 description, uint256 price) = store.getProduct (1);
    Assert.equal(price, expected, "Price should be updated.");
  }

  function testUpdateQuantity () public {
    uint256 expected = 15;
    store.updateQuantity (1, expected);
    (bytes32 name, uint256 quantity, bytes32 description, uint256 price) = store.getProduct (1);
    Assert.equal(quantity, expected, "Quantity should be updated.");
  }

  function testUpdateDescription () public {
    bytes32 expected = "Big big bike";
    store.updateDescription (1, expected);
    (bytes32 name, uint256 quantity, bytes32 description, uint256 price) = store.getProduct (1);
    Assert.equal(description, expected, "Description should be updated.");
  }

  function testStoreRemoveProduct () public {
    //get number of product in the shop
    uint nProductBefore = store.nProductsForSale();
    Assert.equal(nProductBefore, uint256(2), "Store should have 2 products");
    bool res = store.removeProduct (uint (1));
    //get number of product in the shop
    uint nProductAfter = store.nProductsForSale();
    //Asser that minus 1
    Assert.equal(uint(nProductAfter), uint(nProductBefore-1), "Product deletion should work");
  }

/*
  function testStorePurchaseProduct () public {
    uint256 quantityToBuy = 1;
    uint256 res = store.purchaseProduct (1, quantityToBuy);
    Assert.equal(uint256(1), quantityToBuy, "Product purchase should work");
    //TBD check quantity -> in js
  }
*/

//  function purchaseProduct (uint256 id, uint256 quantity /*string physical address */)
//  public

//  function testWithdrawReceivedPayments () public {
    //TBD
//  }



  //TBD : condition aux limites à tester : purchase all products from store, check nproduct in store == 0

}
