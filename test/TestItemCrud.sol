pragma solidity ^0.4.24;

// Strategy for using event injavascript
//https://ethereum.stackexchange.com/questions/39171/how-to-check-events-in-truffle-tests

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "./../contracts/ItemCrud.sol";

contract TestItemCrud {

  ItemCrud itemcrud = ItemCrud(DeployedAddresses.ItemCrud());
  uint index;

/*
  uint itemSku,
  bytes32 itemName,
  uint itemQuantity,
  bytes32 itemDescription,
  uint itemPrice,
  bytes32 itemImage)
*/

  function testInsertItem() public {
    //function insertItem(uint itemSku, bytes32 itemName, uint itemQuantity,bytes32 itemDescription, uint itemPrice,bytes32 itemImage)
    itemcrud.insertItem(111111,"item 1",1,"desc 1",11,"images/BIKE1.jpeg");
    itemcrud.insertItem(111112,"item 2",2,"desc 2",12,"images/BIKE2.jpeg");
    itemcrud.insertItem(111113,"item 3",3,"desc 3",13,"images/BIKE3.jpeg");
    itemcrud.insertItem(111114,"item 4",4,"desc 4",14,"images/BIKE4.jpeg");
    itemcrud.insertItem(111115,"item 5",5,"desc 5",15,"images/BIKE5.jpeg");
    //try insert already existing store, tbd with js
    Assert.equal(uint256(5), itemcrud.getItemCount(), "5 items inserted correctly.");
  }

  function testGetItem() public {
    bytes32 recItemName;
    uint recItemQuantity;
    bytes32 recItemDescription;
    uint recItemPrice;
    bytes32 recItemImage;

    bytes32 expectedItemName = "item 2";
    uint expectedItemQuantity = 2;
    bytes32 expectedItemDescription = "desc 2";
    uint expectedItemPrice = 12;
    bytes32 expectedItemImage = "images/BIKE2.jpeg";
    //try request not a store, tbd with js
    (recItemName,recItemQuantity,recItemDescription,recItemPrice,recItemImage,index) = itemcrud.getItem(111112);

    Assert.equal(bytes32(recItemName), bytes32(expectedItemName), "recovered and expected itemName should match");
    Assert.equal(bytes32(recItemQuantity), bytes32(expectedItemQuantity), "recovered and expected itemQuantity should match");
    Assert.equal(bytes32(recItemDescription), bytes32(expectedItemDescription), "recovered and expected itemDescription should match");
    Assert.equal(bytes32(recItemPrice), bytes32(expectedItemPrice), "recovered and expected itemPrice should match");
    Assert.equal(bytes32(recItemImage), bytes32(expectedItemImage), "recovered and expected itemImage should match");
  }

  //TBD : test function update

  function testGetItemAtIndex() public {
    uint expectedItemSku = 111112;
    uint recItemSku = itemcrud.getItemAtIndex(index);
    Assert.equal(recItemSku, expectedItemSku, "recovered and expected storeName should match");
  }

  function testDeleteItem() public {
    itemcrud.deleteItem(111111);
    itemcrud.deleteItem(111115);
    // try delete not a store, tbd with js
    Assert.equal(uint256(3), itemcrud.getItemCount(), "3 stores remaining.");

  }

  function testItemCount() public {
    itemcrud.deleteItem(111112);
    itemcrud.deleteItem(111113);
    itemcrud.deleteItem(111114);
    Assert.equal(uint256(0), itemcrud.getItemCount(), "0 store remaining.");
  }

  //TBD : add test of updateQuantity

}
