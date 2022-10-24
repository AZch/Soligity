// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {

    function getPriceFeed() internal pure returns(AggregatorV3Interface) {
        return AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
    }

    function getPrice() internal view returns(uint256) {
        (,int256 price,,,) = getPriceFeed().latestRoundData();
        return uint256(price * 1e10);
    }

    function getConvertionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUsd;
    }
}
