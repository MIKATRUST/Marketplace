pragma solidity ^0.4.24;

/**
 * @title Crud Store contract
 * @dev C.R.U.D. — Create, Retrieve, Update, Delete Stores
 * @dev Low level call/transaction to access stores privately defined in
 * CrudStore contract
 * @dev Internal function to be inherited by a contract.
 * @dev Adapted work from Rob Hitchens, Google for "Solidity CRUD- Part 1"
 * @dev index are subjected to change, eg when an element is deleted. Invariant
 * is the address of the store which is also the key of the mapping.
 */

contract CrudStore {

  struct StoreStruct {
    bytes32 storeName;
    address storeAddress;
    uint index;
  }

  mapping(address => StoreStruct) private storeStructs;
  address[] private storeIndex;

  /**
  * Events - publicize actions to external listeners
  */
  event LogInsertCrudStore(address /*indexed*/ storeAddress, uint index, bytes32 storeName);
  event LogUpdateCrudStore(address indexed storeAddress, uint index, bytes32 storeName);
  event LogDeleteCrudStore(address indexed storeAddress, uint index);

  /**
   * @dev Revert if store address does not exist in CrudStore.
   */
  modifier isACrudStore (address _storeAddress)
  {
      require (isCrudStore(_storeAddress) == true,
        "this is not a store."
      );
      _;
  }

  /**
   * @dev Revert if store address does exist in CrudStore.
   */
  modifier isNotACrudStore (address _storeAddress)
  {
      require (isCrudStore(_storeAddress) == false,
        "this is a store."
      );
      _;
  }


  /**
   * @dev Check if an address il already known as a store.
   * @dev Returns boolean true if given address is an existing CrudStore.
   * @param storeAddress is the address of the store.
   */
  function isCrudStore(address storeAddress)
    internal
    constant
    returns(bool isIndeed)
  {
    if(storeIndex.length == 0) return false;
    return (storeIndex[storeStructs[storeAddress].index] == storeAddress);
  }

  /**
   * @dev Insert a new Crud Store.
   * @dev Returns boolean true if given address is an existing CrudStore.
   * @param storeAddress is the address of the store.
   * @param storeName is the name of the store.
   */
  function insertCrudStore(
    address storeAddress,
    bytes32 storeName)
    internal
    isNotACrudStore(storeAddress)
    returns(uint index)
  {
    storeStructs[storeAddress].storeName = storeName;
    storeStructs[storeAddress].index     = storeIndex.push(storeAddress)-1;
    emit LogInsertCrudStore(
        storeAddress,
        storeStructs[storeAddress].index,
        storeName);
    return storeIndex.length-1;
  }

  /**
   * @dev Delete a Crud Store.
   * @dev Returns the index of deleted store CrudStore.
   * @param storeAddress is the address of the store.
   */
  function deleteCrudStore(address storeAddress)
    internal
    isACrudStore(storeAddress)
    returns(uint index)
  {
    uint rowToDelete = storeStructs[storeAddress].index;
    address keyToMove = storeIndex[storeIndex.length-1];
    storeIndex[rowToDelete] = keyToMove;
    storeStructs[keyToMove].index = rowToDelete;
    storeIndex.length--;
    emit LogDeleteCrudStore(
        storeAddress,
        rowToDelete);
    emit LogUpdateCrudStore(
        keyToMove,
        rowToDelete,
        storeStructs[keyToMove].storeName);
    return rowToDelete;
  }

  /**
   * @dev Get store from address store.
   * @dev Returns storeName the name of the deleted store in CrudStore.
   * @dev Returns the index of the deleted store in CrudStore.
   * @param storeAddress is the address of the store.
   */
  function getCrudStore(address storeAddress)
    internal
    constant
    isACrudStore(storeAddress)
    returns(bytes32 storeName, uint index)
  {
    return(
      storeStructs[storeAddress].storeName,
      storeStructs[storeAddress].index);
  }

  /**
  * @dev Get the store count in CrudStore.
  * @dev Returns number of stores in the contract.
  */
  function getCrudStoreCount()
    internal
    /*public*/
    constant
    returns(uint count)
  {
    return storeIndex.length;
  }

  /**
  * @dev Get store address from store index.
  * @dev Returns the address of teh store.
  * @param index The index of the store in CrudeStore.
  */
  function getCrudStoreAtIndex(uint index)
    internal
    constant
    returns(address storeAddress)
  {
    return storeIndex[index];
  }

}
