CREATE OR ALTER PROCEDURE validating_CDC
	@DatabaseName NVARCHAR(256),
	@TableName NVARCHAR(256)
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX);

	-- Check CDC at the database level
	SET @SQL = N'
    USE [' + @DatabaseName + N'];

    IF EXISTS (SELECT 1 FROM sys.databases WHERE name = DB_NAME() AND is_cdc_enabled = 1)
        SELECT ''CDC is enabled on the database level.'' AS Message;
    ELSE
        SELECT ''CDC is NOT enabled on the database level.'' AS Message;

	-- Check CDC at the table level
    IF EXISTS (SELECT 1 FROM cdc.change_tables WHERE source_object_id = OBJECT_ID(''' + @TableName + N'''))
        SELECT ''CDC is enabled on the table level.'' AS Message;
    ELSE
        SELECT ''CDC is NOT enabled on the table level.'' AS Message;
	;'

	EXEC sp_executesql @SQL;

END;
