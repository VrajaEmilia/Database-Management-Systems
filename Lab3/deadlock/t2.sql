USE University
GO

BEGIN TRAN
-- exclusive lock on table teacher
UPDATE teacher SET FirstName = 'T2' WHERE tid = 1
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T1 already has an exclusive lock on student
UPDATE student SET FirtName = 'T2' WHERE sid = 1
COMMIT TRAN
select * from student
select * from teacher



--one of the transactions will be chosen as the deadlock victim
--solution: set deadlock priority to high
--now, T1 will be chosen as the deadlock victim

SET DEADLOCK_PRIORITY HIGH
BEGIN TRAN

UPDATE teacher SET FirstName = 'T2' WHERE tid = 1
WAITFOR DELAY '00:00:10'

UPDATE student SET FirtName = 'T2' WHERE sid = 1
COMMIT TRAN


UPDATE student set FirtName='James' where sid=1 
UPDATE teacher set FirstName='Karen' where tid=1 