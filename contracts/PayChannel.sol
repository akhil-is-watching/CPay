// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


struct PayChannel {
    address payable sender;
    address payable recepient;
    uint256 startTime;
    uint256 expirationTime;
    bytes32 merkleRoot;
}