// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConvertor.sol";

contract FundMe {

    using PriceConvertor for uint256;
    

    uint256 internal minimumUsd = 50 * 1e18;
    address[] funders;
    mapping(address => uint256) addressToAmountFunded;

    function fund() public payable {
        require(msg.value.getConvertionRate() >= minimumUsd, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{ value: address(this).balance }("");
        require(callSuccess, "Withdraw failed");
    }
}
