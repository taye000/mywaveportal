// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);
    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
     struct Wave {
         address waver; //The address of the user who waved
         string message; //The message the user sent
         uint256 timestamp; //The timstamp when the user waved
     }
     /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
     Wave[] waves;
     /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
     mapping(address => uint256) public lastWavedAt;
    constructor() payable {
        //initial seed %100 makes sure the seed is between 0-99
        seed = (block.timestamp + block.difficulty) % 100;

        console.log("nth smart contract");
    }
    /*
     * Requires a string called _message. This is the message our user
     * sends us from the frontend!
     */
    function wave (string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "wait 15min");
         /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;
        
        totalWaves += 1;
        console.log(msg.sender, " mf has waved with ", _message);
        /*
         * This is where I actually store the wave data in the array.
         */
         waves.push(Wave(msg.sender, _message, block.timestamp));

         //generate new seed for user who waves
         seed = (block.timestamp + block.difficulty) % 100;
         console.log("Random number generated", seed);

        //50% chance of winning
         if(seed <= 50){
             console.log("%s won", msg.sender);

             uint256 prizeAmount = 0.0001 ether;
             require(prizeAmount <= address(this).balance);
             (bool success, ) =(msg.sender).call{value: prizeAmount}("");
             require(success, "Failed to withdraw funds from contract");
         }

         emit NewWave(msg.sender, block.timestamp, _message);
    }
    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
     function getAllWaves() public view returns(Wave[] memory){
         return waves;
     }
    function getTotalWaves () public view returns (uint256) {
        console.log("We have a bunch of waves", totalWaves);
        return totalWaves;
    }
}