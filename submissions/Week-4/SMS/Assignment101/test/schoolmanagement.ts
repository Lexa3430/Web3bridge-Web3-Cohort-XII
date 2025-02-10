import { expect } from "chai";
import { ethers } from "hardhat";
import { SchoolManagement } from "../typechain-types";

describe("SchoolManagement", function () {
  let school: SchoolManagement;
  let owner: any, staff: any, student: any;

  beforeEach(async function () {
    [owner, staff, student] = await ethers.getSigners();

    // Deploy the contract
    const School = await ethers.getContractFactory("SchoolManagement");
    school = await School.deploy();
    await school.waitForDeployment();
  });

  it("Should set the deployer as the principal", async function () {
    expect(await school.principal()).to.equal(owner.address);
  });

  it("Should allow the principal to hire staff", async function () {
    await expect(school.hireStaff(staff.address))
      .to.emit(school, "StaffHired")
      .withArgs(staff.address);

    // Explicitly retrieve staff details from the mapping
    const staffDetails = await school.staff(staff.address);
    expect(staffDetails).to.equal(true); // Ensure the staff is marked as employed
  });

  it("Should not allow non-principal to hire staff", async function () {
    await expect(school.connect(staff).hireStaff(staff.address)).to.be.revertedWith("Only principal action");
  });

  it("Should allow staff to enroll students", async function () {
    await school.hireStaff(staff.address); // Principal hires staff

    await expect(school.connect(staff).enrollStudent(student.address))
      .to.emit(school, "StudentEnrolled")
      .withArgs(student.address);

    const studentDetails = await school.students(student.address);
    expect(studentDetails.isEnrolled).to.equal(true);
  });

  it("Should not allow non-staff to enroll students", async function () {
    await expect(school.connect(student).enrollStudent(student.address)).to.be.revertedWith(" Action by staff Only ");
  });

  it("Should allow enrolled students to pay fees", async function () {
    await school.hireStaff(staff.address);
    await school.connect(staff).enrollStudent(student.address);

    await expect(school.connect(student).payFees({ value: ethers.parseEther("1") }))
      .to.emit(school, "FeesPaid")
      .withArgs(student.address, ethers.parseEther("1"));

    const studentDetails = await school.students(student.address);
    expect(studentDetails.feesPaid).to.equal(ethers.parseEther("1"));
  });

  it("Should not allow unregistered students to pay fees", async function () {
    await expect(school.connect(student).payFees({ value: ethers.parseEther("1") })).to.be.revertedWith("You are not enrolled");
  });

  it("Should return the correct contract balance", async function () {
    await school.hireStaff(staff.address);
    await school.connect(staff).enrollStudent(student.address);
    await school.connect(student).payFees({ value: ethers.parseEther("2") });

    const balance = await ethers.provider.getBalance(school.target);
    expect(balance).to.equal(ethers.parseEther("2"));
  });
});
