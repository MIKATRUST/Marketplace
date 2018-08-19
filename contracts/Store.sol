pragma solidity ^0.4.24;

//Marketplace Material to look for : https://github.com/MShah890/Ethereum-MarketPlace/blob/master/Blockchain%20Backend/contracts/MarketPlace.sol
//Contract acceptin erc20 : https://programtheblockchain.com/posts/2018/02/27/writing-a-token-market-contract/
//Separate eternal storage and app logic : https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88
//Dynamic Dummy image generator : https://dummyimage.com/

import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import 'openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'openzeppelin-solidity/contracts/lifecycle/Destructible.sol';
import 'openzeppelin-solidity/contracts/payment/PullPayment.sol';
import "./StoreLogic.sol";

contract Store is
  Ownable,
  Pausable,
  Destructible,
  PullPayment,
  StoreLogic  {

  constructor (bytes32 _name, address _marketplace, string _dataset)
    public
    StoreLogic(_name, _marketplace, _dataset)
    {
    }

  function heartBeatPausable()
    //onlyOwner
    whenNotPaused //function won't be callable when the contract is in the paused state
    public
    view
    returns (uint)
      {
        return (super.heartBeat());
      }

  function heartBeatOnlyOwner()
    onlyOwner
    //whenNotPaused //function won't be callable when the contract is in the paused state
    public
    view
    returns (uint)
    {
        return (super.heartBeat());
    }

/*
  function buySth1Ether(uint256 _id)
    payable
    public
      {
      //test purpose, skipping verification
      uint256 amount = 1 ether;
      uint256 remAmount = msg.value - amount;
      asyncTransfer(owner, amount);
      msg.sender.transfer(remAmount);
      }
*/
  //function withdrawReceivedPayments ()

  function withdrawPayments()
    public
    onlyOwner
    whenNotPaused
      {
        super.withdrawPayments();
      }

  //TBD, add require no more ether in the contract
  //function destroy()

  function purchaseProduct (uint256 id, uint256 quantity)
    public
    payable
    whenNotPaused
    {
      asyncTransfer(owner, ((products[id].price).mul(quantity)));
      msg.sender.transfer(msg.value - ((products[id].price).mul(quantity)));
    }

  function removeProduct (uint256 id)
    public
    onlyOwner
    whenNotPaused
    {
      super.removeProduct (id);
    }

  function addProduct (bytes32 _name, uint256 _quantity, bytes32 _description, uint256 _price)
    public
    onlyOwner
    whenNotPaused
    returns (uint)
    {
      return (super.addProduct (_name, _quantity, _description, _price));
    }

  function updatePrice (uint256 id, uint256 _price)
    public
    onlyOwner
    whenNotPaused
    {
      super.updatePrice (id, _price);
    }

  function updateQuantity (uint256 id, uint256 _quantity)
    public
    onlyOwner
    whenNotPaused
    {
      super.updateQuantity (id, _quantity);
    }
  function updateDescription (uint256 id, bytes32 _description)
    public
    onlyOwner
    whenNotPaused
    {
      super.updateDescription (id, _description);
    }

  function productIsForSale (uint256 id)
    public
    view
    onlyOwner
    whenNotPaused
    returns (bool)
    {
      if(isForSale[id]==true)return true;
      else return false;
    }

}
