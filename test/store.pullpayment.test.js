// !!! You need to install chai locally (on your node_modules directory),
// so that require can find it. To do so, type:
// type
//"npm install --save-dev chai" in the local directory
//"npm install --save-dev chai-bignumber" in the local directory

const Store = artifacts.require("Store");
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('Store Pull Payment js tests', async (accounts) => {

  const owner = accounts[0];
  const alice = accounts[1];
  const bob = accounts[2];
  const alix = accounts[3];

  const amount0 = web3.toWei(0.0, 'ether');
  const amount05 = web3.toWei(0.5, 'ether');
  const amount1 = web3.toWei(1.0, 'ether');
  const amount2 = web3.toWei(2.0, 'ether');
  const amount5 = web3.toWei(5.0, 'ether');
  const amount10 = web3.toWei(10.0, 'ether');

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  let initialAmountAlice = await web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]))

  it("balance of store owner in the escrow should be 0.", async () => {
    let instance = await Store.deployed({from : owner});
    const paymentsToAccount0 = await instance.payments(owner);
    paymentsToAccount0.should.be.bignumber.equal(amount0);
  })

  it("balance of store owner in the escrow should be 1 ether.", async () => {
    let instance = await Store.deployed({from : owner});
    let idProduct2 = await instance.addProduct("Yellow Bike", 10, "A nice Yellow Bike", amount1, {from: owner });
    await instance.purchaseProduct (0, 1, { value: amount2, from: alice });
    //console.log(`idProduct: ${idProduct}`);
    const paymentsToAccount0 = await instance.payments(owner);
    paymentsToAccount0.should.be.bignumber.equal(amount1);
  })

  it("store user withdrawPayments must be reverted.", async () => {
    let instance = await Store.deployed({from: owner});
    await instance.purchaseProduct (0, 1, { value: amount2, from: alice });
    //let amountToRecover = await instance.payments(owner, {from: owner });
    await tryCatch(instance.withdrawPayments({from: alice}), errTypes.revert);
  })

  it("store owner withdrawPayments must be successful.", async () => {
    let instance = await Store.deployed({from: owner});
    await instance.purchaseProduct (0, 1, { value: amount2, from: alice });
    let amountToRecover = await instance.payments(owner, {from: owner });
    await instance.withdrawPayments({from: owner});

  })

  it("buyer must receive change.", async () => {
    let instance = await Store.deployed({from : owner});
    //const initialAmount = web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]));
    const initialBalance = await web3.eth.getBalance(accounts[1]);

    // Obtain gas used from the receipt
    //const receipt = await instance.buySth1Ether(125,{ value: amount10, from: alice });
    const receipt = await instance.purchaseProduct (0, 1, { value: amount2, from: alice });
    const gasUsed = receipt.receipt.gasUsed;
    //console.log(`GasUsed: ${receipt.receipt.gasUsed}`);

    // Obtain gasPrice from the transaction
    const tx = await web3.eth.getTransaction(receipt.tx);
    const gasPrice = tx.gasPrice;
    //console.log(`GasPrice: ${tx.gasPrice}`);

    //const remainingAmount = web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]));
    const finalBalance = await web3.eth.getBalance(accounts[1]);
    const paymentEscrowed = await instance.payments(owner);
    assert.equal(finalBalance.add(paymentEscrowed).add(gasPrice.mul(gasUsed)).toString(),
    initialBalance.toString(), "Must be equal.");
  })
})
