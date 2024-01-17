// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract Exercise_1 {

    using Math for uint256;
    mapping(address => uint256) public balances;
    mapping(address => bool) private locked;

    /*
    The code in the BuggyExercise_1.sol contract is vulnerable to reentrancy attacks.
    The nonReentrant modifier prevents this by setting a lock on the user's address
    The nonReentrant modifier is used in the withdraw function to prevent reentrancy attacks
    */
    modifier nonReentrant(address user) {
        require(!locked[user], "Reentrant call");
        locked[user] = true;
        _;
        locked[user] = false;
    }

    /*
    The code in the BuggyExercise_1.sol contract is vulnerable to overflow and underflow attacks.
    The safe math functions from OpenZepplin are used to prevent overflow and underflow attacks 
    */

    function deposit(address user, uint256 amount) public {
        (,balances[user]) = balances[user].tryAdd(amount);
    }

    function withdraw(address user, uint256 amount) public nonReentrant(user) {
        require(amount <= balances[user], "Insufficient balance");
        (,balances[user]) = balances[user].trySub(amount);
    }

}
