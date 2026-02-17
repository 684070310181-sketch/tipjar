// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract Tips {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // ================================
    //            STRUCT
    // ================================

    struct Waitress {
        address payable walletAddress;
        string name;
        uint percent;
    }

    Waitress[] private waitress;

    // ================================
    //           MODIFIER
    // ================================

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    // Reentrancy Guard
    bool private locked;

    modifier noReentrant() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    // ================================
    //        RECEIVE FUND
    // ================================

    function addTips() public payable {
        require(msg.value > 0, "Must send ETH");
    }

    // ================================
    //        VIEW BALANCE
    // ================================

    function viewTips() public view returns (uint) {
        return address(this).balance;
    }

    // ================================
    //        VIEW WAITRESS
    // ================================

    function viewWaitress() public view returns (Waitress[] memory) {
        return waitress;
    }

    // ================================
    //        ADD WAITRESS
    // ================================

    function addWaitress(
        address payable walletAddress,
        string memory name,
        uint percent
    ) public onlyOwner {

        require(walletAddress != address(0), "Invalid address");
        require(percent > 0, "Percent must be greater than 0");

        uint totalPercent = 0;

        for (uint i = 0; i < waitress.length; i++) {

            require(
                waitress[i].walletAddress != walletAddress,
                "Waitress already exists"
            );

            totalPercent += waitress[i].percent;
        }

        require(
            totalPercent + percent <= 100,
            "Total percent cannot exceed 100%"
        );

        waitress.push(Waitress(walletAddress, name, percent));
    }

    // ================================
    //        REMOVE WAITRESS
    // ================================

    function removeWaitress(address walletAddress) public onlyOwner {

        require(waitress.length > 0, "No waitress");

        for (uint i = 0; i < waitress.length; i++) {

            if (waitress[i].walletAddress == walletAddress) {

                waitress[i] = waitress[waitress.length - 1];
                waitress.pop();
                return;
            }
        }

        revert("Waitress not found");
    }

    // ================================
    //      DISTRIBUTE BALANCE
    // ================================

    function distributeBalance()
        public
        onlyOwner
        noReentrant
    {
        uint contractBalance = address(this).balance;

        require(contractBalance > 0, "No money to distribute");
        require(waitress.length > 0, "No waitress");

        uint totalDistributed = 0;

        for (uint i = 0; i < waitress.length; i++) {

            uint amount;

            // คนสุดท้ายรับเงินที่เหลือทั้งหมด
            if (i == waitress.length - 1) {
                amount = contractBalance - totalDistributed;
            } else {
                amount = (contractBalance * waitress[i].percent) / 100;
                totalDistributed += amount;
            }

            _transferFunds(waitress[i].walletAddress, amount);
        }
    }

    // ================================
    //        INTERNAL TRANSFER
    // ================================

    function _transferFunds(address payable recipient, uint amount) internal {

        (bool success, ) = recipient.call{value: amount}("");

        require(success, "Transfer failed");
    }
}
