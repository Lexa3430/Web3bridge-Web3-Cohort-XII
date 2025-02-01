// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {

    // Define a struct for the donor's information
    struct Donor {
        uint256 amountDonated;
        uint256 donationCount;
    }

    // State variables
    address public admin; // Admin who can withdraw funds
    string public charityName;
    uint256 public totalDonations;

    // Mapping to store donor data (address -> Donor)
    mapping(address => Donor) public donors;

    // Events
    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed admin, uint256 amount);

    // Constructor to initialize the contract with admin and charity name
    constructor(string memory _charityName) {
        admin = msg.sender; // Set the contract deployer as the admin
        charityName = _charityName;
        totalDonations = 0;
    }

    // Modifier to ensure that only the admin can call certain functions
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    // Function for donors to donate ether
    function donate() external payable {
        require(msg.value > 0, "Donation amount must be greater than 0.");

        // Update donor's information
        donors[msg.sender].amountDonated += msg.value;
        donors[msg.sender].donationCount += 1;
        totalDonations += msg.value;

        // Emit event for the donation
        emit DonationReceived(msg.sender, msg.value);
    }

    // Function to allow admin to withdraw funds
    function withdraw(uint256 _amount) external onlyAdmin {
        require(_amount <= address(this).balance, "Insufficient funds in contract.");

        payable(admin).transfer(_amount); // Transfer funds to admin
        emit FundsWithdrawn(admin, _amount);
    }

    // Function to view the donation details of a specific donor
    function getDonorDetails(address _donor) external view returns (uint256, uint256) {
        Donor memory donor = donors[_donor];
        return (donor.amountDonated, donor.donationCount);
    }

    // Function to get the total funds in the contract
    function getTotalFunds() external view returns (uint256) {
        return address(this).balance;
    }
}
