// Import the necessary modules from Hardhat for testing
const { ethers } = require("hardhat");
const { expect } = require("chai");

// Define the test suite
describe("VotingSystem", function () {
  let votingSystem;
  let owner;
  let voter1;
  let voter2;

  // Deploy the contract before each test
  beforeEach(async function () {
    [owner, voter1, voter2] = await ethers.getSigners();

    const VotingSystem = await ethers.getContractFactory("VotingSystem");
    votingSystem = await VotingSystem.deploy(["Candidate1", "Candidate2"]);
    
  });

  // Test cases for the VotingSystem contract
  it("should initialize correctly", async function () {
    // Check if the owner is set correctly
    expect(await votingSystem.owner()).to.equal(owner.address);

    // Check if the candidates are initialized correctly
    expect(await votingSystem.getCandidates()).to.deep.equal(["Candidate1", "Candidate2"]);
  });

  it("should allow voting", async function () {
    // Voter 1 votes for Candidate 1
    await votingSystem.connect(voter1).vote(0);

    // Check if the vote count for Candidate 1 has increased
    expect(await votingSystem.getTotalVotes(0)).to.equal(1);

  });

  it("should prevent duplicate voting", async function () {
    // Voter 1 votes for Candidate 1
    await votingSystem.connect(voter1).vote(0);

    // Try to vote again with the same address (expecting an error)
    await expect(votingSystem.connect(voter1).vote(0)).to.be.revertedWith("You have already voted");
  });

  it("should allow adding and removing candidates by the owner", async function () {
    // Add a new candidate by the owner
    await votingSystem.connect(owner).addCandidate("Candidate3");

    // Check if the new candidate is added
    expect(await votingSystem.getCandidates()).to.deep.equal(["Candidate1", "Candidate2", "Candidate3"]);

    // Remove Candidate 2 by the owner
    await votingSystem.connect(owner).removeCandidate(1);

    // Check if Candidate 2 is removed
    expect(await votingSystem.getCandidates()).to.deep.equal(["Candidate1", "Candidate3"]);
  });

  it("should prevent non-owner from adding or removing candidates", async function () {
    // Try to add a new candidate without the owner (expecting an error)
    await expect(votingSystem.connect(voter1).addCandidate("InvalidCandidate")).to.be.revertedWith("Only the owner can call this function");

    // Try to remove Candidate 1 without the owner (expecting an error)
    await expect(votingSystem.connect(voter1).removeCandidate(0)).to.be.revertedWith("Only the owner can call this function");
  });
});
