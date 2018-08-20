
const Marketplace = artifacts.require("Marketplace");
const Store = artifacts.require("Store");

//var marketplaceAddr = "";

contract('marketplace create/retrieve/delete stores js tests, ', async (accounts) => {

  const marketplaceOwner = accounts[0];
  const storeOwner = accounts[1];
  const alice = accounts[2];

  let marketplace;
  let store;
  beforeEach('setup contract for each test, marketplaceOwner approve 1 store owner', async function () {
    //get marketplace instance
    marketplace = await Marketplace.new({from : marketplaceOwner});
  })

  it("create stores", async () => {
    var storeCountTarget;
    var i;
    var storeCollection;

    for (i = 0; i < storeCountTarget; ++) {
      await marketplace.createStore("Cars1",{from : storeOwner});

      console.log("Faire un pas vers l'est");
    }


    for (var i in object) {


      if (object.hasOwnProperty(i)) {

      }
    }
    await marketplace.createStore("Cars1",{from : storeOwner});
    await marketplace.createStore("Cars2",{from : storeOwner});
    await marketplace.createStore("Cars3",{from : storeOwner});
    await marketplace.createStore("Cars4",{from : storeOwner});
    await marketplace.createStore("Cars5",{from : storeOwner});

    assert.equal(await marketplace.getStoreCount(),5,"marketplace should have 5 stores");
  })

  it("retrieve stores", async () => {
    for (var i in object) {
      if (object.hasOwnProperty(i)) {

      }
    }

  })

/*
    //add approved store owner
    //await marketplace.addAprovedStoreOwner (storeOwner,{from : marketplaceOwner});
    //create store
    const result1 = await marketplace.createStore("Cars",{from : storeOwner});
    //if needed, have a look at the results of teh transactionwe
    //console.log(result.tx); console.log(result.logs);console.log(result.receipt);
    //TBD : check also event name
    const adrStore = result1.logs[0].args._store; //console.log("address of the new store : "+adrStore);
    store = await Store.at(adrStore);

    //assert.equal(await marketplace.getStoresNum(), 1, "marketplace should have 1 stores");
    assert.equal(await store.isAvailable(), true, "store should be available, otherwise store was not created. check constructore of StoreLogic");

    //let's add product in the store
    await store.addProduct(111111,"Yellow Bike",10,"A nice Yellow Bike", amount1,"images/BIKE1.jpeg",{from: storeOwner });
    assert.equal(await store.getProductCount(), 1, "store should have 1 product");
*/

})
