# Marketplace

This central marketplace is businessly managed by a group of administrators who can manage administrators and approved store owners. The marketplace is technically managed by an owner for technical operation. The group of approved store owners can create store(s). Each store owner can manage the products in its store. Shopper can visit shop and buy products. Funds are secured in each store by being sequestered inside a store escrow. Payment withdrawal from the store owners is achieved through a pull payment mechanism.

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
Opera 55.0.2994.44
Metamask 3.14.1
Angular (sudo npm install -g @angular/cli)
```

Marketplace has been tested on Ubuntu with the following software versions:
```sh
Ubuntu 16.04
node v8.11.4
npm 5.6.0
Truffle v4.1.13
Solidity v0.4.24 (solc-js)
Ganache-CLI V6.1.6 (Ganache Core 2.1.5)
Firefox 61.0.1 (32 bit)
Metamask 4.8.0
Angular (sudo npm install -g @angular/cli)
```

Note :
* Ganache should use the port 8545.
* Metamask should use local network, port 8545.


## Getting Started
### Step 0 : Get the marketplace project and test the smart contracts
Create an empty "work" directory and change your working directory
```sh
mkdir work
cd work
```
Get the sources for the Marketplace project from github.
Compile and test to verify that everything works fine.
```sh
git clone https://github.com/MIKATRUST/Marketplace.git
cd Marketplace
truffle compile
```
start manually Ganache application
```
truffle migrate --reset
truffle test
```
Tests should be fine, if this is the case, you can continue the installation.

### Step 2 : Install the limelabs-angular-box truffle box
Follow the steps below to install the limelabs-angular-box. Please have a look at the truffle box doc at  https://truffleframework.com/boxes/limelabs-angular-box to install Angular.
```sh
cd ..
mkdir ./limelabs-angular-box/
cd ./limelabs-angular-box/
truffle unbox LimelabsTech/angular-truffle-box
```
Restart manually Ganache application
```
truffle compile (you will get warnings)
truffle migrate
truffle test
ng serve
```
You should be able to see the front end of the Metacoin application by directing your web3 enabled browser to http://localhost:4200/
If you can see the metacoin site and send a Metacoin, everything should be fine, you can continue and go to the next step.
Now you can stop the server

### Step 3 : Inject the Marketplace project inside the limelabs-angular-box truffle box
Let's do some cleaning.
```sh
rm -rf ./limelabs-angular-box/contracts
rm -rf ./limelabs-angular-box/migrations
rm -rf ./limelabs-angular-box/test
rm -rf ./limelabs-angular-box/src
```
Then we inject Markeplace directories inside limelabs-angular-box :
```sh
cp -R ./Marketplace/contracts ./limelabs-angular-box/contracts
cp -R ./Marketplace/migrations ./limelabs-angular-box/migrations
cp -R ./Marketplace/test ./limelabs-angular-box/test
cp -R ./Marketplace/src ./limelabs-angular-box/src
cp -R ./Marketplace/node_modules/* ./limelabs-angular-box/node_modules/
```
Then we test again
```sh
cd ./limelabs-angular-box/
truffle compile
```
Restart manually Ganache application
```sh
truffle migrate --reset
truffle test
```
We can now start the server. You should be able to see the front end of the Metacoin application by directing your web3 enabled browser to http://localhost:4200/
```sh
ng serve
```
### Step 4 : Play with the marketplace
To facilitate testing of the marketplace, it is recommended to have 3 name users in your Metamask local network with the following name (you can do it by importing the private key from Ganache and editing teh default name for the account) :
* Admin for Ganache account[0]. Note : the deployer of the contract has de-facto the role "marketplaceAdministrator". Admin can add role "marketplaceAdministrator" to given user(s). Admin can add role "marketplaceApprovedStoreOwner" to given user(s).
* StoreOwner for Ganache account[1]. Note : Admin should had manually the role 'marketplaceApprovedStoreOwner' to Ganache account[1].
* Shopper for Ganache account[3]. Note : any unknown address is considered by the marketplace to have the role "shopper".

## Architecture
The marketplace is architectures around 5+ contracts :
* Marketplace.sol : to handle Marketplace business with the ability to create/instanciate store.
* Store.sol : to handle product management and payment based on a pull payment approach to recover funds.
* CrudStore.sol : to handle Data Storage With Sequential Access, Random Access and Delete for stores in the contract Marketplace.Sol.
* CrudItem.sol : to handle Data Storage With Sequential Access, Random Access and Delete for products in the stores.
* Migrations.sol : to handle migration of contracts.

We made an extensive use of EthPM assets, particularly from Open Zeppelin, here the lib / contract that were used in our project:
* SafeMath : Library for SafeMath operation
* Ownable : A contract to handle owning operation.
* RBAC.sol / Roles:.sol : A library used to manage addresses assigned to different user roles and an example Role-Based Access Control (RBAC) interface that demonstrates how to handle setters and getters for roles and addresses.
* PullPayment.sol / Escrow.sol : A contract that implement a pull payment system based on an escrow.
* Pausable : A contract that give the ability to pause/unpause the contract.

## License
Code released under the [MIT License](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE).
