use University

Create table groups(
	gid int IDENTITY(1,1) PRIMARY KEY,
	group_number int unique
)

Create table student(
	sid int IDENTITY(1,1) PRIMARY KEY,
	FirtName varchar(50) not null,
	LastName varchar(50)not null,
	gid int foreign key references groups(gid) not null
)

Create table teacher(
	tid int IDENTITY(1,1) PRIMARY KEY,
	FirtName varchar(50)not null,
	LastName varchar(50)not null,
)

Create table TeacherGroups(
	gid int foreign key references groups(gid),
	tid  int foreign key references teacher(tid),
	coursename varchar(50) not null
)


Insert into groups values
(911),
(912),
(913),
(914)

insert into student values
('James','LastName',1),
('Robert','LastName',2),
('John','LastName',3),
('Michael','LastName',4),
('Mary','LastName',1),
('Jennifer','LastName',2),
('Linda','LastName',3),
('Susan','LastName',4)


Insert into teacher values
('Karen','Teacher'),
('Melissa','Teacher')

Insert into TeacherGroups values
(1,1,'coursename1'),
(1,2,'coursename2'),
(2,1,'coursename2'),
(2,2,'coursename1'),
(3,1,'coursename1'),
(3,2,'coursename2'),
(4,1,'coursename2'),
(4,2,'coursename1')


select * from student
select * from teacher
select * from groups
select * from TeacherGroups


