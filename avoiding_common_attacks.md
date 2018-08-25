explains what measures you took to ensure that your contracts are not susceptible to common attacks. (​Module 9 Lesson 3)

See : Solidity Security: Comprehensive list of known attack vectors and common anti-patterns
https://blog.sigmaprime.io/solidity-security.html


Arithmetic Over/Under Flows

The Vulnerability
An over/under flow occurs when an operation is performed that requires a fixed size variable to store a number (or piece of data) that is outside the range of the variable's data type.

Preventative Techniques used
Used a mathematical libraries which replace the standard math operators; addition, subtraction and multiplication (division is excluded as it doesn't cause over/under flows and the EVM throws on division by 0).


Unexpected Ether

Self Destruct / Suicide

## Common attacks
### Re-Entrancy
This attack can occur when a contract sends ether to an unknown address. An attacker can carefully construct a contract at an external address which contains malicious code in the fallback function. We used the preventive technique to avoid calling external contract, except the built-in transfer() function. Moreover, funds in each store are stored in an escrow based on the pull payment pattern.
### Arithmetic Over/Under Flows
If care is not taken, variables in Solidity can be exploited if user input is unchecked and calculations are performed which result in numbers that lie outside the range of the data type that stores them (eg uin8(256) = 0). We used the preventive technique to check value before doing any math operation. We relied on the SafeMath library from Open Zeppelin to perform this operation.
### Unexpected Ether
### Delegatecall
### Default visibilities
The default visibility for functions is public. Therefore functions that do not specify any visibility will be callable by external users. We have used the  preventive technique to always specify the visibility of all functions in a contract. We have also adopted an onion ring strategy to access low level data (eg products in store) by having all low level variables set to private and internal function that must be inherited by the contract that will use the data.
### Entropy illusion
There is no rand() function in Solidity. Achieving decentralised entropy (randomness) is a well established problem and many ideas have been proposed to address this. So far our implementation does not need randomness, so our contracts are not subjected to this threat.
### External contract referencing
One of the benefits of Ethereum global computer is the ability to re-use code and interact with contracts already deployed on the network. One of these contract could be a threat. We have used the preventive technique of not calling any unknown external contracts. However in our architecture, the marketplace create external Store contract using the new keyword to create the contract and recover the address of the child contract (hard codings external address). In future release, it could be of interest to implement additional interaction between the Markeplace and child Store contracts. In this case, it will be of great importance to prevent modification of the Store contract, especially by the store owner.

### Unchecked CALL Return Values
### Race Conditions / Frontrunning
### Denial Of Service (DOS)
### Block Timestamp Manipulation

### Unitialised Pointer Storage
### Tx.origin Authentification
Contracts that authorize users using the tx.origin variable are typically vulnerable to phishing attacks which can trick users into performing authenticated actions on the vulnerable contract. In our project the Marketplace contract create Store child contract, and indeed tx.origin is used. Howeverwe used the preventive technique to always use tx.origin with msg.sender. Reader have a look at Marketplace.sol, and more specifically, the line following line : require(msg.sender==tx.origin, "caller should not be a contract"); We use this approach to assess that the caller is not a contract.
### Ethereum Quirk
