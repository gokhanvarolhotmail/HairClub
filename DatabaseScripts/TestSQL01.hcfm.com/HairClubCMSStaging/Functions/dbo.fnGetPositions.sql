/* CreateDate: 02/18/2013 06:59:50.620 , ModifyDate: 02/27/2017 09:49:37.690 */
GO
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
GO
