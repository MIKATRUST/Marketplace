
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

  let marketplace;
  let store;
  let addressCreatedStore;
  let storeCount;

  var expectedStoreCollection = [];
  var retrievedStoreCollection = [];

  function StoreJs(address,index,name) {
     this.address = address;
     this.index = index;
     this.name = name;
  }

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  beforeEach('setup contract for each test, marketplaceOwner approve 1 store owner', async function () {
    //get marketplace instance
    marketplace = await Marketplace.new({from : marketplaceOwner});
  })

  it("user with no role should not be able able to create a store ", async () => {
    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
      addressCreatedStore = res.args._store.toString(16)
      eventEmitted = true
    })

    await tryCatch(marketplace.createStore(bob, {from: bob}), errTypes.revert);
    assert.equal(eventEmitted, false, 'store was not created, event LogNewStore should not be triggered');
  })

  it("user with role marketplaceAdministrator should not be able able to create a store ", async () => {
    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
      addressCreatedStore = res.args._store.toString(16)
      eventEmitted = true
    })

    await tryCatch(marketplace.createStore(bob, {from: bob}), errTypes.revert);
    assert.equal(await marketplace.hasRole(marketplaceOwner,MKT_ROLE_APPROVED_STORE_OWNER),false,"marketplaceOwner should not have the role ApprovedStoreOwner.")
    assert.equal(eventEmitted, false, "store was not created, event LogNewStore should not be triggered.");
  })


  it("user with the role ApprovedStoreOwner should be able to create a store. ", async () => {
    await marketplace.addRoleApprovedStoreOwner(storeOwner,{from:marketplaceOwner});
    assert.equal(await marketplace.hasRole(storeOwner,MKT_ROLE_APPROVED_STORE_OWNER),true,"approvedStoreOwner should not have the role ApprovedStoreOwner.")

    var eventEmitted = false
    var event = marketplace.LogNewStore()
    await event.watch((err, res) => {
        addressCreatedStore = res.args._store.toString(16)
        eventEmitted = true
    })

    let storeName = "default store name";
    let transactionReceipt = await marketplace.createStore(storeName,{from : storeOwner});
    assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event')

    store = await Store.at(addressCreatedStore);
    assert.equal(await store.isAvailable(),true,"store should be available");
})

  it("create/retrieve numeorus stores", async () => {
    await marketplace.addRoleApprovedStoreOwner(storeOwner,{from:marketplaceOwner});

    //create stores
    for (let i = 0; i < storeCreateCount;i++) {
      let storeIndex = i;
      let storeName = `Store #${i}`;

      var eventEmitted = false
      var event = marketplace.LogNewStore()
      await event.watch((err, res) => {
          storeAdr = res.args._store.toString(16)
          eventEmitted = true
      })

      let transactionReceipt = await marketplace.createStore(storeName,{from : storeOwner});
      assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event')
      //let storeAdr = transactionReceipt.logs[0].args._store;
      store = await Store.at(storeAdr);
      assert.equal(await store.isAvailable(),true,"store should be available");
      let newStore = new StoreJs(storeAdr, storeIndex, storeName);
      expectedStoreCollection.push(newStore);
    }
    assert.equal(await marketplace.getStoreCount(),storeCreateCount,`marketplace should have created stores`);

    //retrieve stores
    storeCount = await marketplace.getStoreCount();
    assert.equal(storeCount,storeCreateCount,"storeCount exepected and storeCount retrieved should be the same ");
    for (let i = 0; i < storeCount;i++) {
      storeAdr = await marketplace.getStoreAtIndex(i);
      storeInfo = await marketplace.getStore(storeAdr);
      storeName = web3.toAscii(storeInfo[0]).replace(/\u0000/g,'');
      let newStore = new StoreJs(storeAdr, i, storeName);
      retrievedStoreCollection.push(newStore);
    }

    //compare expectedStoreCollection and retrievedStoreCollection
    for (let i = 0; i < storeCount;i++) {
      var expectedStore = expectedStoreCollection.pop();
      var retrievedStore = retrievedStoreCollection.pop();
      assert.equal(expectedStore['address'],retrievedStore['address'], "address should match");
      assert.equal(expectedStore['index'],retrievedStore['index'], "index should match");
      assert.equal(expectedStore['name'],retrievedStore['name'], "address should match");
      assert.equal(await store.isAvailable(),true,"store should be available");
    }

  })


/*
  afterEach(async () => {
          await casino.kill({from: fundingAccount});
      });
*/



})
