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
    address private initator;

	constructor(address _aavePoolAddress, address _initiator) {
		aavePool = IPool(_aavePoolAddress);
		initator = _initiator;
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
        LiquidationData memory liquidationData = abi.decode(data, (LiquidationData));

        _liquidate(liquidationData);

        // Repay the flash loan
        uint256 totalAmount = amount + fee;
        IERC20(token).approve(address(aavePool), totalAmount);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function _liquidate(LiquidationData memory _liquidationData) internal {
		//TODO Interact with AavePoolV3 Pool
		//  liquidationCall(address collateral, address debt, address user, uint256 debtToCover, bool receiveAToken)
		console.log(_liquidationData.user);
    }
}
