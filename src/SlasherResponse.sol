// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SlasherResponse {
    event SlashingAlert(
        bytes32 evidence,
        address operator,
        uint256 count,
        uint256 threshold,
        uint256 blockNumber,
        uint256 chainId
    );

    function respond(bytes calldata payload) external {
        (
            bytes32 ev,
            address op,
            uint256 count,
            uint256 th,
            uint256 bn,
            uint256 cid
        ) = abi.decode(
                payload,
                (bytes32, address, uint256, uint256, uint256, uint256)
            );

        emit SlashingAlert(ev, op, count, th, bn, cid);
    }
}
