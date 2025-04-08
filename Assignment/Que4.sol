// Develop a smart contract that accepts the student details such as
// Name, Enrolment_No, Program, Semester, Total Marks.
// Store the necessary and sensitive details on the blockchain so that it can be verified later.
// Include facility to enter the details and also to verify the details.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentVerify {
    address admin;
    
    struct Student {
        string name;
        string enrolment_No;
        string program;
        uint256 semester;
        uint256 total_marks;
    }

    mapping(string => Student) students;

    constructor() {
        admin = msg.sender;
    }

    function addStud(
        string memory name,
        string memory enrolment_No,
        string memory program,
        uint256 semester,
        uint256 total_marks
    ) public {
        require(msg.sender == admin, "only admin can add !");
        students[enrolment_No] = Student(
            name,
            enrolment_No,
            program,
            semester,
            total_marks
        );
    }

    function verifyStudent(string memory enrollmentNo)
        public
        view
        returns (
            string memory name,
            string memory program,
            uint256 semester,
            uint256 total_marks
        )
    {
        return (
            students[enrollmentNo].name,
            students[enrollmentNo].program,
            students[enrollmentNo].semester,
            students[enrollmentNo].total_marks
        );
    }
}
