// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ETHicalRice} from "../src/ETHicalRice.sol";

contract ETHicalRiceScript is Script {
    ETHicalRice public gameContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        gameContract = new ETHicalRice();

        vm.stopBroadcast();
    }
}
