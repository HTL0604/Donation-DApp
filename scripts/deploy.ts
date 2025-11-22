import { ethers } from "hardhat";


async function main() {
const [deployer] = await ethers.getSigners();
console.log("Deploying with:", deployer.address);


const beneficiary = process.env.BENEFICIARY || deployer.address; // default to deployer for demo
const Factory = await ethers.getContractFactory("TransparentDonation");
const contract = await Factory.deploy(beneficiary);
await contract.waitForDeployment();


console.log("TransparentDonation deployed to:", await contract.getAddress());
console.log("Beneficiary:", beneficiary);
}


main().catch((e) => {
console.error(e);
process.exitCode = 1;
});