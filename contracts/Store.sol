pragma solidity ^0.4.24;


import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import "./../contracts/CrudItem.sol";
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import '../node_modules/openzeppelin-solidity/contracts/payment/PullPayment.sol';

/**
 * @title Store
 * @dev store contract, a store is instanciated each time a store is created from the marketplace contract
 * @dev use a pull escrow to handle payment operation asynchronously instead of
 * of send or transfer.
 */
contract Store is
Ownable,
Pausable,
CrudItem,
PullPayment
 {
    using SafeMath for uint256;
    //address public owner; // store owner we use owne of ownable

    //Event
    // Events - publicize actions to external listeners
    event LogStoreCreate(address _operator);
    event LogStoreDelete(address _operator); // not used yet
    event LogStoreAddProduct(uint _sku, bytes32 _name, uint _quantity,bytes32 _description,uint _unitPrice);
    event LogStoreRemoveProduct(uint _sku);
    event LogStoreUpdatePrice(uint _sku, uint256 _unitPrice);
    event LogStoreUpdateQuantity(uint _sku, uint256 _updatedQuantity);
    event LogUpdateDescription(uint _sku, bytes32 updatedDescription);
    event LogPurchaseProduct(uint _sku, uint _quantity, uint256 _totalPrice, address _customer);
    event LogDestroyStoreAndSend(address _operator);
    event LogWithdrawPayment(address _operator, uint256 _fund);

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
    onlyOwner
    public
    {
      emit LogWithdrawPayment(msg.sender, super.payments(msg.sender));
      super.withdrawPayments();
    }

    /**
    * @dev Returns the credit owed to an address.
    * @param _dest The creditor's address.
    */
    function payments(address _dest) public view returns (uint256) {
      return super.payments(_dest);
    }

    /** @title Shape calculator. */
    //contract shapeCalculator {
        /** @dev Calculates a rectangle's surface and perimeter.
          * @param productSku Width of the rectangle.
          * @param productName Height of the rectangle.
          * @return index of produt..
          */
    function addProduct(uint productSku,bytes32 productName,uint productQuantity,bytes32 productDescription,uint productPrice,bytes32 productImage)
    public
    onlyOwner
    isNotACrudItem(productSku)
    returns(uint)
    {
      uint index= super.insertCrudItem(productSku,productName,productQuantity,productDescription,productPrice,productImage);
      emit LogStoreAddProduct(productSku,productName,productQuantity,
        productDescription,productPrice);
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

    function destroyAndSend()
    public
    onlyOwner
    {
      emit LogDestroyStoreAndSend(msg.sender);
      super.withdrawPayments();
      selfdestruct(owner);
    }

    // Fallback function, sent ether to a non referenced function of this contract should be reverted
    function () public {
        revert();
    }

}
