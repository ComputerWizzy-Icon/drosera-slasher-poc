// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect(
        bytes calldata payload
    ) external returns (address responseContract, bytes memory responsePayload);

    function shouldRespond(bytes calldata payload) external view returns (bool);
}

contract SlasherRiskTrap is ITrap {
    address public owner;
    address public responseContract;

    event ResponseContractUpdated(address indexed newAddress);
    event Collected(address indexed responseContract, bytes payload);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setResponseContract(address _response) external onlyOwner {
        responseContract = _response;
        emit ResponseContractUpdated(_response);
    }

    // Payload: abi.encode(operator, slashingCount, threshold, note)
    function shouldRespond(
        bytes calldata payload
    ) external pure override returns (bool) {
        (address operator, uint256 slashingCount, uint256 threshold, ) = abi
            .decode(payload, (address, uint256, uint256, string));

        return (operator != address(0) && slashingCount >= threshold);
    }

    function collect(
        bytes calldata payload
    ) external override returns (address, bytes memory) {
        require(responseContract != address(0), "response not set");

        (
            address operator,
            uint256 slashingCount,
            uint256 threshold,
            string memory note
        ) = abi.decode(payload, (address, uint256, uint256, string));

        bytes memory callData = abi.encodeWithSignature(
            "respondWithSlashingAlert(address,uint256,uint256,string)",
            operator,
            slashingCount,
            threshold,
            note
        );

        emit Collected(responseContract, callData);
        return (responseContract, callData);
    }
}
