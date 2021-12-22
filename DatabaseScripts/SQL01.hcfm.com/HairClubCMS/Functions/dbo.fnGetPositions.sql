CREATE FUNCTION [dbo].[fnGetPositions](@EmployeeGUID AS UNIQUEIDENTIFIER)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @Positions VARCHAR(MAX) = ''

SELECT @Positions += EmployeePositionDescription
	FROM [cfgEmployeePositionJoin] pj
	INNER JOIN [lkpEmployeePosition] p ON p.EmployeePositionID = pj.EmployeePositionID
	WHERE pj.[EmployeeGUID] = @EmployeeGUID

RETURN @Positions
END
