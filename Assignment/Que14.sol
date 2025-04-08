//Develop a smart contract where clients deposit funds,
//and freelancers receive payments only after the job is completed and approved.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Freelancing {
    enum Status {
        PENDING,
        ACCEPTED,
        COMPLETED,
        APPROVED,
        CLOSED
    }

    struct Project {
        Status stutus;
        string title;
        string desc;
        uint256 amount;
        address owner;
        address payable freelancer;
    }

    mapping(uint256 => Project) projects;
    uint256 projectCount = 0;

    function postJob(
        string memory title,
        string memory desc,
        uint256 amount
    ) public payable {
        require(
            bytes(title).length > 3,
            "Title should be more than 3 characters long."
        );
        require(
            bytes(desc).length > 3,
            "Description should be more than 3 characters long."
        );
        require(amount > 0, "Invalid Amount");
        require(
            msg.value == amount,
            "Project amount doesn't match specified amount."
        );

        projects[projectCount] = Project(
            Status.PENDING,
            title,
            desc,
            amount,
            msg.sender,
            payable(address(0))
        );
        ++projectCount;
    }

    function getJob(uint256 ind)
        public
        view
        returns (
            Status stutus,
            string memory title,
            string memory desc,
            uint256 amount,
            address owner,
            address freelancer
        )
    {
        require(ind < projectCount, "Invalid project !");
        Project memory p = projects[ind];
        return (p.stutus, p.title, p.desc, p.amount, p.owner, p.freelancer);
    }

    function acceptJob(uint256 ind) public {
        require(msg.sender != address(0), "invalid user !");
        require(ind < projectCount, "Invalid project !");

        projects[ind].stutus = Status.ACCEPTED;
        projects[ind].freelancer = payable(msg.sender);
    }

    function completeJob(uint256 ind) public {
        require(msg.sender != address(0), "invalid user !");
        require(ind < projectCount, "Invalid project !");

        projects[ind].stutus = Status.COMPLETED;
    }

    function approveJob(uint256 ind) public payable {
        require(msg.sender != address(0), "invalid user !");
        require(msg.sender == projects[ind].owner, "only owner can approve !");
        require(ind < projectCount, "Invalid project !");

        projects[ind].stutus = Status.APPROVED;
        projects[ind].freelancer.transfer(projects[ind].amount);
    }
}
