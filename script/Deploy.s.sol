// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {GoodContract} from "../src/GoodContract.sol";
import {BadContract} from "../src/BadContract.sol";

contract Deploy is Script {
    GoodContract public goodContract;
    BadContract public badContract;

    function run() external {
        //start Broadcast
        vm.startBroadcast();

        //deploy GoodContract
        goodContract = new GoodContract();

        //deploy badContarct with the address of GoodContract
        badContract = new BadContract(address(goodContract));

        //stop Broadcast
        vm.stopBroadcast();
    }
}