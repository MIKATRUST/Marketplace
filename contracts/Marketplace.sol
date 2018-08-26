pragma solidity ^0.4.24;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import "./../contracts/CrudStore.sol";
import "./Store.sol";
import '../node_modules/openzeppelin-solidity/contracts/access/rbac/RBAC.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Destructible.sol';

/**
 * @title Marketplace
 * @dev The marketplace is managed by a group of administrator.
 * The creator of the marketplace is a de-facto administrator.
 * Administrator can add and remove the role of
 * administrator for a given address. Administrator can add and remove the role
 * of approved store owner. An approved store owner can create stores.
 * @dev Marketplace is owned by the creator of the marketplace.
 * Marketplace ownership can be transferred.
 * @dev Store is pausable.
 * @dev Store is destroyable.
 * @dev To be considered for the next release : -get some revenue sharing from
 * child stores. -Add store deletion.
 */
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

  //temporary variables, dynamic arrays, to refacto with CRUD user
  address[] marketplaceAdministrators;
  address[] approvedStoreOwners;

  /**
  * Events - publicize actions to external listeners
  */
  event LogNewMarketplace(address _requester, bytes32 _name);
  event LogNewStore(address _req, address _store); // do not change emitted variable name, important for js testing
  event LogAddedRoleAdministrator(address _requester, address _operator);
  event LogDeletedRoleAdministrator(address _requester, address _operator);
  event LogAddedRoleApprovedStoreOwner(address _requester, address _operator);
  event LogDeletedRoleApprovedStoreOWner(address _requester, address _operator);
  event LogDestroyMarketplace(address _requester);

  /**
   * @dev Revert if tentative to remove the last administrator.
   */
  modifier atLeast2Admin()
  {
    require (nAdmin > 2,
      "can not remove last Administrator.");
    _;
  }

  /**
   * @dev Constructor
   */
  constructor()
  public
  Ownable()
  CrudStore()
  {
    super.addRole(msg.sender, MKT_ROLE_ADMIN);
  }

  /**
  * @dev Create a store. Store creation is restricted to user having the
  * role MKT_ROLE_APPROVED_STORE_OWNER
  * @dev The creator of the store should not be a contract, otherwise it will
  * be reverted.
  * @dev returns the address of the created store.
  * @param storeName is the name of teh store.
  */
  function createStore(bytes32 storeName)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_APPROVED_STORE_OWNER)
  returns(address)
  {
    require(msg.sender==tx.origin, "caller should not be a contract");
    address storeAddress = new Store();
    emit LogNewStore(msg.sender,storeAddress);
    insertCrudStore(storeAddress,storeName);
    return storeAddress;
  }

  /**
  * @dev Add role MKT_ROLE_ADMIN to a given operator. Use of this transaction
  * is restricted to user having the role MKT_ROLE_ADMIN.
  * @param operator is the address of the operator you are going to give the
  * role MKT_ROLE_ADMIN.
  */
  function addRoleAdministrator (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  {
    super.addRole(operator, MKT_ROLE_ADMIN);
    marketplaceAdministrators.push(operator);
    nAdmin++;
    emit LogAddedRoleAdministrator(msg.sender, operator);
  }

  /**
  * @dev Remove role MKT_ROLE_ADMIN to a given operator. Use of this transaction
  * is restricted to user having the role MKT_ROLE_ADMIN.
  * @param operator is the address of the operator you are going to remove the
  * role MKT_ROLE_ADMIN.
  */
  function removeRoleAdministrator (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  //notForMyself(user)
  //atLeast1Admin ()
  {
    super.removeRole(operator, MKT_ROLE_ADMIN);
    nAdmin--;
    //TBD : update CRUD user
    emit LogDeletedRoleAdministrator(msg.sender, operator);
  }

  /**
  * @dev Add role MKT_ROLE_APPROVED_STORE_OWNER to a given operator.
  * Use of this transaction is restricted to user having the role
  * MKT_ROLE_ADMIN.
  * @param operator is the address of the operator you are going to give the
  * role MKT_ROLE_APPROVED_STORE_OWNER.
  */
  function addRoleApprovedStoreOwner (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  {
    super.addRole(operator, MKT_ROLE_APPROVED_STORE_OWNER);
    approvedStoreOwners.push(operator);
    emit LogAddedRoleApprovedStoreOwner(msg.sender, operator);
  }


  /**
  * @dev Remove role MKT_ROLE_APPROVED_STORE_OWNER to a given operator.
  * Use of this transaction is restricted to user having the role
  * MKT_ROLE_ADMIN.
  * @param operator is the address of the operator you are going to remove the
  * role MKT_ROLE_ADMIN.
  */
  function removeRoleApprovedStoredOwner (address operator)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_ADMIN)
  {
    super.removeRole(operator, MKT_ROLE_APPROVED_STORE_OWNER);
    //TBD : update CRUD user
    emit LogDeletedRoleApprovedStoreOWner(msg.sender, operator);
  }

  /**
  * @dev Check if an operator has a given role.
  * @dev Returns true if the operator has effectively the given role.
  * @param operator is the address of the operator.
  * @param role is the role you want to check.
  */
  function hasRole(address operator, string role)
  public
  view
  whenNotPaused
  returns(bool)
  {
    return(super.hasRole(operator, role));
  }

  /**
  * @dev get primary role for an operator.
  * @dev Returns the primary roles.
  * @param operator is the address of the operator.
  */
  function getPrimaryRole(address operator)
  public
  view
  whenNotPaused
  returns(string)
  {
    if(hasRole(operator,MKT_ROLE_ADMIN))
      return MKT_ROLE_ADMIN;
    if(hasRole(operator,MKT_ROLE_APPROVED_STORE_OWNER))
      return MKT_ROLE_APPROVED_STORE_OWNER;
    return MKT_ROLE_SHOPPER;
  }

  /**
  * @dev Get the number of stores referenced the marketplace.
  * @dev Returns the number of stores referenced in the marketplace.
  */
  function getStoreCount()
    public
    constant
    whenNotPaused
    returns(uint count)
  {
    return(super.getCrudStoreCount());
  }

  /**
  * @dev Get the address of a store stored at a fiven index of Crud Store.
  * @dev Low level function, will be remove in futur release.
  * @param index of the store.
  */
  function getStoreAtIndex(uint index)
    public
    constant
    whenNotPaused
    returns(address storeAddress)
  {
    return super.getCrudStoreAtIndex(index);
  }

  /**
  * @dev Retrieve store information.
  * @dev Low level function, will be remove in futur release.
  * @param storeAddress is the address of teh stored.
  * @dev Returns storeName The name of the store.
  * @dev Returns index The index of the stors in Crud store.
  */
  function getStore(address storeAddress)
    public
    constant
    whenNotPaused
    isACrudStore(storeAddress)
    returns(bytes32 storeName, uint index)
  {
    return(super.getCrudStore(storeAddress));
  }

  /**
  * @dev Get addresses of the store referenced in the marketplace.
  * @dev Returns an array of addresses of the stores.
  * @dev Temporary function to accelerate, not indexed
  */
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

  /**
  * @dev Get addresses of the administrators of the marketplace.
  * @dev Returns an array of addresses of the administrators.
  * @dev Temporary function to accelerate dev onf front end, not indexed
  * @dev Refacto needed, create a CRUD user
  */
  function getMarketplaceAdministrators()
    public
    constant
    whenNotPaused
    returns(address[])
  {
    uint length = marketplaceAdministrators.length;
    address[] memory stores = new address[](length);
    for (uint i = 0; i < length; i++) {
        stores[i]=marketplaceAdministrators[i];
    }
    return marketplaceAdministrators;
  }

  /**
  * @dev Get addresses of the approved store owners.
  * @dev Returns an array of addresses of the approved store owners.
  * @dev Temporary function to accelerate dev of front end, not indexed
  * @dev Refacto needed, create a CRUD user
  */
  function getApprovedStoreOwners()
    public
    constant
    whenNotPaused
    returns(address[])
  {
    uint length = approvedStoreOwners.length;
    address[] memory stores = new address[](length);
    for (uint i = 0; i < length; i++) {
        stores[i]=approvedStoreOwners[i];
    }
    return marketplaceAdministrators;
  }

  /**
  * @dev Destroy the marketplace. Operation can only be performed bu the owner
  * of the marketplace.
  */
  function destroy()
  public
  onlyOwner
  {
    emit LogDestroyMarketplace(msg.sender);
    selfdestruct(owner);
  }

  /**
  * @dev Fallback function, sending ether to a non referenced function
  * of this contract will be reverted .
  */
  function () public {
      revert();
  }
}
