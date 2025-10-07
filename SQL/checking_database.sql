CREATE OR ALTER PROCEDURE check_source_database
	@DatabaseName NVARCHAR(128)
AS
BEGIN
	-- Checking whether the source database & table exist
	IF EXISTS(SELECT * FROM master.sys.databases WHERE name= @DatabaseName)
	BEGIN
		PRINT 'Database exists!';
		RETURN 0;
	END
	ELSE
	BEGIN
		PRINT 'Database doesn''t exists!'
		RETURN 5;
	END
END;
