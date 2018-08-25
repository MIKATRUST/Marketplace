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

`auto_deprecation` - Provide a method for automatic expiration of a contract. Not implemented yet.

`destructible` - Provide a method to destroy the contract. Implemented.

### Maintenance

`update` - Provides a method for the creator of the contract to update it to a
newer version without invalidating the address. Implemented.

`data_segregation` - Provide a way to separate business logic and data so as to avoid costly updates. Not implemented yet.

### Ownership
`ownable`,`Role-Based Access Control` - The ownable and RBAC design patterns were implemented to limit access to certain
functions to only the owner of the contract or given groups like the marketplace administrators or the approved stores owners. Implemented.

### Security
`circuit breaker` - The circuit breaker pattern allows the owner to pause or
unpause a contract by a runtime toggle. Implemented.

`revert` - The revert pattern in the fallback function allows to
automatically rejects all ether sent to a non existing function of the contract. Implemented.

`speed_bump` - The speed bump pattern limits how often a function can be called
to deliberately slow down certain functions. Not implemented yet.
