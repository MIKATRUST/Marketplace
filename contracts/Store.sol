pragma solidity ^0.4.24;


import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import "./../contracts/CrudItem.sol";
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import '../node_modules/openzeppelin-solidity/contracts/payment/PullPayment.sol';

/**
 * @title Store
 * @dev store contract, a new store is instanciated each time a store is
 * created from the marketplace contract
 * @dev the store use a pull escrow to handle payment operation asynchronously * instead of using send or transfer.
 * @dev Store is owned by the creator of the store. Store ownership can be
 * transferred. Before ownership change, store owner must withdrawPayments.
 * @dev Store is pausable.
 * @dev Store is destroyable.
 * @dev refacto needed, expose publicly less public method, make more method
 * as internal.
 */
contract Store is
Ownable,
Pausable,
CrudItem,
PullPayment
 {
  using SafeMath for uint256;

  /**
  * Events - publicize actions to external listeners
  */
  event LogStoreCreate(address _operator);
  event LogStoreDelete(address _operator);
  event LogStoreAddProduct(uint _sku, bytes32 _name, uint _quantity,bytes32 _description,uint _unitPrice);
  event LogStoreRemoveProduct(uint _sku);
  event LogStoreUpdatePrice(uint _sku, uint256 _unitPrice);
  event LogStoreUpdateQuantity(uint _sku, uint256 _updatedQuantity);
  event LogUpdateDescription(uint _sku, bytes32 updatedDescription);
  event LogPurchaseProduct(uint _sku, uint _quantity, uint256 _totalPrice, address _customer);
  event LogDestroyStoreAndSend(address _operator);
  event LogWithdrawPayment(address _operator, uint256 _fund);

  /**
   * @dev Revert if payment is not enough to purchase.
   */
  modifier paidEnough(uint256 _productSku, uint256 _productPurchaseQty){
  (,,,uint productPrice,,) = getProduct(_productSku);
  require(msg.value >= (productPrice.mul(_productPurchaseQty)),
  "not paid enought, revert.");
  _;
  }

  /**
   * @dev Revert if purchase quantity is superior to quantity avilable in
   * the store.
   */
  modifier enoughStock (uint256 _productSku, uint256 _productPurchaseQty) {
  (,uint productQuantity,,,,) = getProduct(_productSku);
  require(productQuantity>=_productPurchaseQty,
  "not enought stock, revert.");
  _;
  }

  /**
   * @dev Give back change the customer at the end of the purchase operationRevert.
   */
  modifier giveBackChange(uint256 _productSku, uint256 _productQuantity) {
  _;
  (,,,uint productPrice,,) = getProduct(_productSku);
  msg.sender.transfer(msg.value - productPrice.mul(_productQuantity));
  }

  /**
   * @dev Constructor
   */
  constructor()
  public
  Ownable()
  CrudItem()
  PullPayment()
  {
    super.transferOwnership(tx.origin);
  }

  /**
  * @dev Returns true if the store is available
  */
  function isAvailable()
  public
  pure
  returns (bool)
  {
    return (true);
  }

  /**
  * @dev Purchase a product from the store .
  * @param productSku of the products.
  * @param productPurchaseQty the quantity that will be purchased.
  */
  function purchaseProduct (uint256 productSku, uint256 productPurchaseQty)
  public
  payable
  enoughStock(productSku, productPurchaseQty)
  paidEnough(productSku, productPurchaseQty)
  giveBackChange(productSku, productPurchaseQty)
  {
    (uint productQty,uint productPrice) = getProductQuantityPrice(productSku);
    super.updateCrudItemQuantity(productSku, productQty.sub(productPurchaseQty));
    super.asyncTransfer(owner,(productPurchaseQty).mul(productPrice));
    //emit LogPurchaseProduct(productSku, productPurchaseQty, (productPurchaseQty).mul(productPrice), msg.sender);
  }
  /**
  * @dev The store owner can withdraw payments made to the store.
  * @dev Based on a store escrow and pull payment.
  */
  function withdrawPayments ()
  onlyOwner
  public{
    emit LogWithdrawPayment(msg.sender, super.payments(msg.sender));
    super.withdrawPayments();
  }

  /**
  * @dev Returns the credit owed to the an address in the store escrow.
  * @param _dest The creditor's address.
  */
  function payments(address _dest)
  public
  view
  returns (uint256) {
    return super.payments(_dest);
  }

  /**
  * @dev Add a product to the store.
  * @dev Returns the index of the product.
  * @param productSku The SKU of the product.
  * @param productName The name of the product.
  * @param productQuantity The available quantity of the product.
  * @param productDescription The description of teh product.
  * @param productPrice The UNIT price of the product.
  * @param productImage The image link of the product.
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

  /**
  * @dev Remove a product from to the store.
  * @dev Returns the index of the product.
  * @param productSku The SKU of the product.
  */
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

  /**
  * @dev Get the product SKU count in the store.
  * @dev Returns number of SKU in the store.
  */
  function getProductCount()
  public
  view
  returns(uint count)
  {
    return super.getCrudItemCount();
  }

  /**
  * @dev get product information for a given product SKU in the store.
  * @dev Returns productName The name of the product.
  * @dev Returns productQuantity The available quantity of the product.
  * @dev Returns productDescription The description of teh product.
  * @dev Returns productPrice The UNIT price of the product.
  * @dev Returns productImage The image link of the product.
  * @param productSku The SKU of the product.
  */
  function getProduct(uint productSku)
    public
    isACrudItem(productSku)
    view
    returns(bytes32 productName, uint productQuantity, bytes32 productDescription, uint productPrice, bytes32 productImage, uint index)
  {
    return(super.getCrudItem(productSku));
  }

  /**
  * @dev get all product of the store.
  * @dev Returns productSkus[] The Skus of the products.
  * @dev Returns productName[] The names of the products.
  * @dev Returns productQuantity[] The available quantities of the products.
  * @dev Returns productDescription[] The descriptions of the products.
  * @dev Returns productPrice[] The UNIT prices of the products.
  * @dev Returns productImage[] The image links of the products.
  * @dev Could be potentially used for DOS, ag create a large number of article
  * there is a need to add pagination.
  * @dev TO refacto

  function getProducts()
    public
    view
    returns(uint [], bytes32 [], uint [], bytes32 [], uint [],bytes32 [])
    {
    uint productCount = getProductCount();
    uint [] memory productSkus = new uint[](productCount);
    bytes32 [] memory productNames = new bytes32[](productCount);
    uint [] memory productQuantities = new uint[](productCount);
    bytes32 [] memory productDescriptions = new bytes32[](productCount);
    uint [] memory productPrices = new uint[](productCount);
    bytes32 [] memory productImages = new bytes32[](productCount);


    for (uint i = 0; i < productCount; i++) {
      uint productSku = getProductAtIndex(i);

      (bytes32 productName, uint productQuantity, bytes32 productDescription, uint productPrice, bytes32 productImage, uint index) = getProduct(productSku);

      productSkus[i] = productSku;
      productNames[i] = productName;
      productQuantities[i] = productQuantity;
      productDescriptions[i] = productDescription;
      productPrices[i] = productPrice;
      productImages[i] = productImage;
    }
    return(productSkus, productNames, productQuantities, productDescriptions, productPrices, productImages);
  }
  */

  /**
  * @dev Get the product Unit price and quantity for a given product SKU
  * in the store.
  * @dev Returns productQuantity The available quantity of the given SKU.
  * @dev Returns productPrice The UNIT price of the product.
  * @param productSku The SKU of the product.
  */
  function getProductQuantityPrice(uint productSku)
    public
    isACrudItem(productSku)
    view
    returns(uint productQuantity, uint productPrice)
  {
    return(super.getCrudItemQuantityPrice(productSku));
  }

  /**
  * @dev Get the  product sku of a product stored at a given index of the
  * accessor.
  * @dev Returns productSku The SKU of the product.
  * @param index The index of the sku product in the accessor.
  */
  function getProductAtIndex(uint index)
    public
    view
    returns(uint productSku)
    {
    return (super.getCrudItemAtIndex(index));
  }

  /**
  * @dev Update the UNIT price of a pruduct SKU
  * @dev Returns success of updating product price operation
  * @param productSku The index of the sku product in the accessor.
  * @param updatedUnitPrice The new UNIT price of the SKU.
  */
  function updateProductPrice (uint productSku, uint updatedUnitPrice)
  public
  onlyOwner
  isACrudItem(productSku)
  returns(bool success)
  {
    emit LogStoreUpdatePrice(productSku, updatedUnitPrice);
    return(super.updateCrudItemPrice(productSku, updatedUnitPrice));
  }

  /**
  * @dev Update the product quantity in the stor for a given product SKU.
  * @dev Returns success of updating product price operation
  * @param productSku The index of the sku product in the accessor.
  * @param updatedQuantity The updated quantity of the product sku.
  */
  function updateProductQuantity (uint productSku, uint256 updatedQuantity)
  public
  onlyOwner
  isACrudItem(productSku)
  returns(bool success)
  {
    emit LogStoreUpdateQuantity(productSku, updatedQuantity);
    return(super.updateCrudItemQuantity(productSku, updatedQuantity));
  }

  /**
  * @dev Destroy the store and send the amount stored in the escrow to the
  * owner of the store.
  */
  function destroyAndSend()
  public
  onlyOwner
  {
    emit LogDestroyStoreAndSend(msg.sender);
    super.withdrawPayments();
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
