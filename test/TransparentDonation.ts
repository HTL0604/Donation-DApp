import { expect } from "chai";
import { ethers } from "hardhat";


describe("TransparentDonation", () => {
it("records donations and allows pagination", async () => {
const [owner, user1, user2, beneficiary] = await ethers.getSigners();
const F = await ethers.getContractFactory("TransparentDonation");
const c = await F.deploy(beneficiary.address);
await c.waitForDeployment();


await c.connect(user1).donate({ value: ethers.parseEther("0.1") });
await c.connect(user2).donate({ value: ethers.parseEther("0.2") });


const count = await c.getDonationCount();
expect(count).to.equal(2n);


const start = 0;
const page = await c.getDonations(start, 2);
expect(page[0].donor).to.equal(user1.address);
expect(page[1].donor).to.equal(user2.address);


const totalByU1 = await c.totalDonatedBy(user1.address);
expect(totalByU1).to.equal(ethers.parseEther("0.1"));
});
});