// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract TransparentDonation {
struct Donation {
address donor;
uint256 amount;
uint256 timestamp;
}


address public immutable beneficiary;
Donation[] private _donations;
mapping(address => uint256) public totalDonatedBy;


event DonationReceived(address indexed donor, uint256 amount, uint256 timestamp);
event Withdraw(address indexed to, uint256 amount);


constructor(address _beneficiary) {
require(_beneficiary != address(0), "Invalid beneficiary");
beneficiary = _beneficiary;
}


function donate() public payable {
require(msg.value > 0, "Zero value");
_donations.push(Donation({ donor: msg.sender, amount: msg.value, timestamp: block.timestamp }));
totalDonatedBy[msg.sender] += msg.value;
emit DonationReceived(msg.sender, msg.value, block.timestamp);
}


function getDonationCount() external view returns (uint256) {
return _donations.length;
}


function getDonations(uint256 start, uint256 count) external view returns (Donation[] memory slice) {
uint256 len = _donations.length;
require(len == 0 || start < len, "start out of range");
uint256 end = start + count;
if (end > len) end = len;
uint256 outLen = (end > start) ? end - start : 0;
slice = new Donation[](outLen);
for (uint256 i = 0; i < outLen; i++) {
slice[i] = _donations[start + i];
}
}


function withdrawAll() external {
require(msg.sender == beneficiary, "Only beneficiary");
uint256 bal = address(this).balance;
require(bal > 0, "No balance");
(bool ok, ) = payable(beneficiary).call{value: bal}("");
require(ok, "Withdraw failed");
emit Withdraw(beneficiary, bal);
}


receive() external payable { donate(); }
}