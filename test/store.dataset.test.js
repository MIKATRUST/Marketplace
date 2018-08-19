
const Store = artifacts.require("Store");
const items = require("./../src/js/trucks");
const items2 = require("./../src/js/trucks");
const items3 = require("./../src/js/trucks");

contract('Store bulk mode loading js tests', async (accounts) => {

  const owner = accounts[0]
  const alice = accounts[1]

  let tryCatch = require("./exceptions.js").tryCatch;
  let errTypes = require("./exceptions.js").errTypes;

  beforeEach('deploy contract for each test', async function () {
    instance = await Store.deployed();
  })

  it("loading bike dataset in bulk mode", async () => {
    for (var p in items) {
        var id = items[p]["id"];
        var name = items[p]["name"];
        var quantity = items[p]["quantity"];
        var description = items[p]["description"];
        var picture = items[p]["picture"];
        var price = items[p]["price"];
        // !!! Missing picture
        await instance.addProduct (name, quantity, description, price, {from: owner });
        //console.log("**"+p+": "+id+"*"+name+"*"+quantity+"*"+description+"*"+picture+"*"+price);
      }

     //await instance.addProduct ("Yellow Bike", 10, "A nice Yellow Bike", 1, {from: owner });
     assert.equal(await instance.productIsForSale(0, {from: owner }), true);
  })

})

/*

for (var p in items) {
    var id = items[p]["id"];
    var name = items[p]["name"];
    var quantity = items[p]["quantity"];
    var description = items[p]["description"];
    var picture = items[p]["picture"];
    var price = items[p]["price"];
    console.log("**"+p+": "+id+"*"+name+"*"+quantity+"*"+description+"*"+picture+"*"+price);
  }
*/
