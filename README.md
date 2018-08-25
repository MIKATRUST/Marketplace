# Marketplace

The projeect Marketplace operating on the blockchain has been implemented. This central marketplace is managed from a business point of view by a group of administrators who can manage store owner. The group of approved store owners can create shops and manage products withins theses shops. Shopper can visit shops and buy products. Owner of the store can get funds from its store through a pull payment mechanism.

## Prerequisites
have git, Truffle and Ganache installed and running.

Marketplace has been tested on Mac with the following software versions :
```sh
OS X Yosemite version 10.10.15
node v8.11.3
npm 6.1.0
Truffle v4.1.13 (core: 4.1.13)
Solidity v0.4.24 (solc-js)
Ganache 1.1.0
```

Marketplace has been tested on Ubuntu with the following software versions:
```sh
Ubuntu 16.04
node v8.11.4
npm 5.6.0
```

## Getting Started
Get the marketplace project and source code from github
```sh
git clone https://github.com/MIKATRUST/Marketplace.git
```

Navigate into the directory of the repository you just created.
```sh
cd Marketplace
```

To compile the contract, use
```sh
truffle compile
```
To migrate the contract to Ganache, use
```sh
truffle migrate --reset
```
note that `--reset` is advised to have a clean environment if the case of several migration

To execute test, use
```sh
truffle test
```
## Architecture
The marketplace is architectures around 5+ contracts :
Marketplace.sol : to handle Marketplace business with the ability to create/instanciate store.
Store.sol : to handle product management and payment based on a pull payment approach to recover funds.
CrudStore.sol : to handle Data Storage With Sequential Access, Random Access and Delete for stores in the contract Marketplace.Sol.
CrudItem.sol : to handle Data Storage With Sequential Access, Random Access and Delete for products in the stores.
Migrations.sol : to handle migration of contracts.

We made made an extensive use of EthPM asset, particularly from Open Zeppelin, here the lib / contract that were used in our project:
Ownable : A contract to handle owning operation.
RBAC.sol / Roles:.sol : A library used to manage addresses assigned to different user roles and an example Role-Based Access Control (RBAC) interface that demonstrates how to handle setters and getters for roles and addresses.
PullPayment.sol / Escrow.sol : A contract that implement a pull payment system based on an escrow.
Pausable : A contract that give the ability to pause/unpause the contract.
SafeMath : Library for SafeMath operation

## License
Code released under the [MIT License](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE).
