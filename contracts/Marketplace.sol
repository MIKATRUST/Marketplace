pragma solidity ^0.4.24;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import "./../contracts/CrudStore.sol";
import "./Store.sol";
import '../node_modules/openzeppelin-solidity/contracts/access/rbac/RBAC.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Destructible.sol';
//import 'openzeppelin-solidity/contracts/payment/PullPayment.sol';

//UserCrud
contract Marketplace is
Ownable,
Pausable,
RBAC,
CrudStore
{
  string constant MKT_ROLE_SHOPPER = 'shopper';
  string constant MKT_ROLE_ADMIN = 'marketplaceAdministrator';
  string constant MKT_ROLE_APPROVED_STORE_OWNER = 'marketplaceApprovedStoreOwner';

  uint256 nAdmin = 0; //number of operator having the role MKT_ROLE_ADMIN
  event LogNewMarketplace(address _requester, bytes32 _name);
  event LogNewStore(address _req, address _store); // do not change emitted variable name, important for js testing
  event LogAddedRoleAdministrator(address _requester, address _operator);
  event LogDeletedRoleAdministrator(address _requester, address _operator);
  event LogAddedRoleApprovedStoreOwner(address _requester, address _operator);
  event LogDeletedRoleApprovedStoreOWner(address _requester, address _operator);
  event LogDestroyMarketplace(address _requester);

/*
  modifier atLeast2Admin()
  {
    require (nAdmin > 2,
      "can not remove last Administrator.");
    _;
  }
*/
  constructor()
  public

  Ownable()
  CrudStore()
  {
    super.addRole(msg.sender, MKT_ROLE_ADMIN);
  }

  function createStore(bytes32 storeName)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_APPROVED_STORE_OWNER)
  returns(address)
  {
    address storeAddress = new Store();
    emit LogNewStore(msg.sender,storeAddress);
    insertCrudStore(storeAddress,storeName);
    return storeAddress;
  }

  function addRoleAdministrator (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  {
    super.addRole(operator, MKT_ROLE_ADMIN);
    nAdmin++;
    emit LogAddedRoleAdministrator(msg.sender, operator);
  }

  function removeRoleAdministrator (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  //notForMyself(user)
  //atLeast1Admin ()
  {
    super.removeRole(operator, MKT_ROLE_ADMIN);
    nAdmin--;
    emit LogDeletedRoleAdministrator(msg.sender, operator);
  }

  function addRoleApprovedStoreOwner (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  {
    super.addRole(operator, MKT_ROLE_APPROVED_STORE_OWNER);
    emit LogAddedRoleApprovedStoreOwner(msg.sender, operator);
  }

  function removeRoleApprovedStoredOwner (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  {
    super.removeRole(operator, MKT_ROLE_APPROVED_STORE_OWNER);
    emit LogDeletedRoleApprovedStoreOWner(msg.sender, operator);
  }

  function hasRole(address operator, string role)
  public
  view
  whenNotPaused
  returns(bool)
  {
    return(super.hasRole(operator, role));
  }

  function getStoreCount()
    public
    constant
    whenNotPaused
    returns(uint count)
  {
    return(super.getCrudStoreCount());
  }

  function getStoreAtIndex(uint index)
    public
    constant
    whenNotPaused
    returns(address storeAddress)
  {
    return super.getCrudStoreAtIndex(index);
  }

  function getStore(address storeAddress)
    public
    constant
    whenNotPaused
    isACrudStore(storeAddress)
    returns(bytes32 storeName, uint index)
  {
    return(super.getCrudStore(storeAddress));
  }

  //Temporary function to accelerate, not indexed
  function getStores()
    public
    constant
    whenNotPaused
    returns(address[])
  {
    uint length = getStoreCount();
    address[] memory stores = new address[](length);
    for (uint i = 0; i < length; i++) {
        stores[i]=getStoreAtIndex(i);
    }
    return stores;
  }

  //V2 TBD
  //-delete store
  //-get some revenue sharing from the stores

  function destroy()
  public
  onlyOwner
  {
    emit LogDestroyMarketplace(msg.sender);
    selfdestruct(owner);
  }

  // Fallback function, sent ether to a non referenced function of this contract should be reverted
  function () public {
      revert();
  }
}
