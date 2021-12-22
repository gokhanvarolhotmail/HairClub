/* CreateDate: 04/14/2009 07:33:54.650 , ModifyDate: 02/27/2017 09:49:16.077 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaEmployeeFindRecords

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		4/10/09

LAST REVISION DATE: 	4/10/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Find all records associated with an Employee by either
		UserLogin or EmployeeGUID
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaEmployeeFindRecords 'smuchnik', NULL
     -- or --
dbaEmployeeFindRecords NULL, 'CAC5C05D-95CC-4492-9DAF-6A62A81408C6'

***********************************************************************/

CREATE PROCEDURE dbaEmployeeFindRecords
	@UserLogin nvarchar(50) = NULL,
	@EmployeeGUID uniqueidentifier = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT 'datEmployee', *
	FROM datEmployee b
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'cfgEmployeePosition', *
	FROM cfgEmployeePositionJoin a
		INNER JOIN datEmployee b ON a.EmployeeGUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)


	SELECT 'datSalesOrder', *
	FROM datSalesOrder a
		INNER JOIN datEmployee b ON a.EmployeeGUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'datSalesOrderDetail Emp1', *
	FROM datSalesOrderDetail a
		INNER JOIN datEmployee b ON a.Employee1GUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'datSalesOrderDetail Emp2', *
	FROM datSalesOrderDetail a
		INNER JOIN datEmployee b ON a.Employee2GUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'datSalesOrderDetail Emp3', *
	FROM datSalesOrderDetail a
		INNER JOIN datEmployee b ON a.Employee3GUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'datSalesOrderDetail Emp4', *
	FROM datSalesOrderDetail a
		INNER JOIN datEmployee b ON a.Employee4GUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'datAppointmentEmployee', *
	FROM datAppointmentEmployee a
		INNER JOIN datEmployee b ON a.EmployeeGUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

	SELECT 'datSchedule', *
	FROM datSchedule a
		INNER JOIN datEmployee b ON a.EmployeeGUID = b.EmployeeGUID
	WHERE (NOT @UserLogin IS NULL AND b.UserLogin = @UserLogin) OR (NOT @EmployeeGUID IS NULL AND b.EmployeeGUID = @EmployeeGUID)

END
GO
