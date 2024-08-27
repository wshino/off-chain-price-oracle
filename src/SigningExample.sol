// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { MessageHashUtils } from "@openzeppelin-contracts-5.0.2/utils/cryptography/MessageHashUtils.sol";
import { ECDSA } from "@openzeppelin-contracts-5.0.2/utils/cryptography/ECDSA.sol";
import { Strings } from "@openzeppelin-contracts-5.0.2/utils/Strings.sol";

contract SigningExample {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;
    using Strings for string;

    function isValidOraclePrice(
        string memory ticker, 
        uint256 priceRatio,
        uint256 timestamp, 
        bytes memory signature) public view returns (bool) {
        
        if(timestamp < block.timestamp - 1 hours) {
            return false;
        }

        if(!ticker.equal("MATIC")) {
            return false;
        }

        bytes32 hash = keccak256(abi.encodePacked(ticker, priceRatio, timestamp));
        bytes32 signedHash = hash.toEthSignedMessageHash();
        return signedHash.recover(signature) == msg.sender;
    }

}