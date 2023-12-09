// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../PayChannel.sol";

library PayChannelLib {

    function verifyProof(
        PayChannel storage channel,
        bytes32 leaf,
        bytes32[] memory merkleProof
    ) public view returns(bool) {
        bytes32 cHash = leaf;
        for (uint256 i = 0; i < merkleProof.length; i++) {
          if (cHash < merkleProof[i])
            cHash = keccak256(abi.encodePacked(cHash, merkleProof[i]));
          else
            cHash = keccak256(abi.encodePacked(merkleProof[i], cHash));
        }
        return cHash == channel.merkleRoot;
    }

    function expired(PayChannel storage channel) public view returns(bool) {
        return channel.expirationTime <= block.timestamp ? true : false;
    }

}