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
    function collect() external view override returns (bytes memory) {
        // stateless demo value
        uint256 slashingCount = 5;

        // encode exactly what the responder expects
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

    // Drosera calls this with prior collected bytes
    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        if (data.length == 0) return (false, "");

        bytes memory latest = data[0];

        // decode only what was encoded in collect()
        (
            bytes32 evidence,
            address operator,
            uint256 count,
            uint256 threshold,
            uint256 blockNumber,
            uint256 chainId
        ) = abi.decode(
                latest,
                (bytes32, address, uint256, uint256, uint256, uint256)
            );

        bool trigger = (operator != address(0) && count >= threshold);
        bytes memory payload = trigger ? latest : bytes("");

        return (trigger, payload);
    }
}
