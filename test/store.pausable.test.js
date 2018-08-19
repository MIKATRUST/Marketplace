
const Store = artifacts.require("Store");

contract('Store Pausable js tests', async (accounts) => {

  const owner = accounts[0]
  const alice = accounts[1]

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

//  beforeEach('deploy contract for each test', async function () {
//    instance = await Store.deployed();
//  })

  it("call/transaction can be performed when the contract is in unpause mode.", async () => {
    //await tryCatch(instance.heartBeatPausable({from: alice}), errTypes.revert);
    instance = await Store.deployed({from: owner});
    await instance.addProduct ("Yellow Bike", 10, "A nice Yellow Bike", 1, {from: owner });
    assert.equal(await instance.productIsForSale(0, {from: owner }), true);
  })

  it("a user can not pause the contract.", async () => {
    //instance = await Store.deployed();
    await tryCatch(instance.pause({from: alice}), errTypes.revert);
  })

  it("owner can pause the contract.", async () => {
    //instance = await Store.deployed();
    await instance.pause({from: owner});
    //await tryCatch(instance.heartBeatPausable({from: owner}), errTypes.revert);
    await tryCatch(instance.productIsForSale(0, {from: owner }), errTypes.revert);
  })

  it("user/owner can not perform call/transaction when the contract in pause mode.", async () => {
    //instance = await Store.deployed();
    await tryCatch(instance.productIsForSale(0, {from: owner }), errTypes.revert);
  })

  it("a user can not perform normal process in pause mode.", async () => {
    //instance = await Store.deployed();
    await tryCatch(instance.heartBeatPausable({from: alice}), errTypes.revert);
  })

  it("a user must not be able to unpause the contract.", async () => {
    //instance = await Store.deployed();
    await tryCatch(instance.unpause({from: alice}), errTypes.revert);
  })

  it("owner must be able to unpause the contract.", async () => {
    await instance.unpause({from: owner});
    //let value = await instance.heartBeatPausable({from: owner});
    assert.equal(await instance.productIsForSale(0, {from: owner }), true);
    //assert.equal(value, 2);
  })

  it("after pause resume, a user can perform normal process in unpause mode.", async () => {
    let value = await instance.heartBeatPausable({from: alice});
    assert.equal(value, 2);
  })

})
