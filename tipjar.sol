// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;

contract tips {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // 1. Put fund in smart contract

    function addtips() public payable {}

    // 2. View balance

    function viewtips() public view returns (uint) {
        return address(this).balance;
    }
}
