// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ETHicalRice {
    // Owner of the contract
    address public owner;

    // Define errors
    error NotAuthorized();
    error IndexOutOfBounds();
    error NoCampaignsAvailable();

    // Define the Campaign struct
    struct Campaign {
        string name;
        string description;
        uint256 amount;
    }

    // Array of Campaigns
    Campaign[] public campaigns;

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

    // Function to set a farm plot time by index
    function setFarmPlotTime(uint256 index, uint256 time) public onlyOwner {
        if (index >= farmPlotTimes[msg.sender].length) revert IndexOutOfBounds();
        farmPlotTimes[msg.sender][index] = time;
    }

    // Function to set a farm plot type by index
    function setFarmPlotType(uint256 index, uint8 plotType) public onlyOwner {
        if (index >= farmPlotTypes[msg.sender].length) revert IndexOutOfBounds();
        farmPlotTypes[msg.sender][index] = plotType;
    }

    // Function to return the first campaign from the campaigns array
    function getNextCampaign() public view returns (Campaign memory) {
        if (campaigns.length == 0) revert NoCampaignsAvailable();
        return campaigns[0];
    }
}
