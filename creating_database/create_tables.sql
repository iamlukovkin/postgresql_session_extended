CREATE TABLE Student (
	studCode INT NOT NULL PRIMARY KEY,
	studFirstName VARCHAR(20) NOT NULL,
	studLastName VARCHAR(25) NOT NULL,
	studSurname VARCHAR(20),
	studBirthday DATE,
	studGrant money
);
CREATE TABLE Subject (
	subCode INT NOT NULL PRIMARY KEY,
	subName VARCHAR(50) NOT NULL,
	subHour INT NOT NULL CHECK  (subHour BETWEEN 8 AND 512),
	subSemester INT NOT NULL CHECK (subSemester BETWEEN 1 AND 12)
);
CREATE TABLE Teacher (
	teacherCode INT NOT NULL PRIMARY KEY,
	teacherFirstName VARCHAR(20) NOT NULL,
	teacherLastName VARCHAR(25) NOT NULL,
	teacherSurname VARCHAR(20),
	teacherDepartment INT,
	academicTitle VARCHAR(20),
	teacherPost VARCHAR(25)
);
CREATE TABLE Department (
	depCode INT NOT NULL PRIMARY KEY,
	depName VARCHAR(50) NOT NULL UNIQUE,
	depManager INT
);
ALTER TABLE Teacher
    ADD CONSTRAINT FK_Teacher_Department
        FOREIGN KEY (teacherDepartment)
            REFERENCES Department(depCode)
;
alter table Department
    ADD CONSTRAINT FK_DepartmentManager_Teacher
        FOREIGN KEY (depManager)
            REFERENCES Teacher(teacherCode)
;
CREATE TABLE Class (
	classCode VARCHAR(6) NOT NULL PRIMARY KEY,
	classTeacher INT,
	classDepartment INT
);
ALTER TABLE Class
    ADD CONSTRAINT FK_Department_Class
        FOREIGN KEY (classDepartment)
            REFERENCES Department(depCode)
;
ALTER TABLE Class
    ADD CONSTRAINT FK_Teacher_Class
        FOREIGN KEY (classTeacher)
            REFERENCES Teacher(teacherCode)
;
CREATE TABLE m2mStudentClass (
	student INT,
	class VARCHAR(6),
	dateStart DATE,
	dateEnd DATE,
	CONSTRAINT PK_Student_Class
	    PRIMARY KEY (student, class)
);
alter table m2mStudentClass
    ADD CONSTRAINT FK_m2mStudentClass_Class
        FOREIGN KEY (class)
            REFERENCES Class(classCode)
;
ALTER TABLE m2mStudentClass
    ADD CONSTRAINT FK_m2mStudentClass_Student
        FOREIGN KEY (student)
            REFERENCES Student(studCode)
;
CREATE TABLE Session (
	student INT,
	subject INT,
	teacher INT,
	examDate DATE,
	mark INT NOT NULL CHECK (mark BETWEEN 2 AND 5),
	CONSTRAINT PK_Session
	    PRIMARY KEY (student, subject, examDate)
);
ALTER TABLE Session
    ADD CONSTRAINT FK_Session_Student
        FOREIGN KEY (student)
            REFERENCES Student(studCode)
;
ALTER TABLE Session
    ADD CONSTRAINT FK_Session_Subject
        FOREIGN KEY (subject)
            REFERENCES Subject(subCode)
;
ALTER TABLE Session
    ADD CONSTRAINT FK_Session_Teacher
        FOREIGN KEY (teacher)
            REFERENCES Teacher(teacherCode)
;