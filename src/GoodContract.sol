// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

error ShouldBeMoreThanZero();
error FailedToSend();

contract GoodContract {
    mapping(address => uint256) public balances;

    //update the `balances` mapping to include the new ETH deposited 
    function addBalance() public payable {
        balances[msg.sender] += msg.value;
    }

    //send ETH woeth balances `balances[msg.sender]` back to msg.sender
    function withdraw() public {
        //must have >0 ETH deposited
        if(balances[msg.sender] == 0) {
            revert ShouldBeMoreThanZero();
        }
        //attempt to transfer
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        if(!sent) {
            revert FailedToSend();
        }
        //this code becomes unreachable because the conytract balance is drained
        //before user's balance could be set to 0
        balances[msg.sender] = 0;
    }
}