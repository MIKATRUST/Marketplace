
const Marketplace = artifacts.require("Marketplace");

contract('Marketplace Ownable js tests', async (accounts) => {

  const marketplaceOwner = accounts[0];
  const storeOwner = accounts[1];
  const alice = accounts[2];
  const bob = accounts[3];

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  beforeEach('deploy contract for each test', async function () {
    marketplace = await Marketplace.deployed();
  })

  it("a user must not be able to transfer ownership", async () => {
    await tryCatch(marketplace.transferOwnership(alice, {from: alice}), errTypes.revert);
  })

  it("owner must be able to transfer ownerships", async () => {
    await marketplace.transferOwnership(alice, {from: marketplaceOwner});
    //assert.equal(await marketplace.productIsForSale(0, {from: alice }), true);
  })

  it("former owner must not be able to transfer ownership", async () => {
    await tryCatch(marketplace.transferOwnership(marketplaceOwner, {from: marketplaceOwner}), errTypes.revert);
  })
/*
  it("former owner must not be able to perform call/transaction", async () => {
        await tryCatch(marketplace.productIsForSale(0, {from: marketplaceOwner }), errTypes.revert);
  })
*/
  /*
    it("owner must be able to perform call/transaction", async () => {
       const value = await marketplace.addProduct ("Yellow Bike", 10, "A nice Yellow Bike", 1, {from: owner });
       assert.equal(await marketplace.productIsForSale(0, {from: owner }), true);
    })

    it("a user must not be able to perform call/transaction", async () => {
      await tryCatch(marketplace.productIsForSale(0, {from: alice }), errTypes.revert);
    })
  */

/*
  it("new owner must be able to perform call/transaction", async () => {
     assert.equal(await marketplace.productIsForSale(0, {from: alice }), true);
  })
*/

})
