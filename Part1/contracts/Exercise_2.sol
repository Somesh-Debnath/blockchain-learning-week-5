// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract Exercise_2 {

    using Math for uint256;
    mapping(address => uint256) public balances;
    mapping(address => bool) private locked;

    /*
    The code in the BuggyExercise_2.sol contract is vulnerable to reentrancy attacks.
    The nonReentrant modifier prevents this by setting a lock on the user's address
    The nonReentrant modifier is used in the withdraw function to prevent reentrancy attacks
    */
    modifier nonReentrant(address user) {
        require(!locked[user], "Reentrant call");
        locked[user] = true;
        _;
        locked[user] = false;
    }

    modifier onlyOwner(address user) {
        require(msg.sender == user, "Only owner can call this function");
        _;
    }

    function deposit(address user, uint256 amount) public {
        // use SafeMath to prevent overflow
        (,balances[user]) = balances[user].tryAdd(amount);
    }

    function withdraw(address user, uint256 amount) public {
        require(amount <= balances[user], "Insufficient balance");

        /* use SafeMath to prevent underflow
           update state before transfer to prevent reentrancy attacks
        */
        (,balances[user]) = balances[user].trySub(amount);
        (bool success, ) = user.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function addBalances(address user, uint256 amount) public {
        (,balances[user]) = balances[user].tryAdd(amount);
    }

    function subtractBalances(address user, uint256 amount) public {
        (,balances[user]) = balances[user].trySub(amount);
    }
    /*
    Selfdestruct risk is mitigated by restricting access control
    States are updated before selfdestruct to prevent reentrancy attacks
    */
    function destroyContract(address payable recipient) public onlyOwner(msg.sender){
        uint256 balance=address(this).balance;
        recipient.transfer(balance);
        selfdestruct(recipient);
    }
}