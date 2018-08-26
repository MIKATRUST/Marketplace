const assert = require("chai").assert;
const BigNumber = web3.BigNumber;


const Marketplace = artifacts.require("Marketplace");
const Store = artifacts.require("Store");

contract('marketplace.stores populate js tests, ', async (accounts) => {
  //const run = exports.run = async(accounts) => {

  const marketplaceOwner = accounts[0];
  const storeOwner = accounts[1];
  const alice = accounts[2];
  const bob = accounts[3];
  const rita = accounts[8];

  const MKT_ROLE_SHOPPER = 'shopper';
  const MKT_ROLE_ADMIN = 'marketplaceAdministrator';
  const MKT_ROLE_APPROVED_STORE_OWNER = 'marketplaceApprovedStoreOwner';

  const storeCreateCount = 3; //number of store to create for test
  const productCreateCount = 7; //number of product to create for test

  const amount5 = web3.toWei(5.0, 'ether');
  const amount10 = web3.toWei(10.0, 'ether');

  //const items = require("./../src/js/trucks");
  //const items2 = require("./../src/js/trucks");
  //const items3 = require("./../src/js/trucks");

  let marketplace;
  let store;
  storeNumber = 0;
  let addressCreatedStore;
  let storeCount;

  let expectedStoreCollection = [];
  let retrievedStoreCollection = [];
  let sharedStoreAddresses;
  let magicNumber;

  function StoreJs(address, index, name) {
    this.address = address;
    this.index = index;
    this.name = name;
  }

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  it("set a user with role ApprovedStoreOwner.", async () => {
    marketplace = await Marketplace.new({
      from: marketplaceOwner
    });
    await marketplace.addRoleApprovedStoreOwner(storeOwner, {
      from: marketplaceOwner
    });
    assert.equal(await marketplace.hasRole(storeOwner, MKT_ROLE_APPROVED_STORE_OWNER), true, "approvedStoreOwner should not have the role ApprovedStoreOwner.")
  })

  it("user with role ApprovedStoreOwner can create stores.", async () => {
    for (let i = 0; i < storeCreateCount; i++) {
      //prepare to catch the event
      var eventEmitted = false
      var event = marketplace.LogNewStore()
      await event.watch((err, res) => {
        addressCreatedStore = res.args._store.toString(16)
        eventEmitted = true
      })
      //build store name
      let storeName = `Store #${i}`;
      let transactionReceipt = await marketplace.createStore(storeName, {
        from: storeOwner
      });
      assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event')
      store = await Store.at(addressCreatedStore);
      assert(store !== undefined, "store should be defined");
    }
  })

  it("a user owner of a store can addproduct.", async () => {
    storeNumber = 1;
    for (let productNumber = 0; productNumber < productCreateCount; productNumber++) {
      let baseName = "Cars";
      store = await Store.at(addressCreatedStore);
      assert(store !== undefined, "store should be defined");
      assert.equal(await store.isAvailable(), true, "store should be available");

      let productSku = storeNumber * 100 + productNumber;
      let productName = `${baseName}_${storeNumber}_name${productNumber}_`;
      let productQuantity = productNumber;
      let productDescription = `Nice ${productName}`;
      let productPrice = web3.toWei(productNumber, 'ether')
      let productImage = "bla";
      await store.addProduct(productSku, "Yellow Bike", productQuantity, productDescription, productPrice,
        "images/BIKE1.jpeg", {
          from: storeOwner
        });
      //Assert LogAddProductAdded
    }
    let productCount = await store.getProductCount();
    assert.equal(productCreateCount, productCount.toString(), "store should have productCreateCount products");
    storeNumber++;
  })

  it("a user not owner of a store can not addproduct.", async () => {
    storeNumber = 1;

    store = await Store.at(addressCreatedStore);
    //assert(store !== undefined,"store should be defined");

    let productSku = 1111111111;
    let productName = "Whatever";
    let productQuantity = 10;
    let productDescription = "Whatever";
    let productPrice = web3.toWei(amount5, 'ether')
    let productImage = "bla";
    await tryCatch(store.addProduct(productSku, "Yellow Bike", productQuantity, productDescription, productPrice,
      "images/BIKE1.jpeg", {
        from: rita
      }), errTypes.revert);

    //    await store.addProduct(productSku,"Yellow Bike",productQuantity,productDescription, productPrice,
    //  "images/BIKE1.jpeg",{from: rita });
    //Assert LogAddProductAdded

  })


  /*
    it("user with role ApprovedStoreOwner can addproduct in its store.", async () => {

    })


    it("loading bike dataset in bulk mode", async () => {
      for (var p in items) {
          var id = items[p]["id"];
          var name = items[p]["name"];
          var quantity = items[p]["quantity"];
          var description = items[p]["description"];
          var picture = items[p]["picture"];
          var price = items[p]["price"];
          // !!! Missing picture
          await instance.addProduct (name, quantity, description, price, {from: owner });
          //console.log("**"+p+": "+id+"*"+name+"*"+quantity+"*"+description+"*"+picture+"*"+price);
        }

  */









  /*
  it("conservation. ", async () => {
    //marketplace = await Marketplace.new({from : marketplaceOwner});
    //await marketplace.addRoleApprovedStoreOwner(storeOwner,{from:marketplaceOwner});
    assert.equal(await marketplace.hasRole(storeOwner,MKT_ROLE_APPROVED_STORE_OWNER),true,"approvedStoreOwner should not have the role ApprovedStoreOwner.")
  })
  */


  /*
    beforeEach('setup contract for each test, marketplaceOwner approve 1 store owner', async function () {

        await marketplace.addRoleApprovedStoreOwner(storeOwner,{from:marketplaceOwner});
        assert.equal(await marketplace.hasRole(storeOwner,MKT_ROLE_APPROVED_STORE_OWNER),true,
        "storeOwner should have role MKT_ROLE_APPROVED_STORE_OWNER");

        function addProducts(storeAddress,appStoreOwner,storeNumber,productNumber) {
           this.storeAddress = storeAddress;
           this.storeNumber = storeNumber;
           this.productNumber = productNumber;
           store = await Store.at(this.storeAddress);
           assert(store !== undefined,"store should be defined");
           let productSku = `${storeNumber}_${productNumber}`);
           let productName = `${storeNumber}_name${productNumber}_`);
           let productQuantity = storeNumber*productNumber;
           let productDescription = `${storeNumber}_${productNumber}`);
           let productPrice = web3.utils.toWei(productNumber+0.001, 'ether');
           let productImage = "bla"
           await store.addProduct(productSku,productName,productQuantity,
             productDescription,productPrice,productImage);
          //Assert LogAddProductAdded
        }

        //create stores

        //for (let i = 0; i < storeCreateCount;i++) {
        //  let storeIndex = i;
          //let storeName = `Store #${i}`;


          var eventEmitted = false
          var event = marketplace.LogNewStore()
          await event.watch((err, res) => {
              storeAddress = res.args._store.toString(16)
              eventEmitted = true

          })


          await marketplace.createStore(storeName,{from : storeOwner});
          assert.equal(eventEmitted, true, 'creating a store should emit a LogNewStore event');
          //store = await Store.at(storeAdr);
          //addProducts(storeAddress,storeOwner,0,0);

        //  assert(store !== undefined,"store is defined")
        //  assert.equal(await store.isAvailable(),true,"store should be available");
        //  let newStore = new StoreJs(storeAdr, storeIndex, storeName);
        //  expectedStoreCollection.push(newStore);




        }
        assert.equal(await marketplace.getStoreCount(),storeCreateCount,`marketplace should have created stores`);



    });






    it("should have the shared context. ", async () => {
      context = await shared.run(accounts);
      sharedStoreAddresses = context.sharedStoreAddresses;
      magicNumber = context.magicNumber;
      assert(sharedStoreAddresses !== undefined,"has sharedStoreAddresses")
      assert(magicNumber !== undefined,"has magicNumber")
      console.log("****++"+magicNumber);
      console.log("****++"+sharedStoreAddresses);
      console.log("****++"+sharedStoreAddresses[0]);
      console.log("****++"+sharedStoreAddresses.pop());

      //assert(retrievedStoreCollection !== undefined,"has sharedStoreAddress")
      //var shared1StoreAddress = sharedStoreAddress.pop();
      //console.log("******"+shared1StoreAddress);

      //store = await Store.at(retrievedStore['address']);
      //assert(store !== undefined,"store instance should be defined")
      //assert.equal(await store.isAvailable(),true,"store should be available");

    });

    //return {expectedStoreCollection, retrievedStoreCollection}
    */

})