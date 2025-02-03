// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IETHicalRice {
    error NotAuthorized();
    error NoCampaignsAvailable();
    error FarmPlotAlreadySet();

    struct Campaign {
        string name;
        string description;
        uint256 amount;
    }

    struct FarmPlot {
        uint256 time;
        uint8 plotType;
    }

    function addCampaign(string memory name, string memory description, uint256 amount) external;

    function setFarmPlot(address user, uint256 index, uint8 plotType) external;

    function chargeNextCampaign(uint256 amount) external;

    function getNextCampaign() external view returns (Campaign memory);

    function getFarmPlot(address user, uint256 index) external view returns (FarmPlot memory);
}
