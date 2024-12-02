// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract MetaDogeUnityKillTracker is AccessControl {
    // Define a role for bot protection and server-managed wallets
    bytes32 public constant SERVER_ROLE = keccak256("SERVER_ROLE");

    // Struct to store player data
    struct Player {
        uint64 gamesPlayed;  // Number of games played
        uint64 kills;        // Number of kills
        uint64 lastKillTime; // Timestamp of the last kill
    }

    // Mapping to store player data
    mapping(address => Player) public players;

    // Event to log when a kill is recorded
    event KillRecorded(address indexed player, uint64 kills, uint64 timestamp);
   

    // Constructor to set up the initial server role
    constructor(address admin) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setupRole(SERVER_ROLE, admin);
    }

    // Function to record a kill for the player (restricted to SERVER_ROLE)
    function recordKill(address player) external onlyRole(SERVER_ROLE) {
        Player storage playerData = players[player];

        playerData.kills += 1;          // Increment kills
        playerData.lastKillTime = uint64(block.timestamp); // Record kill timestamp

        // Emit event to log the kill
        emit KillRecorded(player, playerData.kills, playerData.lastKillTime);
    }

    // Function to start a game and update games played (restricted to SERVER_ROLE)
    function startGame(address player) external onlyRole(SERVER_ROLE) {
        players[player].gamesPlayed += 1; // Increment games played
        //emit event to start the game
        emit StartedGame(player);
    }

    // Public getters are automatically generated for public variables like `players`
    // No need for custom getter functions
}
