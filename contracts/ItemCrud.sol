pragma solidity ^0.4.24;

contract ItemCrud {

  struct ItemStruct {
    bytes32 itemName;
    uint itemQuantity;
    bytes32 itemDescription;
    uint itemPrice;
    bytes32 itemImage;
    uint index;
  }

  mapping(uint => ItemStruct) private itemStructs;
  uint[] private itemIndex;

  event LogNewItem   (uint indexed itemSku, uint index, bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage);
  event LogUpdateItem(uint indexed itemSku, uint index, bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage);
  event LogDeleteItem(uint indexed itemSku, uint index);

  modifier isAnItem (uint _itemSku)
  {
      require (isItem(_itemSku) == true,
        "this is not an item."
      );
      _;
  }

  modifier isNotAnItem (uint _itemSku)
  {
      require (isItem(_itemSku) == false,
        "this is an item."
      );
      _;
  }

  function isItem(uint itemSku)
    public
    constant
    returns(bool isIndeed)
  {
    if(itemIndex.length == 0) return false;
    return (itemIndex[itemStructs[itemSku].index] == itemSku);
  }

  function insertItem(
    uint itemSku,
    bytes32 itemName,
    uint itemQuantity,
    bytes32 itemDescription,
    uint itemPrice,
    bytes32 itemImage)
    public
    isNotAnItem(itemSku)
    returns(uint index)
  {
    //if(isItem(itemSku)) throw;
    itemStructs[itemSku].itemName = itemName;
    itemStructs[itemSku].itemQuantity   = itemQuantity;
    itemStructs[itemSku].itemDescription   = itemDescription;
    itemStructs[itemSku].itemPrice = itemPrice;
    itemStructs[itemSku].itemImage = itemImage;
    itemStructs[itemSku].index     = itemIndex.push(itemSku)-1;
    emit LogNewItem(
      itemSku,
      itemStructs[itemSku].index,
      itemName,
      itemQuantity,
      itemDescription,
      itemPrice,
      itemImage);
    return itemIndex.length-1;
  }

  function deleteItem(uint itemSku)
    public
    isAnItem(itemSku)
    returns(uint index)
  {
    //if(!isItem(itemSku)) throw;
    uint rowToDelete = itemStructs[itemSku].index;
    uint keyToMove = itemIndex[itemIndex.length-1];
    itemIndex[rowToDelete] = keyToMove;
    itemStructs[keyToMove].index = rowToDelete;
    itemIndex.length--;
    emit LogDeleteItem(
        itemSku,
        rowToDelete);
    emit LogUpdateItem(
      keyToMove,
      rowToDelete,
      itemStructs[keyToMove].itemName,
      itemStructs[keyToMove].itemQuantity,
      itemStructs[keyToMove].itemDescription,
      itemStructs[keyToMove].itemPrice,
      itemStructs[keyToMove].itemImage);
    return rowToDelete;
  }

  function getItem(uint itemSku)
    public
    isAnItem(itemSku)
    constant
    returns(bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage, uint index)
  {
    //if(!isItem(itemSku)) throw;
    return(
      itemStructs[itemSku].itemName,
      itemStructs[itemSku].itemQuantity,
      itemStructs[itemSku].itemDescription,
      itemStructs[itemSku].itemPrice,
      itemStructs[itemSku].itemImage,
      itemStructs[itemSku].index);
  }

  function updateItemPrice(uint itemSku, uint itemPrice)
    public
    isNotAnItem(itemSku)
    returns(bool success)
  {
    //if(!isItem(itemSku)) throw;
    itemStructs[itemSku].itemPrice = itemPrice;
    emit LogUpdateItem(
      itemSku,
      itemStructs[itemSku].index,
      itemStructs[itemSku].itemName,
      itemStructs[itemSku].itemQuantity,
      itemStructs[itemSku].itemDescription,
      itemPrice,
      itemStructs[itemSku].itemImage);
    return true;
  }

  function updateItemQuantity(uint itemSku, uint itemQuantity)
    public
    isAnItem(itemSku)
    returns(bool success)
  {
    //if(!isItem(itemSku)) throw;
    itemStructs[itemSku].itemQuantity = itemQuantity;
    emit LogUpdateItem(
      itemSku,
      itemStructs[itemSku].index,
      itemStructs[itemSku].itemName,
      itemQuantity,
      itemStructs[itemSku].itemDescription,
      itemStructs[itemSku].itemPrice,
      itemStructs[itemSku].itemImage);
    return true;
  }

  function getItemCount()
    public
    constant
    returns(uint count)
  {
    return itemIndex.length;
  }

  function getItemAtIndex(uint index)
    public
    constant
    returns(uint itemSku)
  {
    return itemIndex[index];
  }

}
