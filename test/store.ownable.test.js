
const Store = artifacts.require("Store");

contract('Store Ownable js tests', async (accounts) => {

  const owner = accounts[0]
  const alice = accounts[1]

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  beforeEach('deploy contract for each test', async function () {
    instance = await Store.deployed();
  })

  it("owner must be able to perform call/transaction", async () => {
     const value = await instance.addProduct ("Yellow Bike", 10, "A nice Yellow Bike", 1, {from: owner });
     assert.equal(await instance.productIsForSale(0, {from: owner }), true);
  })

  it("a user must not be able to perform call/transaction", async () => {
    await tryCatch(instance.productIsForSale(0, {from: alice }), errTypes.revert);
  })

  it("a user must not be able to transfer ownership", async () => {
    await tryCatch(instance.transferOwnership(alice, {from: alice}), errTypes.revert);
  })

  it("owner must be able to transfer ownerships", async () => {
    await instance.transferOwnership(alice, {from: owner});
    assert.equal(await instance.productIsForSale(0, {from: alice }), true);
  })

  it("former owner must not be able to transfer ownership", async () => {
    await tryCatch(instance.transferOwnership(owner, {from: owner}), errTypes.revert);
  })

  it("former owner must not be able to perform call/transaction", async () => {
        await tryCatch(instance.productIsForSale(0, {from: owner }), errTypes.revert);
  })

  it("new owner must be able to perform call/transaction", async () => {
     assert.equal(await instance.productIsForSale(0, {from: alice }), true);
  })


})
