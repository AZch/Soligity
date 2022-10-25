// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConvertor.sol";

error NotOwner();
error NotEnough();

contract FundMe {

    using PriceConvertor for uint256;

    uint256 internal constant MINIMUM_USD = 50 * 1e18;
    address[] funders;
    mapping(address => uint256) addressToAmountFunded;

    address internal immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable moreThenMinimumFunds {
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{ value: address(this).balance }("");
        require(callSuccess, "Withdraw failed");
    }

    modifier onlyOwner {
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    modifier moreThenMinimumFunds {
        if (msg.value.getConvertionRate() < MINIMUM_USD) { revert NotEnough(); }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
