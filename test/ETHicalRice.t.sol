// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ETHicalRice} from "../src/ETHicalRice.sol";

contract ETHicalRiceTest is Test {
    ETHicalRice public gameContract;

    function setUp() public {
        gameContract = new ETHicalRice();
    }

    function test_AddCampaign() public {
        gameContract.addCampaign("Test Campaign", "This is a test campaign", 1000);
        assertEq(gameContract.getNextCampaign().name, "Test Campaign");
    }
}
