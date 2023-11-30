import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Arthera Whitepaper", function () {

  async function deployContracts() {
    const [alice, bob] = await ethers.getSigners()
    const uri = "yo"
    const Strat = await ethers.getContractFactory("Strat");
    const nft = await Strat.deploy(uri as any);
    return { nft, alice, bob, uri }
  }

  describe("Deployment", function () {
    it("Should have the right tokenUri", async function () {
      const { nft, alice, uri } = await loadFixture(deployContracts);
      expect(await nft.uri()).to.be.equal(uri)
    })
  })
  describe("Interactions", function () {
    it("Should mint 1 NFT", async function () {
      const { nft, alice } = await loadFixture(deployContracts);
      await nft.safeMint();
      expect(await nft.ownerOf(0)).to.be.equal(alice.address);
    })
    it("Should mint 100 NFTs", async function () {
      const { nft, alice } = await loadFixture(deployContracts);
      for (let i = 0 ; i < 100 ; i++) {
        const mint = await nft.safeMint();
        const mintReceipt = await mint.wait(1);
      }
      expect(await nft.balanceOf(alice.address)).to.be.equal(100);
    })
    it("Should transfer the NFT", async function () {
      const { nft, alice, bob } = await loadFixture(deployContracts);
      await nft.safeMint();
      expect(await nft.ownerOf(0)).to.be.equal(alice.address);
      await nft.connect(alice).transferFrom(alice.address, bob.address, 0);
      expect(await nft.ownerOf(0)).to.be.equal(bob.address);
    })
    it("Should access the Whitepaper", async function () {
      const { nft, alice } = await loadFixture(deployContracts);
      await nft.safeMint();
      expect(await nft.balanceOf(alice.address)).to.be.equal(1);
    })
  })
})