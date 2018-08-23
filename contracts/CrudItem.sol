pragma solidity ^0.4.24;

contract CrudItem {

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

  event LogCrudNewItem   (uint indexed itemSku, uint index, bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage);
  event LogCrudUpdateItem(uint indexed itemSku, uint index, bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage);
  event LogCrudDeleteItem(uint indexed itemSku, uint index);

  modifier isACrudItem (uint _itemSku)
  {
      require (isCrudItem(_itemSku) == true,
        "this is not an item."
      );
      _;
  }

  modifier isNotACrudItem (uint _itemSku)
  {
      require (isCrudItem(_itemSku) == false,
        "this is an item."
      );
      _;
  }

  function isCrudItem(uint itemSku)
    public
    constant
    returns(bool isIndeed)
  {
    if(itemIndex.length == 0) return false;
    return (itemIndex[itemStructs[itemSku].index] == itemSku);
  }

  function insertCrudItem(
    uint itemSku,
    bytes32 itemName,
    uint itemQuantity,
    bytes32 itemDescription,
    uint itemPrice,
    bytes32 itemImage)
    public
    isNotACrudItem(itemSku)
    returns(uint index)
  {
    //if(isItem(itemSku)) throw;
    itemStructs[itemSku].itemName = itemName;
    itemStructs[itemSku].itemQuantity = itemQuantity;
    itemStructs[itemSku].itemDescription = itemDescription;
    itemStructs[itemSku].itemPrice = itemPrice;
    itemStructs[itemSku].itemImage = itemImage;
    itemStructs[itemSku].index = itemIndex.push(itemSku)-1;
    emit LogCrudNewItem(
      itemSku,
      itemStructs[itemSku].index,
      itemName,
      itemQuantity,
      itemDescription,
      itemPrice,
      itemImage);
    return itemIndex.length-1;
  }

  function deleteCrudItem(uint itemSku)
    public
    isACrudItem(itemSku)
    returns(uint index)
  {
    //if(!isItem(itemSku)) throw;
    uint rowToDelete = itemStructs[itemSku].index;
    uint keyToMove = itemIndex[itemIndex.length-1];
    itemIndex[rowToDelete] = keyToMove;
    itemStructs[keyToMove].index = rowToDelete;
    itemIndex.length--;
    emit LogCrudDeleteItem(
        itemSku,
        rowToDelete);
    emit LogCrudUpdateItem(
      keyToMove,
      rowToDelete,
      itemStructs[keyToMove].itemName,
      itemStructs[keyToMove].itemQuantity,
      itemStructs[keyToMove].itemDescription,
      itemStructs[keyToMove].itemPrice,
      itemStructs[keyToMove].itemImage);
    return rowToDelete;
  }

  function getCrudItem(uint itemSku)
    public
    isACrudItem(itemSku)
    constant
    returns(bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage, uint index)
  {
    return(
      itemStructs[itemSku].itemName,
      itemStructs[itemSku].itemQuantity,
      itemStructs[itemSku].itemDescription,
      itemStructs[itemSku].itemPrice,
      itemStructs[itemSku].itemImage,
      itemStructs[itemSku].index);
  }

  function getCrudItemQuantityPrice(uint itemSku)
    public
    isACrudItem(itemSku)
    constant
    returns(uint itemQuantity, uint itemPrice)
  {
    return(
      itemStructs[itemSku].itemQuantity,
      itemStructs[itemSku].itemPrice);
  }

  function updateCrudItemPrice(uint itemSku, uint itemPrice)
    public
    isACrudItem(itemSku)
    returns(bool success)
  {
    itemStructs[itemSku].itemPrice = itemPrice;
    emit LogCrudUpdateItem(
      itemSku,
      itemStructs[itemSku].index,
      itemStructs[itemSku].itemName,
      itemStructs[itemSku].itemQuantity,
      itemStructs[itemSku].itemDescription,
      itemPrice,
      itemStructs[itemSku].itemImage);
    return true;
  }

  function updateCrudItemQuantity(uint itemSku, uint itemQuantity)
    public
    isACrudItem(itemSku)
    returns(bool success)
  {
    itemStructs[itemSku].itemQuantity = itemQuantity;
    emit LogCrudUpdateItem(
      itemSku,
      itemStructs[itemSku].index,
      itemStructs[itemSku].itemName,
      itemQuantity,
      itemStructs[itemSku].itemDescription,
      itemStructs[itemSku].itemPrice,
      itemStructs[itemSku].itemImage);
    return true;
  }

  function getCrudItemCount()
    public
    constant
    returns(uint count)
  {
    return itemIndex.length;
  }

  function getCrudItemAtIndex(uint index)
    public
    constant
    returns(uint itemSku)
  {
    return itemIndex[index];
  }

}
