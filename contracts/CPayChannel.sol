// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./PayChannel.sol";
import "./libraries/PayChannelLib.sol";

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract CPayChannel is Initializable {
    using PayChannelLib for PayChannel;

    PayChannel private channel;


    modifier onlyRecepient() {
        require(msg.sender == channel.recepient, "ERR: NOT RECEPIENT");
        _;
    }

    modifier onlySender() {
        require(msg.sender == channel.sender, "ERR: NOT SENDER");
        _;
    }
    
    function initializeChannel(
        address payable _sender,
        address payable _recepient,
        uint256 _timeout,
        bytes32 _merkleRoot 
    ) public payable initializer {
        require(msg.value>0, "ERR: 0 BALANCE CHANNEL INITIALIZE INVALID");
        channel.sender = _sender;
        channel.recepient = _recepient;
        channel.startTime = block.timestamp;
        channel.expirationTime = block.timestamp + _timeout;
        channel.merkleRoot = _merkleRoot;
    }

    function closeChannel(
        uint256 _amount,
        bytes32[] memory _merkleProof
    ) public onlyRecepient{
        bytes32 cHash = keccak256(abi.encodePacked(_amount));
        require(channel.verifyProof(cHash, _merkleProof), "ERR: INVALID PROOF");
        channel.recepient.transfer(_amount);
        selfdestruct(channel.sender);
    }

    function expireChannel() external onlySender {
        require(channel.expired(), "ERR: CHANNEL EXPIRATION PERIOD NOT OVER");
        selfdestruct(channel.sender);
    }

    function sender() public view returns(address) {
        return channel.sender;
    }

    function recepient() public view returns(address) {
        return channel.recepient;
    }


    function balance() public view returns(uint256) {
        return address(this).balance;
    }
}