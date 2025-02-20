// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ETHicalRice} from "../src/ETHicalRice.sol";

contract ETHicalRiceTest is Test {
    ETHicalRice public gameContract;
    address public player = address(1);

    function setUp() public {
        gameContract = new ETHicalRice();
    }

    function test_AddCampaign() public {
        gameContract.addCampaign("Test Campaign", "This is a test campaign", 1000);
        assertEq(gameContract.getNextCampaign().name, "Test Campaign");
    }

    function test_GetFarmPlots() public view {
        assertEq(gameContract.getFarmPlots(player).length, 9);
    }

    function test_plantAtFarmPlotTime() public {
        gameContract.plantAtFarmPlot(player, 1, 1);
        assertEq(gameContract.getFarmPlots(player)[1].plantType, 1);
    }

    function test_harvestFarmPlot() public {
        uint256 timestamp = block.timestamp;
        uint8 TOMATO = 1;
        gameContract.plantAtFarmPlot(player, 0, TOMATO);
        vm.warp(timestamp + 60 * 60 + 1);
        gameContract.harvestFarmPlot(player, 0);
        uint8[3] memory plantSupply = gameContract.getPlantSupply(player);
        assertEq(plantSupply[TOMATO], 1);
    }
}
