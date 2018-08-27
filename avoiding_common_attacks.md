## Common attacks
Here we explain what measures have been taken to ensure that the contracts are not susceptible to common attacks.

### Re-Entrancy
* Vulnerability : This attack can occur when a contract sends ether to an unknown address. An attacker can carefully construct a contract at an external address which contains malicious code.
* Preventive technique : We Adopted a defensive way of programming : finish all the internal work first, before calling the external function or use asynchronous payment based on the pattern pull payment. We also adopted the debit/diminish first then credit/add. We avoided calling external contract, except the built-in transfer() function. Moreover, good purchasing use asynchronous payment (=pull payment pattern) where funds sequestered inside an escrow.

### Forcibly sending Ether to a Contract
* Vulnerability : It is possible to forcibly send Ether to a contract without triggering its fallback function. This is an important consideration when placing important logic in the fallback function or making calculations based on a contract's balance.
* Preventive technique : We do not use pattern implying `contract.balance` like `require(this.balance > 0)` nor we do not put important logic in the fallback function.

### Arithmetic Over/Under Flows
* Vulnerability : If care is not taken, variables in Solidity can be exploited if user input is unchecked and calculations are performed which result in numbers that lie outside the range of the data type that stores them (eg `uin8(256) = 0`).
* Preventive technique : we check value before doing any math operation to check for a possibility of Over/Under flow. We relied on the SafeMath library from Open Zeppelin to perform this operation.

### Default visibilities
* Vulnerability : The default visibility for functions is public. Therefore functions that do not specify any visibility will be callable by external users.
* Preventive technique : we always specify the visibility of all functions in a contract. We have also adopted an onion ring strategy to access low level data (eg products in store) by having all low level variables set to private and internal function (in fact the data is always visible on the blockchain). Internal function must be inherited by the contract that will use the low level data.

### Entropy illusion
* Vulnerability : There is no rand() function in Solidity. Achieving decentralised entropy (randomness) is a well established problem and many ideas have been proposed to address this.
* So far our implementation does not need randomness, so our contracts are not subjected to this threat.

### External contract referencing
* Vulnerability : One of the benefits of Ethereum global computer is the ability to re-use code and interact with contracts already deployed on the network. One of these contract could be a threat.
* Preventive technique : We have used the preventive technique of not calling any unknown external contracts. However in our architecture, the marketplace create external Store contract using the new keyword to create the contract and recover the address of the child contract (hard codings external address). In future release, it could be of interest to implement additional interaction between the Markeplace and child Store contracts.

### Unchecked CALL Return Values
* Vulnerability : There is a number of ways of performing external calls in solidity. Sending ether to external accounts is commonly done via the transfer() method. However, the send() function can also be used and, for more versatile external calls, the CALL opcode can be directly employed in solidity. The call() function return a boolean indicating if the call succeeded or failed. Thus these functions have a simple caveat, in that the transaction that executes these functions will not revert if the external call (intialised by call() or send()) fails, rather the call() or send() will simply return false. A common pitfall arises when the return value is not checked, rather the developer expects a revert to occur.
* Preventive technique : We use `transfer()` and not `send()`. We have implemented a pull payment approach in contract `Store.sol`.

### Race Conditions / Transaction-Ordering Dependance (TOD) / Frontrunning
* Vulnerability : The Ethereum nodes pool transactions and form them into blocks. The transactions are only considered valid once a miner has solved a consensus mechanism. The miner who solves the block also chooses which transactions from the pool will be included in the block, this is typically ordered by the gasPrice of a transaction. Hence order of transactions (within a block or block/next block) is easily subjected to manipulation. An attacker can watch the transaction pool which may contain solutions to problems, modify or revoke the attacker's permissions or change a state in a contract which is undesirable for the attacker. This attacker can then get the data from this transaction and create a transaction of his own with a higher gasPrice whick will be included in the block before the original previous transaction.
* Preventive technique : use  commit-reveal scheme, create logic in the contract that places an upper bound on the gasPrice. Not implemented yet in the contract.

### Denial Of Service (DOS)
* Vulnerability : An attacker can leave a contract inoperable for a small period of time, or in some cases, permanently by manipulating for instance the number of data stored in an array and hence the time to iterate such array.
* Preventive technique : We have used a CRUD contract (`CrudItem.sol`, `CrudStore.sol`) to get constant lookup and update costs over objects. We should adopt the same approach for handling user properties, eg getStores for a given store owner. To avoid "DOS expected revert", we have avoided pattern like
giving a preemptive privilege to a given user to revert a function, eg `require(currentLeader.send(highestBid))`.To avoid "DoS with Block Gas Limit", we have avoided pattern like where an attacker can ask for numerous small refunds that consume all the gas.

### Block Timestamp Manipulation
* Vulnerability : Timestamp of the block can be manipulated by the miner by adjust timestamps within the time window of the block (typ. 15 seconds). So `block.timestamp` or its alias `now` could be manimulated in time span of 15 seconds.
* In our case, our contracts are not subjected to this threat.

### Tx.origin Authentification
* Vulnerability : Contracts that authorize users using the `tx.origin` variable are typically vulnerable to phishing attacks which can trick users into performing authenticated actions on the vulnerable contract. In our project the Marketplace contract create Store child contract, and indeed tx.origin is used.
* Preventive technique : We always use `tx.origin` with `msg.sender` with `require(msg.sender==tx.origin);` in our case to be sure that the transactioner is not a contract.

### Ethereum Quirk / Keyless Ether
* Vulnerability : Contract addresses are deterministic, meaning that they can be calculated prior to actually creating the address. This is the case for addresses creating contracts and also for contracts spawning other contracts. In fact, a created contract's address is determined by: `keccak256(rlp.encode([<account_address>, <transaction_nonce>])` where both `acccount_address` and `transaction_nonce` are both known, `nonce` being incremented for each new spawned contract. In our case `Marketplace.sol` spawn contract `Store.sol` contract. An attacker could send ether to the address of a `Store.sol` contract not created yet and then retrieve the ether by later creating a contract which gets spawned over the same address. The constructor could be used to return all the pre-sent ether.
* Preventive technique : use of a pull payment approach with ether stored in an escrow inside each `Store.sol`.

### Further ressources

* Known attacks: https://consensys.github.io/smart-contract-best-practices/known_attacks/

* Solidity Security: Comprehensive list of known attack vectors and common anti-patterns
https://blog.sigmaprime.io/solidity-security.html
