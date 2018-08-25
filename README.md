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
git clone <URL>
```

Navigate into the directory of the repository you just created.
```sh
cd <REPOSITORY-NAME>
```
verify that the current state of your repository and the files it contains.

```sh
 git status
```

To compile the contract, use
```sh
truffle compile
```
To migrate the contract to Ganache, use
```sh
truffle migrate --reset
```
note that `--reset is advised to have a clean environment`

To execute test, use
```sh
truffle test
```






## License
Code released under the [MIT License](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE).
