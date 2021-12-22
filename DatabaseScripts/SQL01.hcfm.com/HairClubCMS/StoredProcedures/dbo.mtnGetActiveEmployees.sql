CREATE PROCEDURE [dbo].[mtnGetActiveEmployees]
	@EmployeePositionId int = 4, -- default is consultant
	@CenterId int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		datEmployee.[EmployeeGUID]
		,[FirstName]
		,[LastName]
		,[UserLogin]
		,[EmployeeFullNameCalc]
	FROM
		[datEmployee]
		JOIN cfgEmployeePositionJoin
			ON datEmployee.EmployeeGUID = cfgEmployeePositionJoin.EmployeeGUID
	WHERE
		datEmployee.IsActiveFlag = 1
		AND datEmployee.CenterID = @CenterId
		AND cfgEmployeePositionJoin.EmployeePositionID = @EmployeePositionId

END
