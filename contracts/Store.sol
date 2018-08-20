pragma solidity ^0.4.24;

//import "./Marketplace.sol";
//import "./LCrud.sol";
import "./../contracts/ItemCrud.sol";
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import 'openzeppelin-solidity/contracts/payment/PullPayment.sol';

contract Store is
ItemCrud,
PullPayment
 {
    using SafeMath for uint256;
    address public owner; // store owner

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
    ItemCrud()
    PullPayment()
    {
      owner = tx.origin; // à refacto avec ownable
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


}
