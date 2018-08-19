
const MarketplaceLogic = artifacts.require("MarketplaceLogic");
const StoreLogic = artifacts.require("StoreLogic");

contract('Marketplace Logic js tests', async (accounts) => {

  const owner = accounts[0]; //Marketplace owner
  const alice = accounts[1];
  const bob = accounts[2];
  const alexia = accounts[3];
  const georges = accounts[4];
  const arthur = accounts[5];

  const marketplaceAddr = 0xa43bd34038ca13e7115e16770d722e62ea706212;

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  it("store must be able to applicate to the marketplace.", async () => {
    let instance = await MarketplaceLogic.deployed();
    let instanceStore = await StoreLogic.deployed();

    //instanceStore.applyToMarketplace("toto");

    const expectedEventResult = {_sid:alice};
    const LogApplicationReceivedMade = await instance.LogApplicationReceived();

    //var event = supplyChain.ForSale()

    await instance.applyToMarketplace("truck1",{from : alice});
    //deprecated
    //let value = await instance.getApplicantStores.call();
    //assert.equal(value.length, 1, "marketplace must have 1 applicant store.");

    //TBD : assert.equal(instance.stores[alice].state, instance.State.ApplicationReceived, "store state must be ApplicationReceived.");

    const log = await new Promise(function(resolve, reject) {
        LogApplicationReceivedMade.watch(function(error, log){ resolve(log);});
    });
    const logStoreAddress = log.args._sid;
    assert.equal(expectedEventResult._sid, logStoreAddress, "LogApplicationReceivedMade event _sid property not emmitted, check applyToMarketplace method");

  })

  it("store must not be able to applicate 2 times to the marketplace.", async () => {
    let instance = await MarketplaceLogic.deployed();
    await tryCatch(instance.applyToMarketplace("truck1",{from : alice}), errTypes.revert);
  })

  it("marketplace owner must be able to accept the application of a store.", async () => {
    let instance = await MarketplaceLogic.deployed();

    const expectedEventResult = {_sid:alexia};
    const LogApplicationAcceptedMade = await instance.LogApplicationAccepted();

    await instance.acceptApplicantStore(alexia,{from : owner});
    let theState = await instance.getState.call(alexia,{from : owner});
    assert.equal(theState, 1/*ApplicationAccepted*/, "state must be ApplicationAccepted.");

    const log = await new Promise(function(resolve, reject) {
        LogApplicationAcceptedMade.watch(function(error, log){ resolve(log);});
    });
    const logStoreAddress = log.args._sid;
    assert.equal(expectedEventResult._sid, logStoreAddress, "LogApplicationAcceptedMade event _sid property not emmitted, check acceptApplicantStore method");
  })

  it("marketplace owner must be able to reject the application of a store.", async () => {
    let instance = await MarketplaceLogic.deployed();

    const expectedEventResult = {_sid:georges};
    const LogApplicationRejectedMade = await instance.LogApplicationRejected();

    await instance.rejectApplicantStore(georges,{from : owner});
    let theState = await instance.getState.call(georges,{from : owner});
    assert.equal(theState, 2/*ApplicationRejected*/,"state must be ApplicationRejected.");

    const log = await new Promise(function(resolve, reject) {
        LogApplicationRejectedMade.watch(function(error, log){ resolve(log);});
    });
    const logStoreAddress = log.args._sid;
    assert.equal(expectedEventResult._sid, logStoreAddress, "LogApplicationRejectedMade event _sid property not emmitted, check rejectApplicantStore method");

  })

  it("marketplace owner must be able to suspend a store whose application has been accepted.", async () => {
    let instance = await MarketplaceLogic.deployed();

    const expectedEventResult = {_sid:alexia};
    const LogStoreSuspendedMade = await instance.LogStoreSuspended();

    let theState = await instance.getState.call(alexia,{from : owner});
    assert.equal(theState, 1/*ApplicationAccepted*/, "state must be ApplicationAccepted.");
    await instance.suspendStore(alexia,{from : owner});
    let stateSuspended = await instance.getState.call(alexia,{from : owner});
    assert.equal(stateSuspended, 3/*StoreSuspended*/,"state must be StoreSuspended.");

    const log = await new Promise(function(resolve, reject) {
        LogStoreSuspendedMade.watch(function(error, log){ resolve(log);});
    });
    const logStoreAddress = log.args._sid;
    assert.equal(expectedEventResult._sid, logStoreAddress, "LogStoreSuspendedMade event _sid property not emmitted, check suspendStore method");
  })

  it("store owner must be able to remove the store from the marketplace.", async () => {
    let instance = await MarketplaceLogic.deployed();

    const expectedEventResult = {_sid:bob};
    const LogStoreRemovedMade = await instance.LogStoreRemoved();

    await instance.applyToMarketplace("truck1",{from : bob});
    await instance.acceptApplicantStore(bob,{from : owner});
    let stateAccepted = await instance.getState.call(bob,{from : owner});
    assert.equal(stateAccepted, 1/*ApplicationAccepted*/, "state must be ApplicationAccepted.");
    await instance.removeStore(bob,{from : bob});
    let stateRemoved = await instance.getState.call(bob,{from : owner});
    assert.equal(stateRemoved, 4/*StoreRemoved*/,"state must be StoreRemoved.");

    const log = await new Promise(function(resolve, reject) {
        LogStoreRemovedMade.watch(function(error, log){ resolve(log);});
    });
    const logStoreAddress = log.args._sid;
    assert.equal(expectedEventResult._sid, logStoreAddress, "LogStoreRemoveddMade event _sid property not emmitted, check removeStore method");

  })


/*
it("somebody must be able to get the array of accepted store.", async () => {
getOpenStores()  !!! duplicate avec getApplicantStores ? à factoriser ?
*/

})
