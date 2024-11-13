//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;

contract studentData{
    struct student{
        uint id;
        string name;
        uint age;
        string course;
    }

    student[] public students;


    mapping(uint=>bool) public studentExists;


    fallback() external payable { }

    function addStudent(uint _id,string memory _name, uint _age, string memory _course) public{
        students.push(student(0,"Rahul",25,"Computer Science"));
        studentExists[0] = true;
        require(!studentExists[_id],"Student Id already exists");
        students.push(student(_id,_name,_age,_course));
        studentExists[_id] = true;
    }

    function getStudent(uint index) public view returns (uint, string memory,uint,string memory){
        require(index < students.length,"invalid index");
        student memory s = students[index ];
        return (s.id,s.name,s.age,s.course);

    }

    function getStudentCount() public view returns(uint){
        return students.length;
    }

    receive() external payable { }
}