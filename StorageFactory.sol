// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 index, uint256 number) public {
        simpleStorageArray[index].store(number);
    }

    function sfGet(uint256 index) public view returns(uint256) {
        return simpleStorageArray[index].show();
    }
}
