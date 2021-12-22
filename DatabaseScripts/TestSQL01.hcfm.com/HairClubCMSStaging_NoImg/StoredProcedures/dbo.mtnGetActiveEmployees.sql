/* CreateDate: 02/18/2013 06:45:39.233 , ModifyDate: 02/27/2017 09:49:19.793 */
GO
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
GO
