USE University
GO
--the row is changed while T2 is in progress, so we will see both values
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
--see first insert
SELECT * FROM student WHERE sid>8
WAITFOR DELAY '00:00:07'
--see updated insert
SELECT * FROM student  WHERE sid>8
COMMIT TRAN



---solution
--set transaction isolation level to repeatable read
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT * FROM student  WHERE sid>8
WAITFOR DELAY '00:00:07'
--now we see the value before the update 
SELECT * FROM student  WHERE sid>8
COMMIT TRAN


DELETE FROM student where sid>8
