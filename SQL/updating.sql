CREATE OR ALTER PROCEDURE Updating
	@StartID INT, -- from which ID we start
	@RowCount INT -- how many rows would you like to update 
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE fromTable 
	SET Name = CONCAT('UPDATED_User_', ID) -- new Name will look like : UPDATED_USER_1
	WHERE ID BETWEEN @StartID AND (@StartID + @RowCount - 1); -- our update range - from start to an end


END;
