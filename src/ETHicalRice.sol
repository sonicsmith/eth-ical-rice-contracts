// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interfaces/IETHicalRice.sol";

contract ETHicalRice is IETHicalRice {
    uint256 constant MINUTE = 60;
    uint256 constant HOUR = 60 * MINUTE;
    uint256 constant PLANT_GROWTH_TIME = HOUR;
    uint256 constant RICE_GROWTH_TIME = 24 * HOUR;

    // Owner of the contract
    address public owner;

    // Array of Campaigns
    Campaign[] public campaigns;

    uint256 public nextCampaignIndex = 0;

    // Mapping of addresses to an array of farm plots
    mapping(address => uint256[9]) public farmPlotTimes;
    mapping(address => uint8[9]) public farmPlotPlantTypes;

    // Mapping of addresses to their plant supply
    mapping(address => uint8[3]) public plantSupply;
    // Mapping of addresses to their plant supply
    mapping(address => uint256) public riceSeedCount;

    string scriptHash = "";

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotAuthorized();
        _;
    }

    function setScriptHash(string memory _scriptHash) external onlyOwner {
        scriptHash = _scriptHash;
    }

    // Function to add a new campaign
    function addCampaign(string memory name, string memory description, uint256 amount) external onlyOwner {
        campaigns.push(Campaign(name, description, amount));
    }

    // Function to set a farm plot time by index
    function plantAtFarmPlot(address user, uint8 index, uint8 plantType) external onlyOwner {
        uint256 time = farmPlotTimes[user][index];
        if (time != 0) revert FarmPlotAlreadySet();
        // If rice plant, remove seed
        if (plantType == 2) {
            if (riceSeedCount[user] == 0) revert NotEnoughRiceSeeds();
            riceSeedCount[user]--;
        }
        farmPlotTimes[user][index] = block.timestamp;
        farmPlotPlantTypes[user][index] = plantType;
    }

    function grantRiceSeed(address user, uint256 riceCost) external onlyOwner {
        if (nextCampaignIndex >= campaigns.length) revert NoCampaignsAvailable();
        if (riceCost >= campaigns[nextCampaignIndex].amount) {
            nextCampaignIndex++;
            campaigns[nextCampaignIndex].amount = 0;
        }
        campaigns[nextCampaignIndex].amount -= riceCost;
        riceSeedCount[user]++;
    }

    function harvestFarmPlot(address user, uint8 index) external onlyOwner {
        uint256 time = farmPlotTimes[user][index];
        uint8 plantType = farmPlotPlantTypes[user][index];
        uint256 growTime = plantType != 2 ? PLANT_GROWTH_TIME : RICE_GROWTH_TIME;
        if (time + growTime > block.timestamp) revert FarmPlotNotReady();
        // Increase the plant count
        plantSupply[user][plantType]++;
        // Reset the farm plot
        farmPlotTimes[user][index] = 0;
        farmPlotPlantTypes[user][index] = 0;
    }

    function reducePlantSupply(address user, uint8 plantType, uint8 amount) external onlyOwner {
        if (plantSupply[user][plantType] < amount) revert NotEnoughSupply();
        plantSupply[user][plantType] -= amount;
    }

    function getPlantSupply(address user) external view returns (uint8[3] memory) {
        uint8[3] memory plants;
        for (uint8 i = 0; i < 3; i++) {
            plants[i] = plantSupply[user][i];
        }
        return plants;
    }

    // Function to return the first campaign from the campaigns array
    function getNextCampaign() external view returns (Campaign memory) {
        if (nextCampaignIndex >= campaigns.length) revert NoCampaignsAvailable();
        return campaigns[nextCampaignIndex];
    }

    function getFarmPlots(address user) external view returns (FarmPlot[] memory) {
        FarmPlot[] memory plots = new FarmPlot[](9);
        if (farmPlotTimes[user].length == 0) {
            return plots;
        }
        for (uint256 i = 0; i < 9; i++) {
            uint256 time = farmPlotTimes[user][i];
            uint8 plantType = farmPlotPlantTypes[user][i];
            plots[i] = FarmPlot(time, plantType);
        }
        return plots;
    }

    function getScriptHash() external view returns (string memory) {
        return scriptHash;
    }
}
