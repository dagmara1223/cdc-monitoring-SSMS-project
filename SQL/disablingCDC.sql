CREATE OR ALTER PROCEDURE DisablingCDC
	@TableName SYSNAME -- Table name with enabled CDC - for us : fromTable
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @SchemaName SYSNAME; -- our schema name : dbo
	DECLARE @SQL NVARCHAR(MAX);

	-- our schema and table
	SELECT @SchemaName = s.name 
	FROM sys.tables t -- sys.tables : system table in sql where all user tables are stored
	INNER JOIN sys.schemas s ON t.schema_id = s.schema_id -- sys.schemas is a system table with all schemas i.e: dbo, cdc...
	WHERE t.name = @TableName; -- we join the right schema + table

	-- if there is no schema for our table: 
	IF @SchemaName IS NULL
	BEGIN
		PRINT 'Table ' + @TableName + 'Not found in database: ' + DB_NAME();
		RETURN;
	END

	-- DISABLING CDC for table
	IF EXISTS (SELECT * FROM cdc.change_tables WHERE source_object_id = OBJECT_ID(@SchemaName + '.' + @TableName)) 
	-- if only there is table with enabled cdc -- if the name of our table is inside cdc.change_tables
	BEGIN
        SET @SQL = N'EXEC sys.sp_cdc_disable_table 
                        @source_schema = N''' + @SchemaName + ''', 
                        @source_name = N''' + @TableName + ''', 
                        @capture_instance = N''' + @SchemaName + '_' + @TableName + '''';
        EXEC sp_executesql @SQL;
        PRINT 'CDC disabled for table: ' + @SchemaName + '.' + @TableName;
    END
	ELSE
	-- if not then do nothing, just print following info
	BEGIN
        PRINT 'CDC was not enabled for table: ' + @SchemaName + '.' + @TableName;
    END;

	-- DISABLING CDC FOR DATABASE
	IF EXISTS (SELECT * FROM sys.databases WHERE name = DB_NAME() AND is_cdc_enabled = 1)
	-- if only cdc exists on our database
	BEGIN
		EXEC sys.sp_cdc_disable_db;
        PRINT 'CDC disabled on database: ' + DB_NAME();
	END
	ELSE
	BEGIN
        PRINT 'CDC was already disabled on database: ' + DB_NAME();
    END;
END;
