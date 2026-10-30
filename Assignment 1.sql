------------------------------------------DATABASE----------------------------------------------

DROP TABLE IF EXISTS ENROLLMENTS CASCADE;
DROP TABLE IF EXISTS INSTRUCTORS CASCADE;
DROP TABLE IF EXISTS COURSES CASCADE;
DROP TABLE IF EXISTS STUDENTS CASCADE;
DROP TABLE IF EXISTS DEPARTMENTS cascade;

----------------------------------------TABLE CREATION-------------------------------------------

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID)
        REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID)
        REFERENCES Courses(CourseID)
);

-------------------------------SAMPLE DATA-----------------------------------------


INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Students
(StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(1, 'John',  'Doe',     'john.doe@email.com',       '2000-01-15', '2022-08-01'),
(2, 'Jane',  'Smith',   'jane.smith@email.com',     '1999-05-25', '2021-08-01'),
(3, 'Lucky', 'Dawer',    'Lucky.dawer@gmail.com',   '2004-01-01','2023-01-01');
INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures',     2, 4);

INSERT INTO Instructors
(InstructorID, FirstName, LastName, Email, DepartmentID ,salary) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 70000.00),
(2, 'Bob',   'Lee',     'bob.lee@univ.com',       2, 65000.00);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, 101, '2022-08-01'),
(2, 1, 102, '2022-08-02');

UPDATE Instructors
SET Salary = 70000.00
WHERE InstructorID = 1;

UPDATE Instructors
SET Salary = 65000.00
WHERE InstructorID = 2;

--------------------------------------------------------Assignment 1---------------------------------------------------------------
--1.QUESTIN: Perform CRUD Operations on all tables.
--Create:-
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (3, 'Physics');

INSERT INTO Students
    (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
    (3, 'Sam', 'Patel', 'sam.patel@email.com', '2002-03-10', '2024-08-01');

INSERT INTO Students
(StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(4, 'Lucky', 'Dawer',    'Lucky.dawer@gmail.com',   '2004-01-01','2023-01-01');

INSERT INTO Instructors
    (InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
    (3, 'Riya', 'Shah', 'riya.shah@univ.com', 3);
	
INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits)
VALUES (103, 'Physics Fundamentals', 3, 3);

INSERT INTO Enrollments
    (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
    (3, 3, 103, '2024-08-05');

--READ:-

SELECT * FROM  DEPARTMENTS;
SELECT * FROM STUDENTS;
SELECT * FROM INSTRUCTORS;
SELECT * FROM COURSES;
SELECT * FROM ENROLLMENTS;

--UPDATE:-
update students
set email = 'patel.sam@email.com'
where studentid = 3;

update enrollments
set enrollmentdate = '2021-08-02'
where studentid = 1;

--Delete:-
delete from students
where studentid = 3;

--2.QUESTION: Retrieve students who enrolled after 2022.
select * from students
where (enrollmentdate) >= '2023-01-01';

--3.QUESTION:  Retrieve courses offered by the Mathematics department with a limit of 5 courses?
SELECT c.coursename,
d.departmentid
from courses c.
join departments d on c.departmentid = d.departmentid
where d.departmentname = 'mathematics'
limit  5;

--4.QUQESTION: Get the number of students enrolled in each course, filtering for courses with more than 5 students.
SELECT 
c.courseid,
e.studentid,
c.coursename,
count(distinct e.studentid) as student_number
from courses c
join enrollments e on 
c.courseid = e.courseid
group by c.courseid, e.studentid
having count(distinct e.studentid)>5;

--5.Question: Find students who are enrolled in both Introduction to SQL and Data Structures.
select e.studentid,
s.firstname,
 s.lastname
from  students s
join    enrollments e on e.studentid = s.studentid
join courses c 
on e.courseid = c.courseid
where  c.coursename in ('Introduction to SQL' , 'Data Structures')
group by  e.studentid, s.firstname,s.lastname
having count(DISTINCT C.COURSENAME) = 2;

--6.Question: Find students who are either enrolled in Introduction to SQL or Data Structures.
select e.studentid,
s.firstname,
 s.lastname
from  students s
join    enrollments e on e.studentid = s.studentid
join courses c 
on e.courseid = c.courseid
where  c.coursename in ('Introduction to SQL','Data Structures')
group by  e.studentid, s.firstname,s.lastname;

--7.QUESSTION: Calculate the average number of credits for all courses.
SELECT AVG(CREDITS)
FROM COURSES;

--8.QUESTION: Find the maximum salary of instructors in the Computer Science department.
SELECT d.departmentname,
max(salary)
from instructors i
join departments d on d.departmentid=i.departmentid
where departmentname = 'computer science'
group by d.departmentname;

--9.Question: Count the number of students enrolled in each department.
select
c.departmentid,
count(distinct e.studentid) as total_students
from courses c
join enrollments e on e.courseid = c.courseid
group by c.departmentid;

--10.Question INNER JOIN: Retrieve students and their corresponding courses.
select e.studentid,
s.firstname,
s.lastname,
c.coursename,
c.courseid
from courses c
inner join enrollments e on e.courseid = c.courseid
inner join students s on s.studentid = e.studentid;

--11.Question: LEFT JOIN: Retrieve all students and their corresponding courses, if any.
select 
s.firstname,
s.lastname,
c.coursename
from students s
left join enrollments e on e.studentid= s.studentid
left join  courses c on e.courseid = c.courseid;

--12.qouestion: Subquery: Find students enrolled in courses that have more than 10 students
select * from students
where studentid in (select studentid from enrollments
where courseid in (select courseid from enrollments
group by courseid 
having count(studentid) >10)
);

--13.Extract the year from the EnrollmentDate of students.
select enrollmentdate,
       studentid,
         extract (year from enrollmentdate) as enrollyear
from enrollments;

--14.Concatenate the instructor's first and last name.
select
CONCAT(firstname,' ',lastname) as Full_Name
from instructors;

--15.Calculate the running total of students enrolled in courses.
select studentid,
enrollmentid,
enrollmentdate,
count(*) over(order by studentid,enrollmentdate
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Running_Total
from enrollments;

--16.Label students as 'Senior' or 'Junior' based on their year of enrollment. (If the enrollment date
--is more than 4 years from the current date, put the label 'Senior' otherwise 'Junior')
select enrollmentdate,
studentid,
      case
When enrollmentdate < current_date - interval '4 year'
then 'Senior'
else 'Junior'
end as Job_level
from enrollments;


	  
