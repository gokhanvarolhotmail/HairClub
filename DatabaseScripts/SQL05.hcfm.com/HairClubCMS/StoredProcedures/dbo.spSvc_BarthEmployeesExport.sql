/* CreateDate: 04/06/2015 09:27:41.220 , ModifyDate: 08/07/2018 18:01:00.363 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthEmployeesExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthEmployeesExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthEmployeesExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Employee Data *************************************/
SELECT  ctr.CenterID AS 'CenterSSID'
,		ctr.CenterDescriptionFullCalc AS 'CenterDescription'
,       de.EmployeeGUID AS 'EmployeeSSID'
,       REPLACE(de.EmployeeFullNameCalc, ',', '') AS 'EmployeeFullName'
,       de.FirstName AS 'EmployeeFirstName'
,       de.LastName AS 'EmployeeLastName'
,       de.EmployeeInitials
,       UPPER(LEFT(de.UserLogin, 3)) AS 'CMSEmployeeInitials'
,       de.UserLogin
,       ISNULL(de.EmployeePayrollID, '') AS 'EmployeePayrollID'
,       ISNULL(de.IsActiveFlag, 0) AS 'IsActiveFlag'
FROM    datEmployee de
		INNER JOIN datEmployeeCenter ec
			ON ec.EmployeeGUID = de.EmployeeGUID
		INNER JOIN cfgCenter ctr
			ON ctr.CenterID = ec.CenterID
WHERE	ctr.CenterID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
		AND ec.IsActiveFlag = 1
		AND de.EmployeeGUID NOT IN ( '4BE0D23E-B5A2-44FD-B31F-CBCE7956C360', '4F727A5F-E0B5-4517-B246-305045688366', 'CFFB8225-CEA0-4324-B025-11C7F69653F7' )
ORDER BY ctr.CenterID

END
GO
