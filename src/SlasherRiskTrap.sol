// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);

    function shouldRespond(
        bytes[] calldata data
    ) external pure returns (bool, bytes memory);
}

contract SlasherRiskTrap is ITrap {
    // Demo constants (stateless)
    uint256 constant THRESHOLD = 3;
    address constant OPERATOR = 0x14e424df0c35686CF58fC7D05860689041D300F6;

    // Drosera calls this to collect a payload
    // view because we read block properties
    function collect() external view override returns (bytes memory) {
        uint256 slashingCount = 5; // demo value

        // encode exactly what the responder expects:
        // (bytes32 evidence, address operator, uint256 count, uint256 threshold, uint256 blockNumber, uint256 chainId)
        bytes32 dummyEvidence = keccak256("demo");
        uint256 blockNumber = block.number;
        uint256 chainId = block.chainid;

        return
            abi.encode(
                dummyEvidence,
                OPERATOR,
                slashingCount,
                THRESHOLD,
                blockNumber,
                chainId
            );
    }

    // Planner-safety: guard empty entries and sanity-check payload length before decode
    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        // common planner behaviors: empty array or empty blob entries
        if (data.length == 0 || data[0].length == 0) return (false, bytes(""));

        // sanity-check minimal encoded size (6 x 32 bytes)
        if (data[0].length < 32 * 6) return (false, bytes(""));

        (
            bytes32 evidence,
            address operator,
            uint256 count,
            uint256 threshold,
            uint256 blockNumber,
            uint256 chainId
        ) = abi.decode(
                data[0],
                (bytes32, address, uint256, uint256, uint256, uint256)
            );

        bool trigger = (operator != address(0) && count >= threshold);
        return trigger ? (true, data[0]) : (false, bytes(""));
    }
}
