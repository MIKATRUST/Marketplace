pragma solidity ^0.4.24;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Destructible.sol';
import "./../contracts/StoreCrud.sol";
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
Destructible,
RBAC,
StoreCrud
{
  string constant MKT_ROLE_SHOPPER = 'shopper';
  string constant MKT_ROLE_ADMIN = 'marketplaceAdministrator';
  string constant MKT_ROLE_APPROVED_STORE_OWNER = 'marketplaceApprovedStoreOwner';

  uint256 nAdmin = 0; //number of operator having the role MKT_ROLE_ADMIN

  event LogNewStore(address _req, address _store); // Thie event is catched by the store
  event LogAddedRoleAdministrator(address _requester, address _operator);
  event LogDeletedRoleAdministrator(address _requester, address _operator);
  event LogAddedRoleApprovedStoreOwner(address _requester, address _operator);
  event LogDeletedRoleApprovedStoreOWner(address _requester, address _operator);

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
  StoreCrud()
  {
    //owner =...
    super.addRole(msg.sender, MKT_ROLE_ADMIN);
  }

  function createStore(bytes32 storeName)
  public
  whenNotPaused
  onlyRole(MKT_ROLE_APPROVED_STORE_OWNER)
  returns(address)
  {
    address storeAddress = new Store();
    //Stores CRUD here
    emit LogNewStore(msg.sender, storeAddress);
    //insert store in StoreCrud
    insertStore(storeAddress,storeName);
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

/* ??????
  function deleteUser (address user)
  internal
  {
    delete iterUsers[Users[user].idxIterUsers];
    delete Users[user];
    //nUsers--; No because it is used with index
  }
*/

  function getStoreCount()
    public
    constant
    whenNotPaused
    returns(uint count)
  {
    return(super.getStoreCount());
  }

  function getStoreAtIndex(uint index)
    public
    constant
    whenNotPaused
    returns(address storeAddress)
  {
    return super.getStoreAtIndex(index);
  }

  function getStore(address storeAddress)
    public
    constant
    whenNotPaused
    isAStore(storeAddress)
    returns(bytes32 storeName, uint index)
  {
    return(super.getStore(storeAddress));
  }


/*
}
  mapping (address => User) public Users;
  address [] public iterUsers;
  uint256 nUsers = 0;
    uint256 nAdmin = 0; //number of admin for the marketplace

    mapping (address => Store) public Stores;
    address [] public iterStores;
    bytes32 [] public storeNames;
    uint256 idxIterStores = 0;
    uint256 nStores = 0;

    struct User {
      RoleChoices role;
      Store [] stores;
      uint256 idxIterUsers;
      bool isValue;
    }

    struct Store {
      bytes32 name;
      uint256 idxIterStores;
      bool isValue;
    }

    enum RoleChoices { Administrator, ApprovedStoreOwner, Shopper}

    //Modifiers
    modifier isNotAContract(){
    require (
      msg.sender == tx.origin,
      "contracts are not allowed to interact.");
    _;
    }

    modifier isRegistered(address req)
    {
      require (Users[req].isValue == true,
        "non registered user is not allowed to interact.");
      _;
    }
    modifier isNotRegistered(address req)
    {
      require (
        Users[req].isValue != true,
        "registered user is not allowed to interact.");
      _;
    }
    modifier isAdministrator(address req)
    {
      require (
        //uint256(Users[req].role) == uint256(RoleChoices.Administrator)true,
      "only administrator is allowed to interact.");
      _;
    }
    modifier isNotAdministrator(address req)
    {
      require (Users[req].role != RoleChoices.Administrator,
      "administrator is not allowed to interact.");
      _;
    }
    modifier isApprovedStoreOwner(address req)
    {
      require (uint256(Users[req].role) == uint256(RoleChoices.ApprovedStoreOwner),
        "only ApprovedStoreOwner is allowed to interact.");
      _;
    }
    modifier isNotApprovedStoreOwner(address req)
    {
      require (uint256(Users[req].role) != uint256(RoleChoices.ApprovedStoreOwner),
        "approvedStoreOwner is not allowed to interact.");
      _;
    }
    modifier notForMyself(address req)
    {
      require (msg.sender != req,
        "ask somebody else to perform this action.");
      _;
    }
    modifier atLeast1Admin()
    {
      require (nAdmin > 1,
        "can not remove last Administrator.");
      _;
    }
    // Events - publicize actions to external listeners
    event LogNewMarketplace(address _req);
    event LogAdminAdded(address _req, address _user);
    event LogAdminDeleted(address _req, address _user);
    event LogApprStoreOwnerAdded(address _req, address _user );
    event LogApprStoreOWnerDeleted(address _req, address _user);
    event LogNewStoreLogic(address _req, address _store);
    event LogStoreLogicDeleted(address _req, address _store);

    event myLog (string myString, address myAddress);

    constructor()
    public
    isNotAContract()
    {
      Users[msg.sender].role = RoleChoices.Administrator;
      Users[msg.sender].idxIterUsers = nUsers;
      Users[msg.sender].isValue = true;
      iterUsers.push(msg.sender);
      nAdmin++;
      nUsers++;
      emit LogNewMarketplace(msg.sender);
      emit LogAdminAdded(msg.sender, tx.origin);
    }

    function addAdmin (address user)
    public
    isAdministrator (msg.sender)
    isNotRegistered (user)
    {
      Users[user].role = RoleChoices.Administrator;
      Users[user].idxIterUsers = nUsers;
      Users[user].isValue = true;
      iterUsers.push(user);
      nAdmin++;
      nUsers++;
      emit LogAdminAdded(user, user);
    }

    function deleteAdmin (address user)
    public
    notForMyself(user)
    isRegistered (msg.sender)
    isAdministrator (msg.sender)
    isRegistered (user)
    isAdministrator (user)
    atLeast1Admin ()
    {
      deleteUser (user);
      nAdmin--;
      //nUsers--; //we never remove, because used like index for iterUsers
      emit LogAdminDeleted(msg.sender, user);
    }

    function addAprovedStoreOwner (address user)
    isAdministrator (msg.sender)
    isNotRegistered (user)
    public
    {
      Users[user].role = RoleChoices.ApprovedStoreOwner;
      Users[user].idxIterUsers = nUsers;
      Users[user].isValue = true;
      iterUsers.push(user);
      nUsers++;
      emit LogApprStoreOwnerAdded(user, user);
    }

    function deleteApprovedStoredOwner (address user)
    isRegistered (msg.sender)
    isAdministrator (msg.sender)
    isRegistered (user)
    isApprovedStoreOwner (user)
    public
    {
      deleteUser(user);
      emit LogApprStoreOWnerDeleted(msg.sender, user);
    }

    function deleteUser (address user)
    internal
    {
      delete iterUsers[Users[user].idxIterUsers];
      delete Users[user];
      //nUsers--; No because it is used with index
    }

    function getUserRole(address user)
    public
    view
    returns (uint256)
    {
      if(Users[user].isValue == true){
        if(uint256(Users[user].role) == uint256(RoleChoices.Administrator)){
          return (uint256(RoleChoices.Administrator));
        } else {
          return (uint256(RoleChoices.ApprovedStoreOwner));
        }
      }
      else{
        return (uint256(RoleChoices.Shopper));
      }

    }

    function userExists (address user, RoleChoices role)
    public
    view
    returns(bool)
    {
      return (Users[user].isValue && (Users[user].role == role));
          //vérifier la mécanique générale dans les tests
          // Users[user].isValue
          // (iterUsers[Users[user].idxIterUsers] == user)
    }

    function getStoresNum ()
    public
    view
    returns(uint)
    {
      return (nStores);
    }

    function getStores ()
    public
    view
    returns (address [], bytes32[])
    {
      return(iterStores, storeNames);
    }

    function createStoreLogic(bytes32 name)
    public
    isNotAContract()
    isApprovedStoreOwner(msg.sender)
    returns (address)
    {
      address storeAddress = new StoreLogic(msg.sender, name);

      Stores[storeAddress].name = name;
      Stores[storeAddress].isValue = true;
      Stores[storeAddress].idxIterStores = nStores;
      iterStores.push(storeAddress);
      storeNames.push(name);
      nStores++;
      emit LogNewStoreLogic(msg.sender, storeAddress);
      return storeAddress;
    }

*/

    //TBD RAF delete store

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () public {
      revert();
    }
}

/*
mapping (address => Store) public Stores;
address [] public iterStores;
uint256 idxIterStores = 0;
uint256 nStores = 0;

Users[msg.sender].role = RoleChoices.Administrator;
Users[msg.sender].isValue = true;
iterUsers.push(msg.sender);
nAdmin++;
nUsers++;
emit LogAdminAdded(msg.sender, user);
*/
