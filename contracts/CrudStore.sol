pragma solidity ^0.4.24;

/* Special thanks to Rob Hitchens https://medium.com/@robhitchens/solidity-crud-part-1-824ffa69509a
*/

contract CrudStore {

  struct StoreStruct {
    bytes32 storeName;
    address storeAddress;
    uint index;
  }

  mapping(address => StoreStruct) private storeStructs;
  address[] private storeIndex;

  event LogInsertCrudStore(address /*indexed*/ storeAddress, uint index, bytes32 storeName);
  event LogUpdateCrudStore(address indexed storeAddress, uint index, bytes32 storeName);
  event LogDeleteCrudStore(address indexed storeAddress, uint index);

  modifier isACrudStore (address _storeAddress)
  {
      require (isCrudStore(_storeAddress) == true,
        "this is not a store."
      );
      _;
  }

  modifier isNotACrudStore (address _storeAddress)
  {
      require (isCrudStore(_storeAddress) == false,
        "this is a store."
      );
      _;
  }

  function isCrudStore(address storeAddress)
    //public
    internal
    constant
    returns(bool isIndeed)
  {
    if(storeIndex.length == 0) return false;
    return (storeIndex[storeStructs[storeAddress].index] == storeAddress);
  }

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

  function getCrudStore(address storeAddress)
    internal
    /*public*/
    constant
    isACrudStore(storeAddress)
    returns(bytes32 storeName, uint index)
  {
    return(
      storeStructs[storeAddress].storeName,
      storeStructs[storeAddress].index);
  }

  function getCrudStoreCount()
    internal
    /*public*/
    constant
    returns(uint count)
  {
    return storeIndex.length;
  }

  function getCrudStoreAtIndex(uint index)
    internal
    /*public*/
    constant
    returns(address storeAddress)
  {
    return storeIndex[index];
  }

}
