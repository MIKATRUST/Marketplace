# Smart-Contract Patterns

Writing smart-contracts has been proven to be difficult. That's why the marketplace
has been implemented relying on key design patterns. To implement such patterns,
we have decided to use a battle-tested framework of reusable smart contracts
called OpenZeppelin.

## Patterns

The patterns are logically divided into four groupings. `Lifetime` is a group of
patterns that control the construction and destruction of smart-contracts.
`Maintenance` is a group of patterns that provide mechanisms for live contracts.
`Ownership` is a group of patterns that control access to smart-contract. And
finally `Security` is a group of patterns that seek to mitigate security related
matters.

### Lifetime

///////!!! to be done
//`auto_deprecation` - We have implemented a watchdog mechanism Provides a mechanism
//for automatic expiration of a contract
//interface after some period of time has elapsed.
//[lifetime/auto_deprecation.sol](lifetime/auto_deprecation.sol)

`destructible` - Provides a method for the creator of a contract to destroy it.
[zeppelin/lifecycle/Destructible.sol](zeppelin/lifecycle/Destructible.sol)

To check is the contract was effectively destroyed : https://stackoverflow.com/questions/37644395/how-to-find-out-if-an-ethereum-address-is-a-contract
eth.getCode("0xbfb2e296d9cf3e593e79981235aed29ab9984c0f")

### Maintenance

`update` - Provides a method for the creator of a contract to update it to a
newer version without invalidating the address.
[contracts/Migrations.sol](contracts/Migrations.sol)

//`data_segregation` - Segregates a contract and its data so as to avoid costly
//data migrations.
//[maintenance/data_segregation.sol](maintenance/data_segregation.sol)

### Ownership

`ownable` - Limits access to certain functions to only the owner of the contract.
[zeppelin/ownership/Ownable.sol](zeppelin/ownership/Ownable.sol)

### Security

`circuit breaker` - The circuit breaker pattern allows the owner to pause or
unpause a contract by a runtime toggle.
[zeppelin/lifecycle/Pausable.sol](zeppelin/lifecycle/Pausable.sol)

`revert` - The revert pattern has been implemented in the fallback function to
automatically rejects all ether sent to a non existing function of the contract.
[contracts/store.sol](contracts/store.sol)
[contracts/marketplace.sol](contracts/marketplace.sol)

//`speed_bump` - The speed bump pattern limits how often a function can be called
//to deliberately slow down certain functions.
//[security/speed_bump.sol](security/speed_bump.sol)
