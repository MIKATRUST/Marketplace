const assert = require("chai").assert;

const Marketplace = artifacts.require("Marketplace");
const Store = artifacts.require("Store");

contract('marketplace.stores create/retrieve/delete stores js tests, ', async (accounts) => {

  const marketplaceOwner = accounts[0];
  const storeOwner = accounts[1];
  const alice = accounts[2];
  const bob = accounts[3];
  const rita = accounts[8];

  const MKT_ROLE_SHOPPER = 'shopper';
  const MKT_ROLE_ADMIN = 'marketplaceAdministrator';
  const MKT_ROLE_APPROVED_STORE_OWNER = 'marketplaceApprovedStoreOwner';

  const storeCreateCount = 3; //number of store to create for test

  const amount0 = web3.toWei(0.0, 'ether');
  const amount05 = web3.toWei(0.5, 'ether');
  const amount1 = web3.toWei(1.0, 'ether');
  const amount2 = web3.toWei(2.0, 'ether');
  const amount3 = web3.toWei(3.0, 'ether');
  const amount5 = web3.toWei(5.0, 'ether');
  const amount10 = web3.toWei(10.0, 'ether');
  const amount100 = web3.toWei(100.0, 'ether');

  let marketplace;
  let store;
  let addressCreatedStore;
  let storeCount;

  var expectedStoreCollection = [];
  var retrievedStoreCollection = [];

  function StoreJs(address, index, name) {
    this.address = address;
    this.index = index;
    this.name = name;
  }

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  beforeEach('setup contract for each test, marketplaceOwner approve 1 store owner', async function() {
    //get marketplace instance
    marketplace = await Marketplace.new({from: marketplaceOwner});
  })

  it("user with no role should not be able able to create a store ", async () => {
    //marketplace = await Marketplace.new({from: marketplaceOwner});
    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
      addressCreatedStore = res.args._store.toString(16)
      eventEmitted = true
    })

    await tryCatch(marketplace.createStore("bob", {from: bob}), errTypes.revert);
    assert.equal(eventEmitted, false, 'store was not created, event LogNewStore should not be triggered');
  })

  it("user with role marketplaceAdministrator should not be able able to create a store ", async () => {
    //await marketplace.addRoleApprovedStoreOwner(storeOwner, {from: marketplaceOwner});
    assert.equal(await marketplace.hasRole(marketplaceOwner, MKT_ROLE_ADMIN), true,
    "marketplaceOwner has role MKT_ROLE_ADMIN.")
    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
      addressCreatedStore = res.args._store.toString(16)
      eventEmitted = true
    })

    await tryCatch(marketplace.createStore(bob, {from: bob}), errTypes.revert);

    assert.equal(eventEmitted, false, "store was not created, event LogNewStore should not be triggered.");
  })

  it("user with the role ApprovedStoreOwner should be able to create a store. ", async () => {
    await marketplace.addRoleApprovedStoreOwner(storeOwner, {
      from: marketplaceOwner
    });
    assert.equal(await marketplace.hasRole(storeOwner, MKT_ROLE_APPROVED_STORE_OWNER), true, "approvedStoreOwner should not have the role ApprovedStoreOwner.")

    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
      addressCreatedStore = res.args._store.toString(16)
      eventEmitted = true
    })

    let storeName = "default store name";
    let transactionReceipt = await marketplace.createStore(storeName, {
      from: storeOwner
    });
    assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event')

    store = await Store.at(addressCreatedStore);
    assert.equal(await store.isAvailable(), true, "store should be available");
  })

  it("store owner can add product. ", async () => {
    await store.addProduct(999999, "Yellow Bike", 10, "A nice Yellow Bike", amount1, "images/BIKE1.jpeg", {
      from: storeOwner
    });
    assert.equal(await store.getProductCount(), 1, "store should have 1 product");
  })

  it("store owner can update product price. ", async () => {
    let val = await store.updateProductPrice(999999,amount05,{from: storeOwner});
    let retPQ = await store.getProductQuantityPrice(999999);
    assert.equal(retPQ[1], amount05, "product price should have been updated");
  })

  it("store owner can update product quantity. ", async () => {
    let val = await store.updateProductQuantity(999999,5,{from: storeOwner});
    let retPQ = await store.getProductQuantityPrice(999999);
    assert.equal(retPQ[0], 5, "product price should have been updated");
  })

  it("buyer can not buy if not enough fund. ", async () => {
    assert.equal(await store.getProductCount(), 1, "store should have 1 product sku");
    await tryCatch(store.purchaseProduct(999999, 1, {
      value: amount0,
      from: alice
    }), errTypes.revert);
  })

  it("buyer can buy if enough fund and enough stock, qty of th store should be updated. ", async () => {
    assert.equal(await store.getProductCount(), 1, "store should have 1 product sku");
    let ret = await store.getProductQuantityPrice(999999);
    assert.equal(ret[0].toNumber(), 5, "stock of sku 999999 should be 5");
    await store.purchaseProduct(999999, 5,{value: amount10,from: alice});
    ret = await store.getProductQuantityPrice(999999);
    assert.equal(ret[0].toNumber(), 0, "stock of sku 999999 should be 0");
  })

  it("create/retrieve numerous stores", async () => {
    await marketplace.addRoleApprovedStoreOwner(storeOwner, {
      from: marketplaceOwner
    });

    //create stores
    for (let i = 0; i < storeCreateCount; i++) {
      let storeIndex = i;
      let storeName = `Store #${i}`;

      var eventEmitted = false
      var event = marketplace.LogNewStore()
      await event.watch((err, res) => {
        storeAdr = res.args._store.toString(16)
        eventEmitted = true
      })

      await marketplace.createStore(storeName, {
        from: storeOwner
      });
      assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event')
      store = await Store.at(storeAdr);
      assert.equal(await store.isAvailable(), true, "store should be available");
      let newStore = new StoreJs(storeAdr, storeIndex, storeName);
      expectedStoreCollection.push(newStore);
    }
    assert.equal(await marketplace.getStoreCount(), storeCreateCount, `marketplace should have created stores`);

    //retrieve stores
    storeCount = await marketplace.getStoreCount();
    assert.equal(storeCount, storeCreateCount, "storeCount expected and storeCount retrieved should be the same ");
    for (let i = 0; i < storeCount; i++) {

      storeAdr = await marketplace.getStoreAtIndex(i);
      storeInfo = await marketplace.getStore(storeAdr);
      storeName = web3.toAscii(storeInfo[0]).replace(/\u0000/g, '');
      let newStore = new StoreJs(storeAdr, i, storeName);
      retrievedStoreCollection.push(newStore);
    }

    //check that recovered store are the same : name, address, indexed
    assert.equal(expectedStoreCollection.length, retrievedStoreCollection.length,
    "array size of expectedStoreCollection and retrievedStoreCollection should be the same");
    for (let i = 0; i < storeCount; i++) {

      var expectedStore = expectedStoreCollection.pop();
      var retrievedStore = retrievedStoreCollection.pop();
      assert.equal(expectedStore['address'], retrievedStore['address'], "address should match");
      assert.equal(expectedStore['index'], retrievedStore['index'], "index should match");
      assert.equal(expectedStore['name'], retrievedStore['name'], "address should match");
      store = await Store.at(retrievedStore['address']);
      assert(store !== undefined, "store instance should be defined")
      assert.equal(await store.isAvailable(), true, "store should be available");

    }

  })

  /*
    afterEach(async () => {
            await casino.kill({from: fundingAccount});
        });
  */
})
