pragma solidity ^0.4.24;

/**
 * @title Crud Item contract
 * @dev C.R.U.D. — Create, Retrieve, Update, Delete Items
 * @dev Low level call/transaction to access item privately defined in
 * CrudItem contract.
 * @dev index are subjected to change, eg when an element is deleted. Invariant
 * is the itemSku of the item which is also the key of the mapping.  
 * @dev Internal function to be inherited by a contract.
 * @dev Adapted work from Rob Hitchens, Google for "Solidity CRUD- Part 1"
 */
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

  /**
  * Events - publicize actions to external listeners
  */
  event LogCrudNewItem   (uint indexed itemSku, uint index, bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage);
  event LogCrudUpdateItem(uint indexed itemSku, uint index, bytes32 itemName, uint itemQuantity, bytes32 itemDescription, uint itemPrice, bytes32 itemImage);
  event LogCrudDeleteItem(uint indexed itemSku, uint index);

  /**
   * @dev Revert if item SKU does not exist in CrudItem.
   */
  modifier isACrudItem (uint _itemSku)
  {
      require (isCrudItem(_itemSku) == true,
        "this is not an sku item."
      );
      _;
  }

  /**
   * @dev Revert if item SKU does exist in CrudItem.
   */
  modifier isNotACrudItem (uint _itemSku)
  {
      require (isCrudItem(_itemSku) == false,
        "this is an sku item."
      );
      _;
  }

  /**
   * @dev Revert if item SKU does exist in CrudItem.
   * @dev Returns boolean true if given sku is an existing CrudItem sku.
   * @param itemSku if the sku to be tested.
   */
  function isCrudItem(uint itemSku)
    internal
    constant
    returns(bool isIndeed)
  {
    if(itemIndex.length == 0) return false;
    return (itemIndex[itemStructs[itemSku].index] == itemSku);
  }

  /**
   * @dev Insert a new item in CrudItem.
   * @dev Returns the index in CrudItem of the newly inserted item.
   * @param itemSku The SKU of the item.
   * @param itemName The name of the item.
   * @param itemQuantity The available quantity of the item.
   * @param itemDescription The description of the item
   * @param itemPrice The UNIT price of the item.
   * @param itemImage The image link of the item.
   */
  function insertCrudItem(
    uint itemSku,
    bytes32 itemName,
    uint itemQuantity,
    bytes32 itemDescription,
    uint itemPrice,
    bytes32 itemImage)
    internal
    isNotACrudItem(itemSku)
    returns(uint index)
  {
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

  /**
   * @dev Delete a given itemSku in CrudItem.
   * @dev Returns the index of deleted item in CrudItem.
   * @param itemSku The SKU of the item to remove.
   */
  function deleteCrudItem(uint itemSku)
    internal
    isACrudItem(itemSku)
    returns(uint index)
  {
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

  /**
   * @dev Get an item given the item SKU.
   * @dev Returns the index in CrudItem of the newly inserted item.
   * @dev Returns itemName The name of the item.
   * @dev Returns itemQuantity The available quantity of the item.
   * @dev Returns itemDescription The description of the item.
   * @dev Returns itemPrice The UNIT price of the item.
   * @dev Returns itemImage The image link of the item.
   * @dev Returns index The index of the item in the contract CrudItem.
   * @param itemSku The SKU of the item.
   */
  function getCrudItem(uint itemSku)
    internal
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

  /**
   * @dev Get available quantity and price for a given SKU item.
   * @dev Returns quantity of given SKU item.
   * @dev Returns price of given SKU item.
   * @param itemSku The SKU of the item.
   */
  function getCrudItemQuantityPrice(uint itemSku)
    internal
    isACrudItem(itemSku)
    constant
    returns(uint itemQuantity, uint itemPrice)
  {
    return(
      itemStructs[itemSku].itemQuantity,
      itemStructs[itemSku].itemPrice);
  }

  /**
   * @dev Update the price of an item.
   * @dev Returns boolean success if success.
   * @param itemSku The SKU of the item.
   * @param itemPrice The UNIT price of the sku item.
   */
  function updateCrudItemPrice(uint itemSku, uint itemPrice)
    internal
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

  /**
   * @dev Update the available quantity of an item.
   * @dev Returns boolean success if success.
   * @param itemSku The SKU of the item.
   * @param itemQuantity The update for the quantity.
   */
  function updateCrudItemQuantity(uint itemSku, uint itemQuantity)
    internal
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

  /**
  * @dev Get the item SKU count in CrudItem.
  * @dev Returns count of SKU in the contract.
  */
  function getCrudItemCount()
    internal
    constant
    returns(uint count)
  {
    return itemIndex.length;
  }

  /**
  * @dev Get item index in CrudItem.
  * @dev Returns itemSku The sku of the item.
  * @param index The index of the item in CrudeItem.
  */
  function getCrudItemAtIndex(uint index)
    internal
    constant
    returns(uint itemSku)
  {
    return itemIndex[index];
  }

}
