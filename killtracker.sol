// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract MetaDogeUnityKillTracker is AccessControl {
    // Define roles
    bytes32 public constant SERVER_ROLE = keccak256("SERVER_ROLE");
    bytes32 public constant PLAYER_ROLE = keccak256("PLAYER_ROLE");

    // Struct to store player data
    struct Player {
        uint64 gamesPlayed;  // Number of games played
        uint64 kills;        // Number of kills
        uint64 lastKillTime; // Timestamp of the last kill
    }

    // Mapping to store player data
    mapping(address => Player) public players;

    // Events
    event KillRecorded(address indexed player, uint64 kills, uint64 timestamp);
    event StartedGame(address indexed player);
    event PlayerInitialized(address indexed player);

    // Constructor to set up the initial server role
    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(SERVER_ROLE, admin);

        // Make SERVER_ROLE the admin of PLAYER_ROLE
        _setRoleAdmin(PLAYER_ROLE, SERVER_ROLE);
    }

    // Function to whitelist a player (grant PLAYER_ROLE)
    function whitelistPlayer(address player) external onlyRole(SERVER_ROLE) {
        grantRole(PLAYER_ROLE, player);
    }

    // Function to initialize a new player (restricted to PLAYER_ROLE)
    function initializePlayer() external onlyRole(PLAYER_ROLE) {
        require(players[msg.sender].gamesPlayed == 0 && players[msg.sender].kills == 0, "Player already initialized");

        players[msg.sender] = Player({
            gamesPlayed: 0,
            kills: 0,
            lastKillTime: 0
        });

        emit PlayerInitialized(msg.sender);
    }

    // Function to record a kill for the player (restricted to SERVER_ROLE)
    function recordKill(address player) external onlyRole(SERVER_ROLE) {
        require(players[player].gamesPlayed > 0, "Player not initialized");

        Player storage playerData = players[player];
        playerData.kills += 1; // Increment kills
        playerData.lastKillTime = uint64(block.timestamp); // Record kill timestamp

        emit KillRecorded(player, playerData.kills, playerData.lastKillTime);
    }

    // Function to start a game and update games played (restricted to SERVER_ROLE)
    function startGame(address player) external onlyRole(SERVER_ROLE) {
        require(players[player].gamesPlayed > 0 || players[player].kills > 0, "Player not initialized");

        players[player].gamesPlayed += 1; // Increment games played
        emit StartedGame(player);
    }


}
