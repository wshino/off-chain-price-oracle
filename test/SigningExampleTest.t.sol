// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import { MessageHashUtils } from "@openzeppelin-contracts-5.0.2/utils/cryptography/MessageHashUtils.sol";
import { SigningExample } from "../src/SigningExample.sol";

contract SigningExampleTest is Test {
    using MessageHashUtils for bytes32;

    SigningExample public signingExample;

    uint256 internal signerPrivateKey;

    function setUp() public {
        vm.warp(1714963200);
        signingExample = new SigningExample();

        signerPrivateKey = 0xabc123;
    }

    function test_isValidOraclePrice() public {
        address signer = vm.addr(signerPrivateKey);

        string memory ticker = "MATIC";
        uint256 priceRatio = 10;
        uint256 timestamp = block.timestamp;

        vm.startPrank(signer);
        bytes32 digest = keccak256(abi.encodePacked(ticker, priceRatio,timestamp)).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v); // note the order here is different from line above.
        vm.stopPrank();

        // vm.startPrank(user);
        // Give the user some ETH, just for good measure
        // vm.deal(user, 1 ether);

        signingExample.isValidOraclePrice(
            ticker,
            priceRatio,
            timestamp,
            signature
        );
        vm.stopPrank();
    }
}