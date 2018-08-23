
const Marketplace = artifacts.require("Marketplace");


contract('Store Pausable js tests', async (accounts) => {

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

//  beforeEach('deploy contract for each test', async function () {
//    instance = await Store.deployed();
//  })

  it("call/transaction can be performed when the contract is in unpause mode.", async () => {
    //await tryCatch(instance.heartBeatPausable({from: alice}), errTypes.revert);
    marketplace = await Marketplace.new({from : marketplaceOwner});
    assert(marketplace !== undefined,"marketplace should be defined");
    //await tryCatch(marketplace.getStoreCount({from: alice }), errTypes.revert);
    assert.equal(await marketplace.getStoreCount({from: alice }),0, "should get result");
  })

  it("a user can not pause the contract.", async () => {
    //instance = await Store.deployed();
    await tryCatch(marketplace.pause({from: alice}), errTypes.revert);
  })

  it("owner can pause the contract, expect revert for call/transaction.", async () => {
    //instance = await Store.deployed();
    let contractState = await marketplace.pause({from: marketplaceOwner});
    await tryCatch(marketplace.getStoreCount({from: marketplaceOwner }), errTypes.revert);
  })

  it("a user must not be able to unpause the contract.", async () => {
    await tryCatch(marketplace.unpause({from: alice}), errTypes.revert);
    await tryCatch(marketplace.getStoreCount({from: alice }), errTypes.revert);
  })

  it("owner must be able to unpause the contract.", async () => {
    await marketplace.unpause({from: marketplaceOwner});
    assert.equal(await marketplace.getStoreCount({from: alice }),0, "should get result");
  })
})
