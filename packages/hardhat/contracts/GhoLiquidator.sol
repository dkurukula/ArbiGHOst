//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./IGhoFlashMinter.sol";
import "./LiquidationData.sol";
import "./GhoLiquidationReceiver.sol";

contract GhoLiquidator {
    address public aavePoolAddress;
    IGhoFlashMinter private ghoFlashMinter;
    address public gholiquidationReceiver;

    constructor(address _aavePoolAddress, address _ghoFlashMintAddress, address _gholiquidationReceiver) {
        aavePoolAddress = _aavePoolAddress;
        ghoFlashMinter = IGhoFlashMinter(_ghoFlashMintAddress);
        gholiquidationReceiver = _gholiquidationReceiver;
    }

     // NOTE: future state
     // find address user contract on AavePoolV3 to liquidate
     // find address collatoralToken to liquidate
     // find find unit amount to liquidate

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
