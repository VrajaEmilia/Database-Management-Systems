USE University
GO
INSERT INTO Student VALUES ('fname','lname',1)
BEGIN TRAN
WAITFOR DELAY '00:00:06'
UPDATE student 
SET gid = 2
WHERE FirtName = 'fname' and LastName='lname'
COMMIT TRAN