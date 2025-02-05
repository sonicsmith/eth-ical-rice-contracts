// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IETHicalRice {
    error NotAuthorized();
    error NoCampaignsAvailable();
    error FarmPlotAlreadySet();
    error FarmPlotNotReady();
    error NotEnoughRiceSeeds();
    error NotEnoughSupply();

    struct Campaign {
        string name;
        string description;
        uint256 amount;
    }

    struct FarmPlot {
        uint256 time;
        uint8 plantType;
    }

    function setScriptHash(string memory _scriptHash) external;
    function getScriptHash() external view returns (string memory);
    function addCampaign(string memory name, string memory description, uint256 amount) external;
    function plantAtFarmPlot(address user, uint8 index, uint8 plantType) external;
    function grantRiceSeed(address user, uint256 riceCost) external;
    function harvestFarmPlot(address user, uint8 index) external;
    function reducePlantSupply(address user, uint8 plantType,uint8 amount) external;
    function getPlantSupply(address user) external view returns (uint8[3] memory);
    function getNextCampaign() external view returns (Campaign memory);
    function getFarmPlots(address user) external view returns (FarmPlot[] memory);
}
