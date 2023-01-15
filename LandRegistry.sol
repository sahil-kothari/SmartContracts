pragma solidity ^0.8.0;

contract LandRegistry {
    mapping (address => uint256) public landOwnership;
    event LandTransaction(address indexed from, address indexed to, uint256 value);

    function registerLand(uint256 landId) public {
        require(landOwnership[msg.sender] == 0, "You already own land.");
        landOwnership[msg.sender] = landId;
        emit LandTransaction(address(0), msg.sender, landId);
    }

    function transferLand(address to, uint256 landId) public {
        require(landOwnership[msg.sender] == landId, "You do not own this land.");
        require(to != address(0), "Cannot transfer land to address 0.");
        landOwnership[to] = landId;
        landOwnership[msg.sender] = 0;
        emit LandTransaction(msg.sender, to, landId);
    }
}