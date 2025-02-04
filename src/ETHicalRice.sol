// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interfaces/IETHicalRice.sol";

contract ETHicalRice is IETHicalRice {
    // Owner of the contract
    address public owner;

    // Array of Campaigns
    Campaign[] public campaigns;

    uint256 public nextCampaignIndex = 0;

    // Mapping of addresses to an array of timestamps for farm plots
    mapping(address => uint256[]) public farmPlotTimes;

    // Mapping of addresses to an array of types for farm plots
    mapping(address => uint8[]) public farmPlotTypes;

    // Mapping of addresses to their rice supply
    mapping(address => uint256) public riceSupply;

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotAuthorized();
        _;
    }

    // Function to add a new campaign
    function addCampaign(string memory name, string memory description, uint256 amount) public onlyOwner {
        campaigns.push(Campaign(name, description, amount));
    }

    function createPlayerFarmPlots(address user) public onlyOwner {
        for (uint8 i = 0; i < 9; i++) {
            farmPlotTimes[user].push(0);
            farmPlotTypes[user].push(0);
        }
    }

    // Function to set a farm plot time by index
    function setFarmPlot(address user, uint8 index, uint8 plotType) public onlyOwner {
        if (index >= farmPlotTimes[user].length) createPlayerFarmPlots(user);
        FarmPlot memory plot = getFarmPlots(user)[index];
        if (plot.time != 0) revert FarmPlotAlreadySet();
        farmPlotTimes[user][index] = block.timestamp;
        farmPlotTypes[user][index] = plotType;
    }

    function chargeNextCampaign(uint256 amount) public onlyOwner {
        if (nextCampaignIndex >= campaigns.length) revert NoCampaignsAvailable();
        if (amount > campaigns[nextCampaignIndex].amount) {
            nextCampaignIndex++;
        }
        campaigns[nextCampaignIndex].amount = amount;
    }

    function setRiceSupply(address user, uint256 amount) public onlyOwner {
        riceSupply[user] = amount;
    }

    // Function to return the first campaign from the campaigns array
    function getNextCampaign() public view returns (Campaign memory) {
        if (nextCampaignIndex >= campaigns.length) revert NoCampaignsAvailable();
        return campaigns[nextCampaignIndex];
    }

    function getFarmPlots(address user) public view returns (FarmPlot[] memory) {
        FarmPlot[] memory plots = new FarmPlot[](9);
        if (farmPlotTimes[user].length == 0) {
            return plots;
        }
        for (uint256 i = 0; i < 9; i++) {
            uint256 time = farmPlotTimes[user][i];
            uint8 plotType = farmPlotTypes[user][i];
            plots[i] = FarmPlot(time, plotType);
        }
        return plots;
    }

    function getRiceSupply(address user) public view returns (uint256) {
        return riceSupply[user];
    }
}
