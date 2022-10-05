USE University

BEGIN TRAN
UPDATE teacher
SET FirstName = 'New Name' 
WHERE tid = 1
WAITFOR DELAY '00:00:04'
ROLLBACK TRAN

