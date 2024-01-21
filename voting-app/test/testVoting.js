const { expect } = require('chai');
const { ethers } = require('hardhat');

describe("VotingSystem", function () {

    let VotingSystem;
    let votingSystem;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
      [owner, addr1, addr2] = await ethers.getSigners();
  
      VotingSystem = await ethers.getContractFactory("VotingSystem");
      votingSystem = await VotingSystem.deploy(["Candidate 1", "Candidate 2"]);
    });

    it("should initialize correctly", async function () {
        expect(await votingSystem.owner()).to.equal(owner.address);
        expect(await votingSystem.candidates(0)).to.equal("Candidate 1");
        expect(await votingSystem.candidates(1)).to.equal("Candidate 2");
    });

    it("should allow voting and update totals", async function () {
        await votingSystem.connect(addr1).vote(0);
        expect(await votingSystem.hasVoted(addr1.address)).to.be.true;
        expect(await votingSystem.getTotalVotes(0)).to.equal(1);

        await votingSystem.connect(addr2).vote(1);
        expect(await votingSystem.hasVoted(addr2.address)).to.be.true;
        expect(await votingSystem.getTotalVotes(1)).to.equal(1);
    });

    it("should prevent double voting", async function () {
        await votingSystem.connect(addr1).vote(0);
        await expect(votingSystem.connect(addr1).vote(1)).to.be.revertedWith("You have already voted");
    });

    it("should only allow the owner to add or remove candidates", async function () {
        await votingSystem.connect(owner).addCandidate("New Candidate");
        expect(await votingSystem.candidates(2)).to.equal("New Candidate");

        await votingSystem.connect(owner).removeCandidate(0);
        expect(await votingSystem.candidates(0)).to.equal("New Candidate");

        await expect(votingSystem.connect(addr1).addCandidate("Candidate 3")).to.be.revertedWith(
            "Only the owner can call this function"
        );

        await expect(votingSystem.connect(addr1).removeCandidate(0)).to.be.revertedWith(
            "Only the owner can call this function"
        );
    });
});
