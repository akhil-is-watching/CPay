// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface ICPayChannel {

    function initializeChannel(
        address payable _sender,
        address payable _recepient,
        uint256 _timeout,
        bytes32 _merkleRoot 
    ) external;


    function closeChannel(
        uint256 _amount,
        bytes32[] memory _merkleProof
    ) external;

    function expireChannel() external;

    function sender() external view returns(address);

    function recepient() external view returns(address);
    
    function balance() external view returns(uint256);
}