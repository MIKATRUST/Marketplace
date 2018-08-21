pragma solidity ^0.4.24;

//import "./Marketplace.sol";
//import "./LCrud.sol";
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import "./../contracts/ItemCrud.sol";
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import 'openzeppelin-solidity/contracts/payment/PullPayment.sol';

contract Store is
Ownable,
ItemCrud,
PullPayment
 {
    using SafeMath for uint256;
    //address public owner; // store owner we use owne of ownable

    //Events
    //To be done

    //Modifiers
    modifier giveBackChange(uint256 _productSku, uint256 _productQuantity) {
    //refund them after pay for item (why it is before, _ checks for logic before func)
    _;
    (,,,uint productPrice,,) = getProduct(_productSku);
    msg.sender.transfer(msg.value - productPrice.mul(_productQuantity));
    }

    constructor()
    public
    Ownable()
    ItemCrud()
    PullPayment()
    {
      //super.transferOwnership(tx.origin);
      //not the marketplace but the caller to marketplace.createStore()
      //owner = tx.origin; // à refacto avec ownable
      super.transferOwnership(tx.origin);
    }

    function isAvailable()
    public
    pure
    returns (bool)
    {
      return (true);
    }

    function purchaseProduct (uint256 productSku, uint256 productPurchaseQty)
    public
    payable
//    forSale (id)
//    enoughStock (id, quantity)
//    paidEnough(id, quantity)
    giveBackChange(productSku, productPurchaseQty)
    {
      //update quantity in store
      //get quantity
      //calculate remianing > updata quantity

      (,uint productQty,,uint productPrice,,) = getProduct(productSku);

      updateProductQuantity (productSku, productQty.sub(productPurchaseQty));
      //bool ret = updateProductQuantity (productSku,uint(3));

      super.asyncTransfer(owner,(productPurchaseQty).mul(productPrice));

      //emit LogPurchaseProduct(id, quantity, (quantity.mul(products[id].price)), msg.sender);
    }

    function withdrawPayments ()
    public
    {
      super.withdrawPayments();
    }

    /**
    * @dev Returns the credit owed to an address.
    * @param _dest The creditor's address.
    */
    function payments(address _dest) public view returns (uint256) {
      return super.payments(_dest);
    }

    function addProduct(uint productSku,bytes32 productName,uint productQuantity,bytes32 productDescription,uint productPrice,bytes32 productImage)
    public
    returns(uint)
    {
      uint index= super.insertItem(productSku,productName,productQuantity,productDescription,productPrice,productImage);
      //emit LogAddProduct(store_name, id, _name);
      return(index);
    }

    function removeProduct(uint productSku)
    public
    returns(uint)
    {
      uint index=super.deleteItem(productSku);
      //emit LogRemoveProduct(store_name, id, products[id].name);
      return(index);
    }

    function getProductCount()
    public
    constant
    returns(uint count)
    {
      return super.getItemCount();
    }

    function getProduct(uint productSku)
      public
      //sku exists
      constant
      returns(bytes32 productName, uint productQuantity, bytes32 productDescription, uint productPrice, bytes32 prouctImage, uint index)
    {
      return(super.getItem(productSku));
    }

    function getProductAtIndex(uint index)
      public
      constant
      returns(uint productSku)
    {
      return (super.getItemAtIndex(index));
    }

    function updateProductPrice (uint productSku, uint productPrice)
    public
    returns(bool success)
    {
      return(super.updateItemPrice(productSku, productPrice));
    }

    function updateProductQuantity (uint productSku, uint256 productQuantity) public
    returns(bool success)
    {
      return(super.updateItemQuantity(productSku, productQuantity));
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () public {
      revert();
    }




}
