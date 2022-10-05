--inserts data in tables that are in a m:n relationship; if one insert fails, 
--all the operations performed by the procedure must be rolled back

USE University
GO
CREATE OR ALTER PROCEDURE validateParams (@group_number int, @FirstNameT varchar(50), @LastNameT varchar(50),@courseName varchar(50)) 
AS
	IF (@group_number is null)
	BEGIN
		RAISERROR('group number must not be null', 12, 1);
	END
	IF (LEN(@FirstNameT)<=1)
	BEGIN
		RAISERROR('invalid Teacher First Name', 12, 1);
	END
	IF (LEN(@LastNameT) <=1)
	BEGIN
		RAISERROR('invalid Teacher Last Name', 12, 1);
	END
	IF (LEN(@courseName) <=1)
	BEGIN
		RAISERROR('invalid CourseName', 12, 1);
	END
	IF EXISTS(SELECT gid From groups Where group_number=@group_number)
	BEGIN
		RAISERROR('this group number already exists in the data base', 12, 1);
	END
	
	IF EXISTS(SELECT tid From teacher Where FirstName=@FirstNameT and LastName=@LastNameT)
	BEGIN
		RAISERROR('this teacher already exists in the data base', 12, 1);
	END
GO
GO
CREATE OR ALTER PROCEDURE rollbackInsertGroupTeacher (@group_number int, @FirstNameT varchar(50), @LastNameT varchar(50),@courseName varchar(50)) 
AS
	BEGIN TRANSACTION
	BEGIN TRY
		exec validateParams @group_number,@FirstNameT,@LastNameT,@courseName
		INSERT INTO groups VALUES (@group_number)
		INSERT INTO teacher VALUES (@FirstNameT,@LastNameT)
		DECLARE @gid int
		DECLARE @tid int
		SET @gid = (SELECT gid FROM Groups WHERE group_number=@group_number)
		SET @tid = (SELECT tid FROM teacher Where FirstName=@FirstNameT and LastName=@LastNameT)
		INSERT INTO TeacherGroups VALUES (@gid,@tid,@courseName)
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT(ERROR_MESSAGE())
		RETURN
	END CATCH
GO

--fail
exec rollbackInsertGroupTeacher 911,'name','name','name' ---group is already in db
exec rollbackInsertGroupTeacher 999,'','name','name' ---invalid teacher first name
exec rollbackInsertGroupTeacher 999,'name','','name' ---invalid teacher last name
exec rollbackInsertGroupTeacher 999,'name','name','' ---invalid coursename


SELECT * FROM groups
SELECT * FROM teacher
SELECT * FROM TeacherGroups

--doesn't fail
exec rollbackInsertGroupTeacher 920,'firstname','lastname','coursename'

---save as much data as possible
GO
CREATE OR ALTER PROCEDURE validateGroupData(@group_number int)
AS
	IF (@group_number is null)
	BEGIN
		RAISERROR('group number must not be null', 12, 1);
	END
	IF EXISTS(SELECT gid From groups Where group_number=@group_number)
	BEGIN
		RAISERROR('this group number already exists in the data base', 12, 1);
	END
GO

GO
CREATE OR ALTER PROCEDURE validateTeacherData(@FirstNameT varchar(50), @LastNameT varchar(50))
AS
	IF (LEN(@FirstNameT)<=1)
	BEGIN
		RAISERROR('invalid Teacher First Name', 12, 1);
	END
	IF (LEN(@LastNameT) <=1)
	BEGIN
		RAISERROR('invalid Teacher Last Name', 12, 1);
	END
	IF EXISTS(SELECT tid From teacher Where FirstName=@FirstNameT and LastName=@LastNameT)
	BEGIN
		RAISERROR('this teacher already exists in the data base', 12, 1);
	END
GO

GO
CREATE OR ALTER PROCEDURE noRollbackInserts(@group_number int, @FirstNameT varchar(50), @LastNameT varchar(50),@courseName varchar(50)) 
AS
	DECLARE @errors int
	SET @errors = 0
			BEGIN TRAN
		BEGIN TRY
			exec validateGroupData @group_number
			INSERT INTO groups VALUES (@group_number)
			PRINT('insert into groups')
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			SET @errors=1
			PRINT('cannot insert group:' + ERROR_MESSAGE())
			ROLLBACK TRAN
		END CATCH

		BEGIN TRY
			BEGIN TRAN
			exec validateTeacherData @FirstNameT, @LastNameT
			INSERT INTO teacher VALUES (@FirstNameT,@LastNameT)
			PRINT('insert teacher')
			COMMIT TRAN
		END TRY

		BEGIN CATCH
			SET @errors=1
			PRINT('cannot insert teacher:' + ERROR_MESSAGE())
			ROLLBACK TRAN
		END CATCH
		IF(@errors = 0)
			BEGIN
				BEGIN TRY
					BEGIN TRAN
					IF (LEN(@courseName) <=1)
					BEGIN
					RAISERROR('invalid CourseName', 12, 1);
					END
					DECLARE @gid int
					DECLARE @tid int
					SET @gid = (SELECT gid FROM Groups WHERE group_number=@group_number)
					SET @tid = (SELECT tid FROM teacher Where FirstName=@FirstNameT and LastName=@LastNameT)
					INSERT INTO TeacherGroups VALUES (@gid,@tid,@courseName)
					PRINT('insert into teacher groups')
					COMMIT TRAN
				END TRY
				BEGIN CATCH
					ROLLBACK TRAN
					PRINT('cannot insert into teacherGroups:'+ ERROR_MESSAGE())
					RETURN
				END CATCH
			END
GO


SELECT * FROM groups
SELECT * FROM teacher
SELECT * FROM TeacherGroups

--no fail
exec noRollbackInserts 100,'name','name','coursename'

--fails
exec noRollbackInserts 912,'name1','name1','coursename1' --inserts teacher, but no group (group already in db)
exec noRollbackInserts 101,'','name2','coursename2' --inserts group, but no teacher (teacher name empty)
exec noRollbackInserts 102,'name1','name1','coursename2' --inserts group, but no teacher (teacher already in db)
exec noRollbackInserts 103,'name3','name3','c' --inserts group,teacher but not into TeacherGroups (not a valid coursename)


SELECT * FROM groups
SELECT * FROM teacher
SELECT * FROM TeacherGroups

DELETE FROM TeacherGroups WHERE gid>4
DELETE FROM teacher WHERE tid>2
DELETE FROM groups WHERE gid>4




