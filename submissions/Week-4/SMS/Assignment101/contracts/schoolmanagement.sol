// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolManagement {
    address public principal;
    
    
    struct Staff {
        bool isEmployed;
    }
    
    struct Student {
        bool isEnrolled;
        uint256 feesPaid;
    }
    
    mapping(address => Staff) public staff;
    mapping(address => Student) public students;
    
    event StaffHired(address staffAddress);
    event StudentEnrolled(address studentAddress);
    event FeesPaid(address student, uint256 amount);
    
    modifier onlyPrincipal() {
        require(msg.sender == principal, "Only principal action");
        _;
    }
    
    modifier onlyStaff() {
        require(staff[msg.sender].isEmployed, " Action by staff Only ");
        _;
    }
    
    constructor() {
        principal = msg.sender;
    }
    
    function hireStaff(address _staffAddress) external onlyPrincipal {
        staff[_staffAddress] = Staff(true);
        emit StaffHired(_staffAddress);
    }
    
    function enrollStudent(address _studentAddress) external onlyStaff {
        students[_studentAddress] = Student(true, 0);
        emit StudentEnrolled(_studentAddress);
    }
    
    function payFees() external payable {
        require(students[msg.sender].isEnrolled, "You are not enrolled");
        require(msg.value > 0, "Must send ETH to pay fees");
         students[msg.sender].feesPaid += msg.value;
        emit FeesPaid(msg.sender, msg.value);
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}












 