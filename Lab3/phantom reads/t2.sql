USE University
GO

--part 2: phantom read - because T1 has generated a new row while T2 is executing, we will get an extra row in the second select
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
--inserted value does not exist yet
SELECT * FROM Student WHERE sid>8
WAITFOR DELAY '00:00:06'
--we can see the inserted value during the second read
SELECT * FROM Student WHERE sid>8
COMMIT TRAN


--solution: set transaction isolation level to serializable
SET TRAN ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT * FROM Student WHERE sid>8
WAITFOR DELAY '00:00:06'
SELECT * FROM Student WHERE sid>8
COMMIT TRAN


DELETE FROM student WHERE sid>8