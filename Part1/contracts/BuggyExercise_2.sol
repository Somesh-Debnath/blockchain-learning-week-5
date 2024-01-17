pragma solidity ^0.8.0;

contract Exercise_2 {
    mapping(address => uint256) public balances;

    function deposit(address user, uint256 amount) public {
        balances[user] += amount;
    }

    function withdraw(address user, uint256 amount) public {
        require(amount <= balances[user], "Insufficient balance");
        (bool success, ) = user.call{value: amount}("");
        require(success, "Transfer failed");
				balances[user] -= amount;
    }

    function addBalances(address user, uint256 amount) public {
        balances[user] += amount;
    }

    function subtractBalances(address user, uint256 amount) public {
        balances[user] -= amount;
    }

    function destroyContract(address payable recipient) public {
        selfdestruct(recipient);
    }
}