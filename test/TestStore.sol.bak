pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
//import "./../contracts/StoreLogic.sol";
import "./../contracts/Store.sol";

contract TestStore {

  //uint public initialBalance = 1 ether;
  Store store = Store(DeployedAddresses.Store());

  function testLolSub() public {
    Assert.equal(store.useSub(), uint(5), "useSub returned value is not 5.");
  }

 }
