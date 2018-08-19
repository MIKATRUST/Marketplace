pragma solidity ^0.4.24;

contract Migrations {
  address public mowner;
  uint public last_completed_migration;

  constructor() public {
    mowner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == mowner) _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
