explains what measures you took to ensure that your contracts are not susceptible to common attacks. (​Module 9 Lesson 3)

See : Solidity Security: Comprehensive list of known attack vectors and common anti-patterns
https://blog.sigmaprime.io/solidity-security.html


Arithmetic Over/Under Flows

The Vulnerability
An over/under flow occurs when an operation is performed that requires a fixed size variable to store a number (or piece of data) that is outside the range of the variable's data type.

Preventative Techniques used
uses a mathematical libraries which replace the standard math operators; addition, subtraction and multiplication (division is excluded as it doesn't cause over/under flows and the EVM throws on division by 0). 
