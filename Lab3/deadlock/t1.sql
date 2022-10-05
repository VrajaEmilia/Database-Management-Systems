USE University
GO

BEGIN TRAN
--exclusive lock on table student
UPDATE student SET FirtName = 'T1' WHERE sid=1;
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T2 already has an exclusive lock on teacher
UPDATE teacher SET FirstName = 'T1' WHERE tid = 1
COMMIT TRAN


