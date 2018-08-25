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

## Getting Started

OpenZeppelin integrates with [Truffle](https://github.com/ConsenSys/truffle) and [Embark](https://github.com/embark-framework/embark/).

## truffle

To use with Truffle, first install it and initialize your project with `truffle init`.

```sh
npm install -g truffle
mkdir myproject && cd myproject
truffle init
```

## Prerequisites

To use with Embark, first install it and initialize your project with `embark new MyApp`.

```sh
npm install -g embark
embark new MyApp
cd MyApp
```

## Installing OpenZeppelin

After installing either Framework, to install the OpenZeppelin library, run the following in your Solidity project root directory:

```sh
npm init -y
npm install -E openzeppelin-solidity
```

**Note that OpenZeppelin does not currently follow semantic versioning.** You may encounter breaking changes upon a minor version bump. We recommend pinning the version of OpenZeppelin you use, as done by the `-E` (`--save-exact`) option.

After that, you'll get all the library's contracts in the `node_modules/openzeppelin-solidity/contracts` folder. You can use the contracts in the library like so:

```solidity
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract MyContract is Ownable {
  ...
}
```

If you are using Embark, you can also import directly from github:

```solidity
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol#v1.9.0";

contract MyContract is Ownable {
  ...
}
```

## Architecture
The following provides visibility into how OpenZeppelin's contracts are organized:

- **access** - Smart contracts that enable functionality that can be used for selective restrictions and basic authorization control functions. Includes address whitelisting and signature-based permissions management.
	- **rbac** - A library used to manage addresses assigned to different user roles and an example Role-Based Access Control (RBAC) interface that demonstrates how to handle setters and getters for roles and addresses.
- **crowdsale** - A collection of smart contracts used to manage token crowdsales that allow investors to purchase tokens with ETH. Includes a base contract which implements fundamental crowdsale functionality in its simplest form. The base contract can be extended in order to satisfy your crowdsale’s specific requirements.
	- **distribution** - Includes extensions of the base crowdsale contract which can be used to customize the completion of a crowdsale.
	- **emission** - Includes extensions of the base crowdsale contract which can be used to mint and manage how tokens are issued to purchasers.
	- **price** - Includes extensions of the crowdsale contract that can be used to manage changes in token prices.
	- **validation**  - Includes extensions of the crowdsale contract that can be used to enforce restraints and limit access to token purchases.
- **examples** - A collection of simple smart contracts that demonstrate how to add new features to base contracts through multiple inheritance.
- **introspection**  - An interface that can be used to make a contract comply with the ERC-165 standard as well as a contract that implements ERC-165 using a lookup table.
- **lifecycle** - A collection of base contracts used to manage the existence and behavior of your contracts and their funds.
- **math** - Libraries with safety checks on operations that throw on errors.
- **mocks** - A collection of abstract contracts that are primarily used for unit testing. They also serve as good usage examples and demonstrate how to combine contracts with inheritence when developing your own custom applications.
- **ownership** - A collection of smart contracts that can be used to manage contract and token ownership
- **payment** - A collection of smart contracts that can be used to manage payments through escrow arrangements, withdrawals, and claims. Includes support for both single payees and multiple payees.
- **proposals** - A collection of smart contracts that reflect community Ethereum Improvement Proposals (EIPs). These contracts are under development and standardization. They are not recommended for production, but they are useful for experimentation with pending EIP standards. Go [here](https://github.com/OpenZeppelin/openzeppelin-solidity/wiki/ERC-Process) for more information.

- **token** - A collection of approved ERC standard tokens -- their interfaces and implementations.
	- **ERC20** - A standard interface for fungible tokens:
		- *Interfaces* - Includes the ERC-20 token standard basic interface. I.e., what the contract’s ABI can represent.
		- *Implementations* - Includes ERC-20 token implementations that include all required and some optional ERC-20 functionality.
	- **ERC721** - A standard interface for non-fungible tokens
		- *Interfaces* - Includes the ERC-721 token standard basic interface. I.e., what the contract’s ABI can represent.
		- *Implementations* - Includes ERC-721 token implementations that include all required and some optional ERC-721 functionality.

## Tests
Unit test are critical to the OpenZeppelin framework. They help ensure code quality and mitigate against security vulnerabilities. The directory structure within the `/tests` directory corresponds to the `/contracts` directory. OpenZeppelin uses Mocha’s JavaScript testing framework and Chai’s assertion library. To learn more about how to tests are structured, please reference OpenZeppelin’s Testing Guide.

## How To Use And Modify OpenZeppelin Contracts
When using OpenZeppelin to build your own distributed applications, for security reasons we encourage you NOT to modify the framework’s base contracts, libraries, and interfaces. In order to leverage and extend their functionality, we encourage you to inherit from them or compose them together with your own contracts.

The Solidity programming language supports multiple inheritance. This is very powerful yet it can also be confusing: the more complexity you introduce to your distributed applications through multiple inheritance, the greater your application’s attack surface is.

You’ll notice in the `/mocks` directory there are a collection of abstract contracts used primarily for unit testing purposes that can also be used as the foundation for your own custom implementations. These mock contracts demonstrate how OpenZeppelin’s secure base contracts can be used with multiple inheritance.

To learn more about combining OpenZeppelin contracts with your own custom contracts using multiple inheritance we encourage you to read the following: [On crowdsales and multiple inheritance](https://blog.zeppelin.solutions/on-crowdsales-and-multiple-inheritance-af90c694e35f)

## Security
OpenZeppelin is meant to provide secure, tested and community-audited code, but please use common sense when doing anything that deals with real money! We take no responsibility for your implementation decisions and any security problem you might experience.

The core development principles and strategies that OpenZeppelin is based on include: security in depth, simple and modular code, clarity-driven naming conventions, comprehensive unit testing, pre-and-post-condition sanity checks, code consistency, and regular audits.

If you find a security issue, please email [security@openzeppelin.org](mailto:security@openzeppelin.org).

## Developer Resources

Building a distributed application, protocol or organization with OpenZeppelin?

- Read documentation: https://openzeppelin.org/api/docs/open-zeppelin.html

- Ask for help and follow progress at: https://slack.openzeppelin.org/

Interested in contributing to OpenZeppelin?

- Framework proposal and roadmap: https://medium.com/zeppelin-blog/zeppelin-framework-proposal-and-development-roadmap-fdfa9a3a32ab#.iain47pak
- Issue tracker: https://github.com/OpenZeppelin/openzeppelin-solidity/issues
- Contribution guidelines: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/CONTRIBUTING.md
- Wiki: https://github.com/OpenZeppelin/openzeppelin-solidity/wiki

## License
Code released under the [MIT License](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE).
