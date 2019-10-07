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
    bool laurated;
    
    Student [] studentsList;
    Class[] classes;
    mapping(address => Student) students;
    //address [] private studentIndex;

    struct Student {
        address studentAddress;
        string studentName;
        uint256 nationalID;
        uint256 numberOfClasses;
        string evaluation;
        bool active;
        bool laurated;
        bool publicCertificate;
    }
    
    struct Class {
        string className;
        string professorName;
        uint256 classDate;
        uint256 classHours;
        uint256 password;
        uint256 studentsInClass;
        bool active;
        mapping (address => Student) attendanceList;
    }
    
    event ClassCreated(uint256 indexed classID, string indexed className);
    event ClassEdited(uint256 indexed classID, string indexed className);
    event ClassOpened(uint256 indexed classID, uint256 now);
    event ClassClosed(uint256 indexed classID, uint256 now);
    event StudentCreated(address indexed studentAddress, uint256 indexed nationalID, string indexed studentName);
    event StudentEdited(address indexed studentAddress, uint256 indexed nationalID, string indexed studentName);
    event AttendanceRegistered(address indexed studentAddress, uint256 indexed classID, uint256 now);
    event AttendanceDeleted(address indexed studentAddress, uint256 indexed classID, uint256 now);
    event StudentLaurated(address indexed studentAddress, string indexed courseName, uint256 indexed nationalID, uint256 now);
    
    constructor(string memory _schoolName, string memory _principalName ) public {
        schoolWallet = msg.sender;
        schoolName = _schoolName;
        principalName = _principalName;
        laurated = false;
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
        address _studentAddress,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        students[_studentAddress].studentAddress = _studentAddress;
        students[_studentAddress].studentName = _studentName;
        students[_studentAddress].nationalID = _nationalID;
        students[_studentAddress].numberOfClasses = 0;
        students[_studentAddress].evaluation = "Curso em Andamento";
        students[_studentAddress].active = true;
        students[_studentAddress].laurated = false;
        numberOfStudents ++;
        emit StudentCreated(_studentAddress , _nationalID, _studentName);
        return true;
    }
    
    
    function editStudent (
        address studentAddress,
        address _studentAddress,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        students[studentAddress].studentAddress = _studentAddress;
        students[studentAddress].studentName = _studentName;
        students[studentAddress].nationalID = _nationalID;
        emit StudentEdited(_studentAddress, _nationalID, _studentName);
        return true;
    }
    
    function disableStudent(address studentAddress) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        students[studentAddress].active = false;
        numberOfStudents = numberOfStudents - 1;
        return true;
    }
    
    function enableStudent(address studentAddress) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        students[studentAddress].active = true;
        numberOfStudents ++;
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
    
    function registerAttendance (address studentAddress, uint256 classID, uint256 _password) public returns(bool) {
        require (msg.sender == students[studentAddress].studentAddress);
        require (classes[classID].active == true);
        require (classes[classID].password == _password);
        Class storage c = classes[classID];
        //if(students[studentAddress] = classes[classID].listaDePresenca) {
                //return false;
            //}
        //c.listOfStudents[c.studentsInClass++] = Student({addr: msg.sender});
        c.studentsInClass ++;
        students[studentAddress].numberOfClasses ++;
        emit AttendanceRegistered(studentAddress, classID, now);
        return true;
    }
    
    function registerAttendanceForAStudent (address studentAddress, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        require (classes[classID].active == true);
        students[studentAddress].numberOfClasses ++;
        //classes.listaDePresenca.push = students[studentAddress].studentWallet;
        emit AttendanceRegistered(studentAddress, classID, now);
        return true;
    }
    
    function deleteAttendance (address studentAddress, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        students[studentAddress].numberOfClasses -= 1;
        //classes.listaDePresenca.push = students[studentAddress].studentWallet;
        Class storage c = classes[classID];
        c.studentsInClass -= 1;
        emit AttendanceDeleted(studentAddress, classID, now);
        return true;
    }
    
    function laurateStudents () public returns(bool)  { 
        require (msg.sender == schoolWallet);
        for (uint i=0; i<studentsList.length; i++) {
            Student memory s = studentsList[studentsList.length-1];
            if (studentsList[studentsList.length-1].numberOfClasses < minimumAchievement) {
                return false;
            }
            if(studentsList[studentsList.length-1].numberOfClasses >= minimumAchievement){
                studentsList[studentsList.length-1].evaluation = "Aprovado";
                studentsList[studentsList.length-1].laurated = true;
                studentsList[studentsList.length-1].publicCertificate = true;
                studentsLaurated ++;
                emit StudentLaurated(studentsList[studentsList.length-1].studentAddress, courseName, studentsList[studentsList.length-1].nationalID , now);
                return true;
            }
        }
        laurated = true;
    }
    
    function anonymizeStudent(address studentAddress) public returns(bool) {
        require (msg.sender == students[studentAddress].studentAddress);
        require (students[studentAddress].laurated == true);
        require (students[studentAddress].publicCertificate == true);
        students[studentAddress].publicCertificate == false;
        return true;
    }
    
    function unanonymizeStudent(address studentAddress) public returns(bool) {
        require (msg.sender == students[studentAddress].studentAddress);
        require (students[studentAddress].laurated == true);
        require (students[studentAddress].publicCertificate == false);
        students[studentAddress].publicCertificate == true;
        return true;
    }
    
    function showDetails() public view returns (string memory, string memory, string memory, string memory, string memory, uint256, uint256, uint256) {
        return(courseName, coordinatorName, local, startDate, finishDate, amountOfHours, totalOfClasses, minimumAchievement);
    }
    
    function showStatus() public view returns (uint256, uint256, uint256, uint256 ) {
        return(numberOfStudents, classesCreated, classesFinished, studentsLaurated);
    }
        
    function showStudent(uint256 studentID) public view returns (address, string memory, uint256, uint256, string memory, bool, bool) {
        Student memory s = studentsList[studentID];
        return(s.studentAddress, s.studentName, s.nationalID, s.numberOfClasses, s.evaluation, s.active, s.laurated);
    }
    
    function showClass(uint256 classID) public view returns (string memory, string memory, uint256, uint256, uint256, uint256, bool) {
        Class memory c = classes[classID];
        return(c.className, c.professorName, c.classDate, c.classHours, c.password, c.studentsInClass, c.active);
    }
    
    function showCertificate(address studentAddress) public view returns (string memory, string memory) {
        Student memory s = students[studentAddress];
        require (students[studentAddress].publicCertificate == true);
        return(s.studentName, s.evaluation);
    }

}
