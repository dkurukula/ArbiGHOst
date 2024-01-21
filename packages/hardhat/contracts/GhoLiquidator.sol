//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./IGhoFlashMinter.sol";
import "./LiquidationData.sol";
import "./GhoLiquidationReceiver.sol";

contract GhoLiquidator {
    address public aavePoolAddress;
    IGhoFlashMinter private ghoFlashMinter;
    address public gholiquidationReceiver;

    // Mainnet GHO_TOKEN = 0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f;
    // Mainnet GhoFlashMinter = 0xb639D208Bcf0589D54FaC24E655C79EC529762B8;
    constructor(address _aavePoolAddress, address _ghoFlashMintAddress, address _gholiquidationReceiver) {
        aavePoolAddress = _aavePoolAddress;
        ghoFlashMinter = IGhoFlashMinter(_ghoFlashMintAddress);
        gholiquidationReceiver = _gholiquidationReceiver;
    }

     //TODO find address user contract on AavePoolV3 to liquidate
     //TODO find address collatoralToken to liquidate
     //TODO find find unit amount to liquidate

    function mintAndLiquidate(address _user, address _collatoralToken, uint _amount) public {
        bytes memory data = abi.encode(LiquidationData(_user, _collatoralToken, _amount));

        IERC3156FlashBorrower receiver = IERC3156FlashBorrower(aavePoolAddress);

        ghoFlashMinter.flashLoan(
            receiver,
            address(ghoFlashMinter.GHO_TOKEN()),
            _amount,
            data
        );
    }
}
