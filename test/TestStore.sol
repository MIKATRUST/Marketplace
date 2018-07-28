pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "./../contracts/Store.sol";

contract TestStore {

  Store store = Store(DeployedAddresses.Store());

  function testAddProduct () public {
    uint n0 = store.nProductsForSale();
    Assert.equal(n0, uint(0), "Store should be empty.");
    uint idProduct1 = store.addProduct ("bike", "A very nice bike !", 256);
    Assert.equal(idProduct1, uint(0), "Product id should be 0 .");
    uint n1 = store.nProductsForSale();
    Assert.equal(n1, uint(1), "Store should have 1 product");
    uint idProduct2 = store.addProduct ("painting", "A very nice painting !", 156);
    Assert.equal(idProduct2, uint(1), "Product id should be 1.");
    uint n2 = store.nProductsForSale();
    Assert.equal(n2, uint(2), "Store should have 2 product");
  }

  function testNumberOfProductsForSale () public {
    uint n = store.nProductsForSale();
    Assert.equal(uint(2), uint(2), "Store should have 2 products");
  }

  function testUpdateProduct () public {
    bool res = store.updateProduct(1, "big bike", "A really big bike", 220);
    Assert.equal(res, true, "Shoud get true");
    //TBD check that updated fields where really updated !
    Assert.equal(uint(2), uint(2), "Store should have 2 products");
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

  function testStorePurchaseProduct () public {
    //TBD
  }

  function testUpdatePRice () public {
    //TBD
  }

  //TBD : condition aux limites à tester : purchase all products from store, check nproduct in store == 0

}
