import { expect } from "chai";
import { ethers } from "hardhat";
import { GhoLiquidationReceiver } from "../typechain-types";
import { AaveV3Sepolia } from "@bgd-labs/aave-address-book";

describe("GhoLiquidationReceiver", function () {
  // We define a fixture to reuse the same setup in every test.

  let ghoLiquidationReceiver: GhoLiquidationReceiver;

  const CUSTOM_PRICE_CONTRACT_SEPOLIA = "0xdd5783BD8634E03A9c2327a7F941131ED46bEc04";
  before(async () => {
    const [owner] = await ethers.getSigners();

    const ghoLiquidationReceiverFactory = await ethers.getContractFactory("GhoLiquidationReceiver");
    ghoLiquidationReceiver = (await ghoLiquidationReceiverFactory.deploy(
      AaveV3Sepolia.POOL,
      owner,
      CUSTOM_PRICE_CONTRACT_SEPOLIA,
    )) as GhoLiquidationReceiver;
    await ghoLiquidationReceiver.waitForDeployment();
  });

  describe("Deployment", function () {
    it("should have a valid address", function () {
      const code = ethers.provider.getCode(ghoLiquidationReceiver.getAddress());
      expect(code).to.not.equal("0x");
    });
  });
});
