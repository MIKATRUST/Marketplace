//How to test for throwing require, revertt
//https://www.reddit.com/r/ethdev/comments/83jms0/how_do_i_test_for_requires_throwing_revert_truffle/

const Marketplace = artifacts.require("Marketplace");

contract('MarketPlace Destructible js tests', async (accounts) => {

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

  it("no role user should not be able to destroy the marketplace.", async () => {
    let marketplace = await Marketplace.deployed();
    await tryCatch(marketplace.destroy({from: alice}), errTypes.revert);
  })

  //V2 implement revenue sharing betweenn the stores and the marketplace
  it("testing fallback function, tentative to send ether to non existing function of the marketplace should be reverted",async () => {
    let marketplace = await Marketplace.deployed();
    await tryCatch(marketplace.aNiceFunctionThatDoesNotExit({from: alice, value: amount1}), errTypes.revert);
  })

  it("marketplaceAdministrator should be able to destroy the marketplace", async () => {
    let marketplace = await Marketplace.deployed();
    //web3.getCode("0xbfb2e296d9cf3e593e79981235aed29ab9984c0f");
    //let storeCountNumber = await marketplace.getStoreCount();
    //assert(marketplace !== undefined, "marketplace instance should be defined")
    await marketplace.destroy({from: marketplaceOwner});
    assert.equal(await marketplace.owner(),0,"after seldestruct(), all values of the contract should be set to zero");

    //assert(marketplace == undefined, "marketplace instance is not defined anymore")
    //assert(markeplace == undefined, "following destruction, store instance should not be defined anymore")
    //eth.getCode("0xbfb2e296d9cf3e593e79981235aed29ab9984c0f")

    // work correctly but exception is not catched
    //await tryCatch(instance.heartBeat({from: owner}), errTypes.revert);
    //assert.isUndefined(instance);

  })

/* TBD
  it('owner must be able to destroy the contract and send balance to given recipient.', async function () {
    let instance = await Store.deployed({from: accounts[0], value: web3.toWei('40', 'ether')});
    let initBalance = web3.eth.getBalance(accounts[1]);
    await instance.destroyAndSend(accounts[1],{from : owner});
    let newBalance = web3.eth.getBalance(accounts[1]);
    assert.isTrue(newBalance.greaterThan(initBalance));
  });
*/



})
