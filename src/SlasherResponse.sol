// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SlasherResponse {
    event SlashingAlert(
        address indexed operator,
        uint256 slashingCount,
        uint256 threshold,
        string note,
        uint256 timestamp
    );

    // Called by Drosera relay after trap collects payload
    function respondWithSlashingAlert(
        address operator,
        uint256 slashingCount,
        uint256 threshold,
        string calldata note
    ) external {
        emit SlashingAlert(
            operator,
            slashingCount,
            threshold,
            note,
            block.timestamp
        );
    }
}
