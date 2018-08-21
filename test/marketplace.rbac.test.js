
const Marketplace = artifacts.require("Marketplace");

contract('Marketplace RBAC js tests', async (accounts) => {

  const marketplaceOwner = accounts[0];
  const storeOwner = accounts[1];
  const alice = accounts[2];
  const bob = accounts[3];

  const MKT_ROLE_SHOPPER = 'shopper';
  const MKT_ROLE_ADMIN = 'marketplaceAdministrator';
  const MKT_ROLE_APPROVED_STORE_OWNER = 'marketplaceApprovedStoreOwner';

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  beforeEach('deploy contract for each test', async function () {
    marketplace = await Marketplace.deployed();
  })

  it("marketplaceOwner should have the role marketplaceAdministrator", async () => {
    assert.equal(await marketplace.hasRole(marketplaceOwner,MKT_ROLE_ADMIN,{from:marketplaceOwner}), true,
    "operator has not the role marketplaceAdministrator");
  })

  it("add/remove role marketplaceAdministrator", async () => {
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_SHOPPER), false, "operator has not the role shopper");
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_ADMIN), false, "operator has not the role marketplaceAdministrator");
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_APPROVED_STORE_OWNER), false, "operator has not teh role marketplaceApprovedStoreOwner");
    await marketplace.addRoleAdministrator(alice,{from : marketplaceOwner});
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_ADMIN), true, "operator has role marketplaceAdministrator");
    //await marketplace.removeRoleAdministrator(alice,MKT_ROLE_APPROVED_STORE_OWNER);
    await marketplace.removeRoleAdministrator(alice,{from:marketplaceOwner});
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_ADMIN), false, "operator has not role marketplaceAdministrator");
  })

  it("user should not be able to change his role to marketplaceAdministrator", async () => {
    await tryCatch(marketplace.addRoleAdministrator(alice,{from : alice}), errTypes.revert);
  })

  it("add/remove role marketplaceApprovedStoreOwner", async () => {
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_SHOPPER), false, "operator has not the role shopper");
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_ADMIN), false, "operator has not the role marketplaceAdministrator");
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_APPROVED_STORE_OWNER), false, "operator has not teh role marketplaceApprovedStoreOwner");
    await marketplace.addRoleApprovedStoreOwner(alice,{from:marketplaceOwner});
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_APPROVED_STORE_OWNER), true, "operator has role marketplaceApprovedStoreOwner");
    //await marketplace.removeRoleAdministrator(alice,MKT_ROLE_APPROVED_STORE_OWNER);
    await marketplace.removeRoleApprovedStoredOwner(alice,{from:marketplaceOwner});
    assert.equal(await marketplace.hasRole(alice,MKT_ROLE_APPROVED_STORE_OWNER), false, "operator has not role marketplaceApprovedStoreOwner");
    //check if not market admin
  })

  it("user should not be able to change his role to marketplaceApprovedStoreOwner", async () => {
      await tryCatch(marketplace.addRoleApprovedStoreOwner(alice,{from : alice}), errTypes.revert);
  })

})
