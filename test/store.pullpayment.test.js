
const Marketplace = artifacts.require("Marketplace");
const Store = artifacts.require("Store");
const BigNumber = web3.BigNumber;

// !!! You need to install chai locally (on your node_modules directory),
// so that require can find it. To do so, type:
// type
//"npm install --save-dev chai" in the local directory
//"npm install --save-dev chai-bignumber" in the local directory

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();


contract('Store Pull Payment js tests', async (accounts) => {

  const MKT_ROLE_SHOPPER = 'shopper';
  const MKT_ROLE_ADMIN = 'marketplaceAdministrator';
  const MKT_ROLE_APPROVED_STORE_OWNER = 'marketplaceApprovedStoreOwner';

  const marketplaceOwner = accounts[0];
  const storeOwner = accounts[1];
  const alice = accounts[2];
//  const bob = accounts[3];
//  const alix = accounts[4];

  const amount0 = web3.toWei(0.0, 'ether');
  const amount05 = web3.toWei(0.5, 'ether');
  const amount1 = web3.toWei(1.0, 'ether');
  const amount2 = web3.toWei(2.0, 'ether');
  const amount3 = web3.toWei(3.0, 'ether');
  const amount5 = web3.toWei(5.0, 'ether');
  const amount10 = web3.toWei(10.0, 'ether');

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  //let initialAmountAlice = await web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]))

  let marketplace;
  let store;
  beforeEach('setup contract for each test, marketplaceOwner approve 1 store owner, store owner create 1 store and 1 product.', async function () {
    //get marketplace instance
    marketplace = await Marketplace.new({from : marketplaceOwner});
    //addRoleApprovedStoreOwner to storeOwner, verify
    await marketplace.addRoleApprovedStoreOwner(storeOwner,{from:marketplaceOwner});
    assert.equal(await marketplace.hasRole(storeOwner,MKT_ROLE_APPROVED_STORE_OWNER),true,"approvedStoreOwner should not have the role ApprovedStoreOwner.")
    //event should be emitted when a store is addressCreatedStore
    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
        addressCreatedStore = res.args._store.toString(16)
        eventEmitted = true
    })
    //Create store, verify that LogNewStore was emitted
    let storeName = "default store name";
    let transactionReceipt = await marketplace.createStore(storeName,{from : storeOwner});
    assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event')
    //Verify that store is avaiable
    store = await Store.at(addressCreatedStore);
    assert.equal(await store.isAvailable(),true,"store should be available");
    //let's add product in the store
    await store.addProduct(111111,"Yellow Bike",10,"A nice Yellow Bike", amount1,"images/BIKE1.jpeg",{from: storeOwner });
    assert.equal(await store.getProductCount(), 1, "store should have 1 product");
  })

/*
  it("marketplaceOwner approve 1 store owner, store owner create 1 store.", async () => {
    let instanceMarketplace = await Marketplace.deployed({from : marketplaceOwner});
    await instanceMarketplace.addAprovedStoreOwner (storeOwner,{from:marketplaceOwner});
    const result1 = await instanceMarketplace.createStore("Cars",{from : storeOwner});
    //if needed, have a look at the results of teh transactionwe
    //console.log(result.tx); console.log(result.logs);console.log(result.receipt);
    //TBD : check also event name
    const adrStore = result1.logs[0].args._store; //console.log("address of the new store : "+adrStore);
    var instanceStore = await Store.at(adrStore);
    assert.equal(await instanceMarketplace.getStoresNum(), 1, "marketplace should have 1 stores");
    assert.equal(await instanceStore.dummy(), 42, "should get the magic number from an instanciated store, otherwise store was not created. check constructore of StoreLogic");
    })
*/


  it("initial balance of store owner in the escrow of the store should be 0.", async () => {
    //marketplarketplace = await Store.deployed({from : storeOwner});
    const paymentsToAccount0 = await store.payments(storeOwner);
    paymentsToAccount0.should.be.bignumber.equal(amount0);
  })

  it("after purchase, balance of store owner in the escrow of the store should be 2 ether.", async () => {
    //let instanceMarketplace = await Store.deployed({from : storeOwner});
    //let idProduct2 = await store.addProduct("Yellow Bike", 10, "A nice Yellow Bike", amount1, {from: storeOwner });
    await store.purchaseProduct (111111,2,{ value: amount3, from: alice });
    //-console.log(`idProduct: ${idProduct}`);
    const paymentsToAccount0 = await store.payments(storeOwner,{from : storeOwner});
    paymentsToAccount0.should.be.bignumber.equal(amount2);
  })

  it("balance of shopper in the escrow of the store should be O ether.", async () => {
    //let instanceMarketplace = await Store.deployed({from : storeOwner});
    //let idProduct2 = await store.addProduct("Yellow Bike", 10, "A nice Yellow Bike", amount1, {from: storeOwner });
    //await store.purchaseProduct (111111,2,{ value: amount3, from: alice });
    //-console.log(`idProduct: ${idProduct}`);
    const paymentsToAccount0 = await store.payments(alice,{from : alice});
    paymentsToAccount0.should.be.bignumber.equal(amount0);
  })

  it("buyer receive change when buying, accounting is fine.", async () => {
    //const initialAmount = web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]));
    const initialBalanceOfBuyer = await web3.eth.getBalance(alice);
    const initialBalanceOfEscrow= await store.payments(storeOwner);
    //console.log("initialBalanceOfBuyer"+initialBalanceOfBuyer);
    //console.log("initialBalanceOfEscrow"+initialBalanceOfEscrow);

    // Obtain gas used from the receipt
    //const receipt = await instanceMarketplace.buySth1Ether(125,{ value: amount10, from: alice });
    const receipt = await store.purchaseProduct (111111,1,{ value: amount3, from: alice });
    const gasUsed = receipt.receipt.gasUsed;
    //console.log(`GasUsed: ${receipt.receipt.gasUsed}`);

    // Obtain gasPrice from the transaction
    const tx = await web3.eth.getTransaction(receipt.tx);
    const gasPrice = tx.gasPrice;
    //console.log(`GasPrice: ${tx.gasPrice}`);

    //const remainingAmount = web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]));
    const finalBalanceOfBuyer = await web3.eth.getBalance(alice);
    const finalBalanceOfEscrow = await store.payments(storeOwner);

    //console.log("finalBalanceOfBuyer"+finalBalanceOfBuyer);
    //console.log("finalBalanceOfEscrow"+finalBalanceOfEscrow);

    assert.equal(finalBalanceOfBuyer.add(finalBalanceOfEscrow).add(gasPrice.mul(gasUsed)).toString(),
    initialBalanceOfBuyer.toString(),"Law of conservation of money, must be equal.");
  })

  it("store owner can retreive fund from store escrow, accounting is fine.", async () => {
    //let instanceMarketplace = await Store.deployed({from: owner});
    //await instanceMarketplace.purchaseProduct (0, 1, { value: amount2, from: alice });

    await store.purchaseProduct (111111,1,{ value: amount3, from: alice });

    const initialBalanceOfStoreOwner = await web3.eth.getBalance(storeOwner);
    const initialBalanceOfEscrow= await store.payments(storeOwner);

    const receipt = await store.withdrawPayments({from: storeOwner});
    const gasUsed = receipt.receipt.gasUsed;

    //console.log(`GasUsed: ${receipt.receipt.gasUsed}`);
    // Obtain gasPrice from the transaction
    const tx = await web3.eth.getTransaction(receipt.tx);
    const gasPrice = tx.gasPrice;
    //console.log(`GasPrice: ${tx.gasPrice}`);

    const finalBalanceOfStoreOwner = await web3.eth.getBalance(storeOwner);
    const finalBalanceOfEscrow= await store.payments(storeOwner);

    assert.equal(initialBalanceOfStoreOwner.add(initialBalanceOfEscrow).sub(gasPrice.mul(gasUsed)).toString(),
    finalBalanceOfStoreOwner.toString(),"Law of conservation of money, must be equal.");

    assert.equal(finalBalanceOfEscrow.toString(),0,"Escrow is empty");
  })

  it("marketplaceAdministrator can not recover funds from store escrow.", async () => {
    assert.equal(await marketplace.hasRole(marketplaceOwner,MKT_ROLE_ADMIN),true,
    "marketplaceOwner should not have the role marketplaceAdmin");
    await tryCatch(store.withdrawPayments({from: marketplaceOwner}), errTypes.revert);
    //await tryCatch(store.withdrawPayments({from: alice}), errTypes.revert);
  })

  it("a user can not recover funds from store escrow.", async () => {
    assert.equal(await marketplace.hasRole(marketplaceOwner,MKT_ROLE_ADMIN),true,
    "marketplaceOwner should not have the role marketplaceAdmin");
    await tryCatch(store.withdrawPayments({from: alice}), errTypes.revert);
  })

})
