pragma solidity 0.5.11.;

contract LaureaCourse {
    
    address schoolWallet;
    string schoolName;
    string principalName;
    string courseName;
    string coordinatorName;
    string local;
    string startDate;
    string finishDate;
    uint256 amountOfHours;
    uint256 totalOfClasses;
    uint256 minimumAchievement;
    uint256 numberOfStudents;
    uint256 classesCreated;
    uint256 classesFinished;
    uint256 studentsLaurated;
    bool laureated;
    
    Student[] students;
    Class[] classes;
    
    struct Student {
        address studentWallet;
        string studentName;
        uint256 nationalID;
        uint256 numberOfClasses;
        string evaluation;
        bool active;
        bool laurated;
    }
    
    struct Class {
        string className;
        string professorName;
        uint256 classDate;
        uint256 classHours;
        uint256 password;
        uint256 studentsInClass;
        bool active;
        //mapping (uint => Student) listOfStudents;
    }
    
    event ClassCreated(uint256 indexed classID, string indexed className);
    event ClassEdited(uint256 indexed classID, string indexed className);
    event ClassOpened(uint256 indexed classID, uint256 now);
    event ClassClosed(uint256 indexed classID, uint256 now);
    event StudentCreated(uint256 indexed studentID, uint256 indexed nationalID, string indexed studentName);
    event StudentEdited(uint256 indexed studentID, uint256 indexed nationalID, string indexed studentName);
    event AttendanceRegistered(uint256 indexed studentID, uint256 indexed classID, uint256 now);
    event AttendanceDeleted(uint256 indexed studentID, uint256 indexed classID, uint256 now);
    event StudentLaurated(string indexed courseName, uint256 indexed nationalID, uint256 now);
    
    constructor(string memory _schoolName, string memory _principalName ) public {
        schoolWallet = msg.sender;
        schoolName = _schoolName;
        principalName = _principalName;
        laureated = false;
    }
    
    function editCoursesDetails (
        string memory _courseName,
        string memory _coordinatorName,
        string memory _local,
        string memory _startDate,
        string memory _finishDate,
        uint256 _amountOfHours,
        uint256 _numberOfClasses,
        uint256 _minimumAchievement
        ) public 
    {
        require (msg.sender == schoolWallet);
        courseName = _courseName;
        coordinatorName = _coordinatorName;
        local = _local;
        startDate = _startDate;
        finishDate = _finishDate;
        amountOfHours = _amountOfHours;
        totalOfClasses = _numberOfClasses;
        minimumAchievement = _minimumAchievement;
    }
    
    function addClass (
        string memory _className,
        string memory _professorName,
        uint256 _classDate,
        uint256 _classHours, 
        uint256 _password
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Class memory c = Class(_className, _professorName, _classDate, _classHours, _password, 0, false);
        classes.push(c);
        classesCreated ++;
        emit ClassCreated(classes.length-1, _className);
        return true;
    }
    
    function editClass (
        uint256 classID,
        string memory _className,
        string memory _professorName,
        uint256 _classDate,
        uint256 _classHours, 
        uint256 _password
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Class storage c = classes[classID];
        c.className = _className;
        c.professorName = _professorName;
        c.classDate = _classDate;
        c.classHours = _classHours;
        c.password = _password;
        emit ClassEdited(classID, _className);
        return true;
    }
    
    function addStudent (
        address _studentWallet,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Student memory s = Student( _studentWallet, _studentName, _nationalID, 0, "0", true, false);
        students.push(s);
        numberOfStudents ++;
        emit StudentCreated(students.length-1, _nationalID, _studentName);
        return true;
    }
    
    function editStudent (
        uint256 studentID,
        address _studentWallet,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Student storage s = students[studentID];
        s.studentWallet = _studentWallet;
        s.studentName = _studentName;
        s.nationalID = _nationalID;
        emit StudentEdited(studentID, _nationalID, _studentName);
        return true;
    }
    
    function openClass (uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        classes[classID].active = true;
        emit ClassOpened(classID, now);
        return true;
    }
    
    function closeClass (uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        classes[classID].active = false;
        classesFinished ++;
        emit ClassClosed(classID, now);
        return true;
    }
    
    function registerAttendance (uint256 studentID, uint256 classID, uint256 _password) public returns(bool) {
        require (msg.sender == students[studentID].studentWallet);
        require (classes[classID].active == true);
        require (classes[classID].password == _password);
        Class storage c = classes[classID];
        //if(students[studentID] = classes[classID].listaDePresenca) {
                //return false;
            //}
        //c.listOfStudents[c.studentsInClass++] = Student({addr: msg.sender});
        c.studentsInClass ++;
        students[studentID].numberOfClasses ++;
        emit AttendanceRegistered(studentID, classID, now);
        return true;
    }
    
    function registerAttendanceForAStudent (uint256 studentID, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        require (classes[classID].active == true);
        students[studentID].numberOfClasses ++;
        //classes.listaDePresenca.push = students[studentID].studentWallet;
        emit AttendanceRegistered(studentID, classID, now);
        return true;
    }
    
    function deleteAttendance (uint256 studentID, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        students[studentID].numberOfClasses -= 1;
        //classes.listaDePresenca.push = students[studentID].studentWallet;
        Class storage c = classes[classID];
        c.studentsInClass -= 1;
        emit AttendanceDeleted(studentID, classID, now);
        return true;
    }
    
    function laurateStudents () public returns(bool)  { 
        require (msg.sender == schoolWallet);
        for (uint i=0; i<students.length; i++) {
            Student memory s = students[students.length-1];
            if (students[students.length-1].numberOfClasses < minimumAchievement) {
                return false;
            }
            if(students[students.length-1].numberOfClasses >= minimumAchievement){
                students[students.length-1].evaluation = "Aprovado";
                students[students.length-1].laurated = true;
                studentsLaurated ++;
                emit StudentLaurated(courseName, students[students.length-1].nationalID , now);
                return true;
            }
        }
        laureated = true;
    }
    
    function showDetails() public view returns (string memory, string memory, string memory, string memory, string memory, uint256, uint256, uint256) {
        return(courseName, coordinatorName, local, startDate, finishDate, amountOfHours, totalOfClasses, minimumAchievement);
    }
    
    function showStatus() public view returns (uint256, uint256, uint256, uint256 ) {
        return(numberOfStudents, classesCreated, classesFinished, studentsLaurated);
    }
        
    function showStudent(uint256 studentID) public view returns (address, string memory, uint256, uint256, string memory, bool, bool) {
        Student memory s = students[studentID];
        return(s.studentWallet, s.studentName, s.nationalID, s.numberOfClasses, s.evaluation, s.active, s.laurated);
    }
    
    function showClass(uint256 classID) public view returns (string memory, string memory, uint256, uint256, uint256, uint256, bool) {
        Class memory c = classes[classID];
        return(c.className, c.professorName, c.classDate, c.classHours, c.password, c.studentsInClass, c.active);
        
    }
}
