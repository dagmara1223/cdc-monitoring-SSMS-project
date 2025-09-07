-- creating our stored procedure 
CREATE OR ALTER PROCEDURE Inserting
AS 
BEGIN
	SET NOCOUNT ON; -- prevents from sending "rows affected"
	DECLARE @HowManyRows INT = 1000; -- here you specify how many rows would you like to add (!)
	
	DECLARE @i INT = 1;
	DECLARE @MaxID INT; -- it alows us to insert data from current max id so that we can avoid ID PRIMARY KEY WARNINGS
	SELECT @MaxID = ISNULL(MAX(ID), 0) FROM fromTable;

	WHILE @i < @HowManyRows
	BEGIN 
		INSERT INTO fromTable(ID, Name, Age) 
		VALUES
		(
			@MaxID + @i, -- next ID
			CONCAT('User_', @MaxID + @i),
			CAST(RAND(CHECKSUM(NEWID())) * 60 + 18 AS INT) -- random age from range 18 - 78
		);
		SET @i = @i + 1;
	END
END;