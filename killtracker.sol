// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MetaDogeUnity_KillTracker {

    // Struct to store player data
    struct Player {
        uint256 kills;
        uint256 lastKillTime;
    }

    // Mapping to store player data
    mapping(address => Player) public players;

    // Event to log when a kill is recorded
    event KillRecorded(address indexed player, uint256 kills, uint256 timestamp);

    // Function to record a kill for the player
    function recordKill() external {
        players[msg.sender].kills += 1; // Increment kills
        players[msg.sender].lastKillTime = block.timestamp; // Record kill timestamp
        
        // Emit event to log the kill
        emit KillRecorded(msg.sender, players[msg.sender].kills, block.timestamp);
    }

    // Function to get the total kills of a player
    function getKills(address player) external view returns (uint256) {
        return players[player].kills;
    }

    // Function to get the last kill time of a player
    function getLastKillTime(address player) external view returns (uint256) {
        return players[player].lastKillTime;
    }
}

