
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const CharityDonationModule = buildModule("CharityDonationModule", (m) => {

  const lock = m.contract("CharityDonation", ["taiwo"]);

  return { lock };
});

export default CharityDonationModule;
