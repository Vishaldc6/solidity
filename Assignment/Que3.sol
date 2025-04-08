//Develop a smart contract that sends a fixed payment from x address to y regularly on a weekly basis.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Payment {
    address from;
    address to;
    uint amt;
    uint next_time;
    uint interval = 20 seconds;

    constructor(address _from, address _to, uint _amt) {
        from = _from;
        to = _to;
        amt = _amt;
        next_time = block.timestamp + interval;
    }

    function depositAmout() payable public{
        require(msg.value >=amt,"invalid amount !");
    }
    
    function send_payment() public payable {
        require(block.timestamp >= next_time, "cant pay yet !");
        require(address(this).balance >= amt, "no fund !");
        payable(to).transfer(amt);
        next_time += interval;
    }

    function getLastPayment() public view returns (uint) {
        return next_time;
    }
}