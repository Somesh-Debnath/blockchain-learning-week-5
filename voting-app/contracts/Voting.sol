// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract VotingSystem {

    // state variables
    address public owner;
    string[] public candidates;
    mapping(address => bool) public voters;
    mapping(uint256 => uint256) public votesReceived;

    // event to be emitted when a voter votes
    event Voted(address indexed voter, uint256 candidateIndex);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
    }

    // function to vote for a candidate
    function vote(uint256 candidateIndex) external {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(!voters[msg.sender], "You have already voted");

        voters[msg.sender] = true;
        votesReceived[candidateIndex]++;
        
        emit Voted(msg.sender, candidateIndex);
    }

    function getTotalVotes(uint256 candidateIndex) external view returns (uint256) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        return votesReceived[candidateIndex];
    }

    // function to check if a voter has voted
    function hasVoted(address voter) external view returns (bool) {
        return voters[voter];
    }

    function addCandidate(string memory candidateName) external onlyOwner {
        candidates.push(candidateName);
    }

    function getCandidates() external view returns (string[] memory) {
        return candidates;
    }

    // function to remove a candidate   
    function removeCandidate(uint256 candidateIndex) external onlyOwner {
        require(candidateIndex < candidates.length, "Invalid candidate index"); 
        // moving the last candidate to the removed position and then pop the last element 
        candidates[candidateIndex] = candidates[candidates.length - 1];
        candidates.pop();
    }

}
