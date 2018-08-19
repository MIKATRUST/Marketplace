pragma solidity ^0.4.24;

contract MarketplaceLogic {

    /* Let's make sure everyone knows who owns the Markeplace. */
    address public owner;

    /* Who ami ? */

    //For futur use
    //mapping (address => bool) marketplaceAdmin;
    //mapping (address => bool) storeOwners;
    //mapping (address => bool) storeVisitors;

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/

    mapping (address => Store) public stores;

    //Mapping/iterator of applicant stores
    mapping (address => bool) public applicantStores;

    //deprecated
    //address [] public iterApplicantStore;
    //address [] public applicantStores;
    //address [] public acceptedStores;
    //address [] public rejectedStore;
    //address [] public suspendedStore;
    //address [] public removedStore;

    //mapping (address => Storefront[]) internal storesfronts;
    address [] public iteratorStorefront;

    /*Store index*/
    uint256 StoreNumber;

    /* business compliance */
    uint256 public percentageMin = 7;
    uint256 public percentageMax = 12;

    /* Storefront is a struct */
    struct Store {
      address owner; //store soner = tx.origin
      address location;
      bytes32 name;
      State state;
      bool isValue;
    }

    enum State {
      ApplicationReceived,
      ApplicationAccepted,
      ApplicationRejected,
      StoreSuspended,
      StoreRemoved
    }

    /*Event*/
      event LogApplicationReceived(address _sid);
      event LogApplicationAccepted(address _sid);
      event LogApplicationRejected(address _sid);
      event LogStoreSuspended(address _sid);
      event LogStoreRemoved(address _sid);
      event myLog (string myString, address myAddress);

    /* Modifiers */

    modifier doesNotExist(address sid)
    {
      require (
        bool(stores[sid].isValue) == bool(false),
        "store is already registed in the marketplace, store exists."
      );
      _;
    }

    modifier doesExist(address sid)
    {
      require (
        bool(stores[sid].isValue) == bool(true),
        "store is not registed in the marketplace, store does not exist."
      );
      _;
    }

    modifier isNotAContract(){
    require (
      msg.sender == tx.origin, "contracts are not allowed to interact.");
    _;
    }

    modifier isAContract(){
    require (
      msg.sender != tx.origin, "contracts are not allowed to interact.");
    _;
    }

    modifier applicationReceived(address _sid)
    {
        require(
          uint(stores[_sid].state) == uint(State.ApplicationReceived),
          "store state is not ApplicationReceive."
        );
        _;
    }

    modifier applicationAccepted(address _sid)
    {
        require(
          uint(stores[_sid].state) == uint(State.ApplicationAccepted),
          "store state is not ApplicationAccepted."
        );
        _;
    }

    modifier applicationRejected(address _sid)
    {
        require(
          uint(stores[_sid].state) == uint(State.ApplicationRejected),
          "store state is not ApplicationRejected."
        );
        _;
    }

    modifier storeSuspended(address _sid)
    {
        require(
          uint(stores[_sid].state) == uint(State.StoreSuspended),
          "store state is not StoreSuspended."
        );
        _;
    }

    modifier storeRemoved(address _sid)
    {
        require(
          uint(stores[_sid].state) == uint(State.StoreRemoved),
          "store state is not StoreSuspended."
        );
        _;
    }

    //Add event Log
    //To be done

    constructor () public {
        /* Set the owner to the creator of this contract */
        //owner = msg.sender;
        StoreNumber = 0;
    }

    function whoAmI()
      public
      returns (uint)
    {
      //Admin .
      //StoreOwner ?
      //Visitor
    }

    function applyToMarketplace(bytes32 storeName)
      public
      //isAContract
      isNotAContract()
      doesNotExist(msg.sender)
      returns (uint256)
    {
      //Function to be called by the constructor of the store

      emit myLog ("*tx.origin = ", tx.origin);
      emit myLog ("*msg.sender = ", msg.sender);
      //Fill the store information
      Store memory store;
      store.owner = tx.origin;
      store.location = msg.sender;
      store.name = storeName;
      store.state = State.ApplicationReceived;
      store.isValue = true;
      stores[msg.sender] = store;
      //fill applicantStore
      //applicantStore[msg.sender] = true;
      //iterApplicantStore.push(msg.sender);
      emit LogApplicationReceived(msg.sender);
        //deprecated
        //applicantStores.push(msg.sender);
      return(uint(1));
    }
/*
    function getApplicantStores()
      public
      //onlyOwner
      returns (address[])
    {
      //itérer sur stores
      //build applicantStores
      //return applicantStores; // ie : store with state == ApplicationReceived
    }
*/
    function acceptApplicantStore(address sid)
      public

      //doesExist(sid)
      applicationReceived(sid)
      // TBD
      //onlyMArketplaceOwner
    {
      stores[sid].state = State.ApplicationAccepted;
      emit LogApplicationAccepted(sid);
    }

    function rejectApplicantStore(address sid)
      public
      //doesExist(sid)
      applicationReceived(sid)
      //only Marketplace Owner
    {
      stores[sid].state = State.ApplicationRejected;
      emit LogApplicationRejected(sid);
    }

    function suspendStore(address sid)
      public
      //doesExist(sid)
      applicationAccepted(sid)
      //only Marketplace Owner
    {
      stores[sid].state = State.StoreSuspended;
      emit LogStoreSuspended(sid);
    }

    function removeStore(address sid)
      public
      //doesExist(sid)
      applicationAccepted(sid)
      //only store owner
    {
      stores[sid].state = State.StoreRemoved;
      emit LogStoreRemoved(sid);
    }

    function getAcceptedStores()
      public
      //returns array address
      //returns (address[])
    {
      //for, cosntruct array, return it
    }

    function getState(address sid)
      public
      returns (uint256)
    {
      return(uint256(stores[sid].state));
    }
}
