var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  // console address of Migration
  //.then(() => console.log("Migration deployer :"))
  //.then(() => console.log(Migrations.address));
};
