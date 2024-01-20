//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// TODO: remove
// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
//import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import  "@aave/core-v3/contracts/interfaces/IPool.sol";
import "./LiquidationData.sol";

/**
 * A smart contract that liquidates potisions on Aave v3
 * @author ArbiGHOst
 */
contract GhoLiquidationReceiver is IERC3156FlashBorrower {
    IPool private aavePool;
    address private constant GHO_TOKEN = 0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f;
    address private constant ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Token address

	// Mainnet GhoFlashMinter 0xb639D208Bcf0589D54FaC24E655C79EC529762B8
	constructor(address _aavePoolAddress, address _ghoFlashMintAddress) {
		aavePool = IPool(_aavePoolAddress);
		ghoFlashMinter = IGhoFlashMinter(_ghoFlashMintAddress);
	}

	 function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32) {
        // Ensure the flash loan is only initiated by the Aave Lending Pool
        require(msg.sender == address(aavePool), "Caller is not Aave Lending Pool");

        //TODO liquidation logic
        LiquidationData memory liquidationData = abi.decode(data, (LiquidationData))

        _liquidate(liquidationData)

        // Repay the flash loan
        uint256 totalAmount = amount + fee;
        IERC20(token).approve(address(aavePool), totalAmount);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

	//TODO
    function _liquidate(LiquidationData _liquidationData) internal {
		//TODO Interact with AavePoolV3 Pool
		//  liquidationCall(address collateral, address debt, address user, uint256 debtToCover, bool receiveAToken)

    }

}
