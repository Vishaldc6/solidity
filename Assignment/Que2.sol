//Develop a smart contract that allows one to rent a hotel room.
//It allows someone to make a payment for a room if the room is vacant.
//After payment is made to the contract, the funds are sent to the owner.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HotelBooking {
    address payable manager;

    struct Room {
        uint256 id;
        address owner;
        bool isVacant;
        uint256 amount;
    }

    uint256 FIXED_AMOUNT = 20;
    mapping(uint256 => Room) rooms;
    uint256 roomCount = 0;

    constructor() {
        manager = payable(msg.sender);
    }

    modifier onlyManager() {
        require(msg.sender==manager,"only manager");
        _;
    }

    function addRoom() public onlyManager() {
        rooms[roomCount] = Room(roomCount, address(0), true, FIXED_AMOUNT);
        ++roomCount;
    }

    modifier validRoom(uint _i) {
        require(_i < roomCount, "invalid room");
        _;
    }

    function getRoom(uint ind)
        public
        view
        validRoom(ind)
        returns (
            uint256 id,
            address owner,
            bool isVacant_,
            uint256 amount_
        )
    {
        return (
            rooms[ind].id,
            rooms[ind].owner,
            rooms[ind].isVacant,
            rooms[ind].amount
        );
    }

    function bookRoom(uint ind) public validRoom(ind) {
        require(rooms[ind].isVacant, "Room is not vacant");
    
        rooms[ind].owner = msg.sender;
        rooms[ind].isVacant = false;
    }

    function checkOut(uint ind) public payable validRoom(ind){
        require(msg.value==rooms[ind].amount,"Invalid amount");
        require(!rooms[ind].isVacant,"room is not booked");
        rooms[ind].owner = address(0);
        rooms[ind].isVacant = true;
    }

    function managerPaid() public payable onlyManager() {
        manager.transfer(address(this).balance);
    }

}
