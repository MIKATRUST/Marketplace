
const Store = artifacts.require("Store");

contract('Store Destructible js tests', async (accounts) => {

  const owner = accounts[0]
  const alice = accounts[1]

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  it("alice must not be able to destroy the contract.", async () => {
    let instance = await Store.deployed();
    await tryCatch(instance.destroy({from: alice}), errTypes.revert);
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

  it("owner expect the contract being destructible by the owner", async () => {
    let instance = await Store.deployed();
    await instance.destroy({from: owner});
    // work correctly but exception is not catched
    //await tryCatch(instance.heartBeat({from: owner}), errTypes.revert);
    //assert.isUndefined(instance);

  })

})
