CREATE OR ALTER PROCEDURE EnableCDC
	@TableName SYSNAME -- since we will call this function using : EXEC @TableName = 'fromTable'
AS
BEGIN
	SET NOCOUNT ON;
	-- first, we need to Enable CDC on database (if not enabled already) 
	IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = DB_NAME() AND is_cdc_enabled = 1)
	-- We are creating CDC procedure being logged to CDC_Project database. "WHERE name = DB_NAME()" points to current database.
	BEGIN
		EXEC sys.sp_cdc_enable_db; -- here we are enabling cdc on our data
		PRINT 'cdc enabled on database' + DB_NAME()
	END
	ELSE
	BEGIN
		PRINT 'cdc already enabled on database:' + DB_NAME()
	END

	-- Enabling CDC on table
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL = N'EXEC sys.sp_cdc_enable_table
        @source_schema = N''dbo'',
        @source_name = N''' + @TableName + N''',
        @role_name = NULL,
        @supports_net_changes = 1;';

	EXEC sp_executesql @SQL;

	PRINT 'cdc enabled on table: ' + @TableName ;
END;