import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";
import { AaveV3Sepolia } from "@bgd-labs/aave-address-book";

/**
 * Deploys a contract named "YourContract" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployGhoLiquidator: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  /*
    On localhost, the deployer account is the one that comes with Hardhat, which is already funded.

    When deploying to live networks (e.g `yarn deploy --network goerli`), the deployer account
    should have sufficient balance to pay for the gas fees for contract creation.

    You can generate a random account with `yarn generate` which will fill DEPLOYER_PRIVATE_KEY
    with a random private key in the .env file (then used on hardhat.config.ts)
    You can run the `yarn account` command to check your balance in every network.
  */
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;
  const CUSTOM_PRICE_CONTRACT_SEPOLIA = "0xdd5783BD8634E03A9c2327a7F941131ED46bEc04";
  //NOTE: update as needed to match previous contract
  const CUSTOM_GHO_LIQUIDATION_RECEIVER = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

  await deploy("GhoLiquidator", {
    from: deployer,
    // Contract constructor arguments
    // TODO update with constructor args for chain
    args: [AaveV3Sepolia.POOL, CUSTOM_PRICE_CONTRACT_SEPOLIA, CUSTOM_GHO_LIQUIDATION_RECEIVER],
    log: true,
    // autoMine: can be passed to the deploy function to make the deployment process faster on local networks by
    // automatically mining the contract deployment transaction. There is no effect on live networks.
    autoMine: true,
  });

  // Get the deployed contract to interact with it after deploying.
  const GhoLiquidator = await hre.ethers.getContract<Contract>("GhoLiquidator", deployer);
  console.log("deployed at address: ", await GhoLiquidator.getAddress());
};

export default deployGhoLiquidator;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployGhoLiquidator.tags = ["GhoLiquidator"];
