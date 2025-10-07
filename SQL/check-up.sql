CREATE OR ALTER PROCEDURE check_source_database
	@DatabaseName NVARCHAR(128),
	@SourceTableName NVARCHAR(128),
	@DestinationTableName NVARCHAR(128)
AS
BEGIN
	-- Checking whether the database & tables exist
	IF EXISTS(SELECT * FROM master.sys.databases WHERE name= @DatabaseName)
	BEGIN
		PRINT 'Database exists!';
	END
	ELSE
	BEGIN
		PRINT 'Database doesn''t exists!'
	END

	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @SourceTableName)
	BEGIN
		PRINT 'Source table exists!';
	END
	ELSE
	BEGIN
		PRINT 'Source table doesn''t exist!';
	END

	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @DestinationTableName)
	BEGIN
		PRINT 'Destination table exists!';
	END
	ELSE
	BEGIN
		PRINT 'Destination table doesn''t exist!';
	END
END;
