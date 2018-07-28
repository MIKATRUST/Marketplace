pragma solidity ^0.4.24;
contract Marketplace {

    /* Let's make sure everyone knows who owns the Markeplace. */
    address public owner;

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => Storefront) public storesfronts;
    //mapping (address => Storefront[]) internal storesfronts;
    address [] public iteratorStorefront;

    /*Store index*/
    uint256 StoreNumber;

    /* Storefront is a struct */
    //!! TBD shop address = msg.sender. owner = tx.origin

    struct Storefront {
      address owner;
      address storeAddress;
      string name;
      StoreState state;

    }

    enum StoreState {
      Received,
      Open,
      Rejected,
      Suspended,
      Removed
    }

    //Add modifier
    modifier verifyIsNotRegistered () { require (storesfronts[msg.sender].storeAddress==0);_;}
    modifier verifyStorefrontExists () { require (storesfronts[msg.sender].storeAddress!=0);_;}
    //Add event Log

    // Constructor, can receive one or many variables here; only one allowed
    constructor () public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
        StoreNumber = 0;
    }

    //Public
    function registerStorefront(string _name)
        verifyIsNotRegistered()
        public returns (bool successful){
      Storefront memory newStore;
      newStore.owner = tx.origin;
      newStore.storeAddress = msg.sender;
      newStore.name = _name;
      newStore.state = StoreState.Received;
      iteratorStorefront.push(msg.sender); // ! array
      storesfronts[msg.sender] = newStore;
      StoreNumber++;
      successful = true;

    }

    //TBD : Only store owner
    function unregisterStorefront () public returns (bool successful){
      changeStorefrontState(msg.sender, StoreState.Removed);
      return true;
    }

    //TBD : public
    function queryStorefrontState () public view returns (StoreState){
      return (storesfronts[msg.sender].state );
    }

    // TBD : Public
    function queryStorefrontState (address storefrontAddress) public view returns (StoreState){
      return (storesfronts[storefrontAddress].state);
    }

    //TBD public
    function queryNumberOfStoreWithState (StoreState expectedState) public view returns (uint256 n){
      uint256 iStoreToEvaluate;
      uint256 nStoreWithState = 0;
      for(iStoreToEvaluate=0;iStoreToEvaluate<iteratorStorefront.length;iStoreToEvaluate++){
        if(storesfronts[iteratorStorefront[iStoreToEvaluate]].state == expectedState) {
          nStoreWithState++;
        }
      }
      return (nStoreWithState);
    }

    function queryStorefront ()
        verifyStorefrontExists ()
        public returns (address, address, string, StoreState){
          return(storesfronts[msg.sender].owner,
            storesfronts[msg.sender].storeAddress,
            storesfronts[msg.sender].name,
            storesfronts[msg.sender].state);
    }

    //only marketplace owner
    function changeStorefrontState(address storefrontAddress, StoreState nextState) public returns (bool successful) {
        if(storesfronts[storefrontAddress].owner!=0){
            storesfronts[storefrontAddress].state = nextState;
            return successful = true;
        }else{
            return successful = false;
        }

    }
}
