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
        for (uint256 i = 0; i < 9; i++) {
            farmPlotTimes[user].push(0);
            farmPlotTypes[user].push(0);
        }
    }

    // Function to set a farm plot time by index
    function setFarmPlot(address user, uint256 index, uint8 plotType) public onlyOwner {
        if (index >= farmPlotTimes[user].length) createPlayerFarmPlots(user);
        FarmPlot memory plot = getFarmPlot(user, index);
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

    // Function to return the first campaign from the campaigns array
    function getNextCampaign() public view returns (Campaign memory) {
        if (nextCampaignIndex >= campaigns.length) revert NoCampaignsAvailable();
        return campaigns[nextCampaignIndex];
    }

    function getFarmPlot(address user, uint256 index) public view returns (FarmPlot memory) {
        uint256 time = farmPlotTimes[user][index];
        if (time == 0) {
            return FarmPlot(0, 0);
        }
        uint8 plotType = farmPlotTypes[user][index];

        return FarmPlot(time, plotType);
    }
}
