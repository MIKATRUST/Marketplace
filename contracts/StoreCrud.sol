pragma solidity ^0.4.24;

/* Special thanks to Rob Hitchens https://medium.com/@robhitchens/solidity-crud-part-1-824ffa69509a
*/

contract StoreCrud {

  struct StoreStruct {
    bytes32 storeName;
    address storeAddress;
    uint index;
  }

  mapping(address => StoreStruct) private storeStructs;
  address[] private storeIndex;

  event LogNewStore   (address indexed storeAddress, uint index, bytes32 storeName);
  event LogUpdateStore(address indexed storeAddress, uint index, bytes32 storeName);
  event LogDeleteStore(address indexed storeAddress, uint index);

  modifier isAStore (address _storeAddress)
  {
      require (isStore(_storeAddress) == true,
        "this is not a store."
      );
      _;
  }

  modifier isNotAStore (address _storeAddress)
  {
      require (isStore(_storeAddress) == false,
        "this is a store."
      );
      _;
  }

  function isStore(address storeAddress)
    public
    constant
    returns(bool isIndeed)
  {
    if(storeIndex.length == 0) return false;
    return (storeIndex[storeStructs[storeAddress].index] == storeAddress);
  }

  function insertStore(
    address storeAddress,
    bytes32 storeName)
    public
    isNotAStore(storeAddress)
    returns(uint index)
  {
    storeStructs[storeAddress].storeName = storeName;
    storeStructs[storeAddress].index     = storeIndex.push(storeAddress)-1;
    emit LogNewStore(
        storeAddress,
        storeStructs[storeAddress].index,
        storeName);
    return storeIndex.length-1;
  }

  function deleteStore(address storeAddress)
    public
    isAStore(storeAddress)
    returns(uint index)
  {
    uint rowToDelete = storeStructs[storeAddress].index;
    address keyToMove = storeIndex[storeIndex.length-1];
    storeIndex[rowToDelete] = keyToMove;
    storeStructs[keyToMove].index = rowToDelete;
    storeIndex.length--;
    emit LogDeleteStore(
        storeAddress,
        rowToDelete);
    emit LogUpdateStore(
        keyToMove,
        rowToDelete,
        storeStructs[keyToMove].storeName);
    return rowToDelete;
  }

  function getStore(address storeAddress)
    public
    constant
    isAStore(storeAddress)
    returns(bytes32 storeName, uint index)
  {
    return(
      storeStructs[storeAddress].storeName,
      storeStructs[storeAddress].index);
  }

  function getStoreCount()
    public
    constant
    returns(uint count)
  {
    return storeIndex.length;
  }

  function getStoreAtIndex(uint index)
    public
    constant
    returns(address storeAddress)
  {
    return storeIndex[index];
  }

}
