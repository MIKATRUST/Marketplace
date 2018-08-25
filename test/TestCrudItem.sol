pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "./../contracts/CrudItem.sol";

contract TestCrudItem is CrudItem{

  CrudItem cruditem = CrudItem(DeployedAddresses.CrudItem());
  uint index;

  /*
  struct ItemStruct {
    bytes32 itemName;
    uint itemQuantity;
    bytes32 itemDescription;
    uint itemPrice;
    bytes32 itemImage;
    uint index;
  }*/

  //function insertCrudItem(uint itemSku, bytes32 itemName, uint itemQuantity,bytes32 itemDescription, uint itemPrice,bytes32 itemImage)

  function testInsertCrudItem() public {
    insertCrudItem(111111,"item 1",1,"desc 1",11,"images/BIKE1.jpeg");
    insertCrudItem(111112,"item 2",2,"desc 2",12,"images/BIKE2.jpeg");
    insertCrudItem(111113,"item 3",3,"desc 3",13,"images/BIKE3.jpeg");
    insertCrudItem(111114,"item 4",4,"desc 4",14,"images/BIKE4.jpeg");
    insertCrudItem(111115,"item 5",5,"desc 5",15,"images/BIKE5.jpeg");
    Assert.equal(uint256(5), getCrudItemCount(), "5 items inserted correctly.");
  }

  function testGetCrudItem() public {
    bytes32 recCrudItemName;
    uint recCrudItemQuantity;
    bytes32 recCrudItemDescription;
    uint recCrudItemPrice;
    bytes32 recCrudItemImage;

    bytes32 expectedCrudItemName = "item 2";
    uint expectedCrudItemQuantity = 2;
    bytes32 expectedCrudItemDescription = "desc 2";
    uint expectedCrudItemPrice = 12;
    bytes32 expectedCrudItemImage = "images/BIKE2.jpeg";

    (recCrudItemName,recCrudItemQuantity,recCrudItemDescription,recCrudItemPrice,recCrudItemImage,index) = getCrudItem(111112);

    Assert.equal(bytes32(recCrudItemName), bytes32(expectedCrudItemName), "recovered and expected itemName should match");
    Assert.equal(bytes32(recCrudItemQuantity), bytes32(expectedCrudItemQuantity), "recovered and expected itemQuantity should match");
    Assert.equal(bytes32(recCrudItemDescription), bytes32(expectedCrudItemDescription), "recovered and expected itemDescription should match");
    Assert.equal(bytes32(recCrudItemPrice), bytes32(expectedCrudItemPrice), "recovered and expected itemPrice should match");
    Assert.equal(bytes32(recCrudItemImage), bytes32(expectedCrudItemImage), "recovered and expected itemImage should match");
  }

  function testGetCrudItemAtIndex() public {
    uint expectedCrudItemSku = 111112;
    uint recCrudItemSku = getCrudItemAtIndex(index);
    Assert.equal(recCrudItemSku, expectedCrudItemSku, "recovered and expected storeName should match");
  }

  function testDeleteCrudItem() public {
    deleteCrudItem(111111);
    deleteCrudItem(111115);
    Assert.equal(uint256(3), getCrudItemCount(), "3 stores remaining.");
  }

  function testUpdateCrudItemQuantity() public {
    bool ret = updateCrudItemQuantity(111114,2);
    Assert.equal(ret, true, "update function should return true.");
    (,uint itemQuantity,,,,) = getCrudItem(111114);
    Assert.equal(uint(2), itemQuantity, "Quantity updated should be 2.");
  }

  function testUpdateCrudItemPrice() public {
    (,,,uint itemPrice,,) = getCrudItem(111114);
    Assert.equal(itemPrice, 14, "price initialized to 14.");
    bool ret = updateCrudItemPrice(111114,4);
    Assert.equal(ret, true, "update function should return true.");
    (,,,itemPrice,,)  = getCrudItem(111114);
    Assert.equal(itemPrice, 4, "updated price should be 4.");
  }

  function testCrudItemCount() public {
    Assert.equal(uint256(3), getCrudItemCount(), "3 store remaining.");
    deleteCrudItem(111112);
    deleteCrudItem(111113);
    deleteCrudItem(111114);
    Assert.equal(uint256(0), getCrudItemCount(), "0 store remaining.");
  }

}
