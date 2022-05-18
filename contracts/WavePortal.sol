// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

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
    constructor() payable {
        console.log("nth smart contract");
    }
    /*
     * Requires a string called _message. This is the message our user
     * sends us from the frontend!
     */
    function wave (string memory _message) public {
        totalWaves += 1;
        console.log(msg.sender, " mf has waved with ", _message);
        /*
         * This is where I actually store the wave data in the array.
         */
         waves.push(Wave(msg.sender, _message, block.timestamp));

         emit NewWave(msg.sender, block.timestamp, _message);
         uint256 prizeAmount = 0.0001 ether;
         //Trying to send more ether than the account has
         //require is like a fancy if statement
         require(prizeAmount <= address(this).balance); 
         (bool success, ) = (msg.sender).call{value: prizeAmount}("");
         require(success, "Failed to withdraw ether from account");
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