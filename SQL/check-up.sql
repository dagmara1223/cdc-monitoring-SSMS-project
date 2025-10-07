CREATE OR ALTER PROCEDURE check_source_database
	@DatabaseName NVARCHAR(128),
	@SourceTableName NVARCHAR(128),
	@DestinationTableName NVARCHAR(128)
AS
BEGIN
	-- Checking whether the database & tables exist
	IF EXISTS(SELECT * FROM master.sys.databases WHERE name= @DatabaseName)
		PRINT 'Database exists!';
	ELSE
		PRINT 'Database doesn''t exists!'

	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @SourceTableName)
		PRINT 'Source table exists!';
	ELSE
		PRINT 'Source table doesn''t exist!';

	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @DestinationTableName)
		PRINT 'Destination table exists!';
	ELSE
		PRINT 'Destination table doesn''t exist!';
END;
