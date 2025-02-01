Overview

The CharityDonation smart contract allows users to donate Ether to a charitable cause while keeping track of donor contributions. An admin (the contract deployer) has the ability to withdraw the donated funds.

Features

Donors can contribute Ether to the contract.

Each donor’s total donations and number of donations are tracked.

The admin can withdraw funds.

The contract maintains the total amount donated.

Transparency through public functions and events.

Smart Contract Breakdown

1. Struct: Donor

Stores information about each donor:

amountDonated: Total Ether donated.

donationCount: Number of times they have donated.

2. State Variables

admin: The contract deployer who can withdraw funds.

charityName: Name of the charity.

totalDonations: Total Ether donated.

donors: A mapping of donor addresses to their donation data.

3. Events

DonationReceived: Logs donation activity.

FundsWithdrawn: Logs fund withdrawals by the admin.

4. Modifiers

onlyAdmin: Restricts certain functions to the contract admin.

5. Functions

constructor(string memory _charityName): Initializes the contract with the admin and charity name.

donate() external payable: Allows users to send Ether donations.

withdraw(uint256 _amount) external onlyAdmin: Enables the admin to withdraw funds.

getDonorDetails(address _donor) external view: Retrieves a donor’s donation details.

getTotalFunds() external view: Returns the contract’s balance.

Report: Usage of Concepts

1. Smart Contract Basics

Implemented using Solidity ^0.8.0.

Uses pragma solidity to specify the compiler version.

2. Structs and Mappings

The Donor struct stores donor information.

A mapping(address => Donor) efficiently tracks donations.

3. State Variables & Access Control

admin restricts fund withdrawals to the contract owner.

The onlyAdmin modifier ensures that only the admin can withdraw funds.

4. Ether Transactions

The donate function allows users to send Ether (msg.value).

The withdraw function transfers funds using payable(admin).transfer(_amount).

5. Events for Transparency

Logs donations and withdrawals for better tracking.

6. Getter Functions

Enables retrieval of total funds and individual donor details.