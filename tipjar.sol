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

    // 3.1 Structure for a Waitress

    struct Waitress {
        address payable walletAddress;
        string name;
        uint percent;
    }

    Waitress[] waitress; // List of all waitresses

    // 5. View waitress

    function viewWaitress() public view returns (Waitress[] memory) {
        return waitress;
    }
}
