SET TRAN ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT * FROM teacher  --we read uncommited data
WAITFOR DELAY '00:00:05'
--update was rolled back
SELECT * FROM teacher
COMMIT TRAN


--solution: set transaction isolation level to read commited
---we cannot read uncommited data
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM teacher
WAITFOR DELAY '00:00:05'
SELECT * FROM teacher
COMMIT TRAN