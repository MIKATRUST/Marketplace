pragma solidity ^0.4.24;

//import "./Marketplace.sol";
//import "./LCrud.sol";
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Destructible.sol';
import "./../contracts/CrudItem.sol";
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import '../node_modules/openzeppelin-solidity/contracts/payment/PullPayment.sol';

contract Store is
Ownable,
Pausable,
Destructible,
CrudItem,
PullPayment
 {
    using SafeMath for uint256;
    //address public owner; // store owner we use owne of ownable

    //Event
    // Events - publicize actions to external listeners
    event LogStoreCreate(address operator);
    event LogStoreDelete(address operator); // not used yet
    event LogStoreAddProduct(uint sku);
    event LogStoreRemoveProduct(uint sku);
    event LogStoreUpdatePrice(uint _sku, uint256 _updatedUnitPrice);
    event LogStoreUpdateQuantity(uint _sku, uint256 _updatedQuantity);
    event LogUpdateDescription(uint _sku, bytes32 updatedDescription);
    event LogPurchaseProduct(uint sku, uint quantity, uint256 totalPrice, address customerAddress);

    //Modifiers
    //refund them after pay for item (why it is before, _ checks for logic before func)
    modifier giveBackChange(uint256 _productSku, uint256 _productQuantity) {
    _;
    (,,,uint productPrice,,) = getProduct(_productSku);
    msg.sender.transfer(msg.value - productPrice.mul(_productQuantity));
    }

    modifier enoughStock (uint256 _productSku, uint256 _productPurchaseQty) {
    (,uint productQuantity,,,,) = getProduct(_productSku);
    require(productQuantity>=_productPurchaseQty,
    "not enought stock, revert.");
    _;
    }

    modifier paidEnough(uint256 _productSku, uint256 _productPurchaseQty){
    (,,,uint productPrice,,) = getProduct(_productSku);
    require(msg.value >= (productPrice.mul(_productPurchaseQty)),
    "not paid enought, revert.");
    _;
    }

    constructor()
    public
    Ownable()
    CrudItem()
    PullPayment()
    {
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
    enoughStock(productSku, productPurchaseQty)
    paidEnough(productSku, productPurchaseQty)
    giveBackChange(productSku, productPurchaseQty)
    {
      (uint productQty,uint productPrice) = getProductQuantityPrice(productSku);
      super.updateCrudItemQuantity(productSku, productQty.sub(productPurchaseQty));
      //updateProductQuantity(productSku, productQty.sub(productPurchaseQty));
      super.asyncTransfer(owner,(productPurchaseQty).mul(productPrice));
      //emit LogPurchaseProduct(productSku, productPurchaseQty, (productPurchaseQty).mul(productPrice), msg.sender);
    }

    function withdrawPayments ()
    onlyOwner //Only store owner
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
    onlyOwner
    isNotACrudItem(productSku)
    returns(uint)
    {
      uint index= super.insertCrudItem(productSku,productName,productQuantity,productDescription,productPrice,productImage);
      //emit LogAddProduct(store_name, id, _name);
      return(index);
    }

    function removeProduct(uint productSku)
    public
    onlyOwner
    isACrudItem(productSku)
    returns(uint)
    {
      uint index=super.deleteCrudItem(productSku);
      //emit LogRemoveProduct(store_name, id, products[id].name);
      return(index);
    }

    function getProductCount()
    public
    view
    returns(uint count)
    {
      return super.getCrudItemCount();
    }

    function getProduct(uint productSku)
      public
      isACrudItem(productSku)
      view
      returns(bytes32 productName, uint productQuantity, bytes32 productDescription, uint productPrice, bytes32 prouctImage, uint index)
    {
      return(super.getCrudItem(productSku));
    }

    function getProductQuantityPrice(uint productSku)
      public
      isACrudItem(productSku)
      view
      returns(uint productQuantity, uint productPrice)
    {
      return(super.getCrudItemQuantityPrice(productSku));
    }

    function getProductAtIndex(uint index)
      public
      view
      returns(uint productSku)
    {
      return (super.getCrudItemAtIndex(index));
    }

    function updateProductPrice (uint productSku, uint updatedUnitPrice)
    public
    onlyOwner
    isACrudItem(productSku)
    returns(bool success)
    {
      emit LogStoreUpdatePrice(productSku, updatedUnitPrice);
      return(super.updateCrudItemPrice(productSku, updatedUnitPrice));
    }

    function updateProductQuantity (uint productSku, uint256 updatedQuantity)
    public
    onlyOwner
    isACrudItem(productSku)
    returns(bool success)
    {
      emit LogStoreUpdateQuantity(productSku, updatedQuantity);
      return(super.updateCrudItemQuantity(productSku, updatedQuantity));
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
