// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {GoodContract} from "../src/GoodContract.sol";
import {BadContract} from "../src/BadContract.sol";

contract ReEntrancy is Test {
    //declare variables for instances of GoodContract and BadContract
    BadContract public badContract;
    GoodContract public goodContract;

    //two addresses; treating one as innocent user; the other; attacker
    address innocentUser = address(1);
    address attacker = address(2);

    function setUp() public {
        //Deploy the Good Contract
        goodContract = new GoodContract();

        //deploy the bad contract
        badContract = new BadContract(address(goodContract));

        //set the balances of the attacker and the innocent user to 1 ether
        deal(attacker, 100 ether);
        deal(innocentUser, 100 ether);
    }

    function testAttack() public {
        //first value to deposit (1o ETH)
        uint firstDeposit = 10 ether;

        //in order to send the next call via the innocent user's address
        vm.prank(innocentUser);

        //Innocent user deposits 10 ETH into GoodContract
        goodContract.addBalance{value: firstDeposit}();

        //check if the goodContract balance is 10 ETH
        assertEq(address(goodContract).balance, firstDeposit);

        //in order to send next call via the attacker's address
        vm.prank(attacker);

        //attacker calls the `attack` function on badContract and sends 1 ETH
        badContract.attack{value: 1 ether}();

        //balance of the GoodContract address is now zero
        assertEq(address(goodContract).balance, 0);

        //balance of badContract is now 10 ETH stolen + 1 ETH from attacker
        assertEq(address(badContract).balance, 11 ether);
    }
}