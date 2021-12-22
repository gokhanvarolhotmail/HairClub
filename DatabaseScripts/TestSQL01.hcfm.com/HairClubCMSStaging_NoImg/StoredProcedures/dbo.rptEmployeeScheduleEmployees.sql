/* CreateDate: 03/11/2009 12:18:42.837 , ModifyDate: 02/27/2017 09:49:26.960 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptEmployeeScheduleEmployees

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Andrew Schwalbe

IMPLEMENTOR: 			Andrew Schwalbe

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	6/16/09 Shaun H - Added logic to where statement to limit list of employess to only employee positions that can be scheduled

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve employees for listing in the employee dropdown.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptEmployeeScheduleEmployees

***********************************************************************/

CREATE PROCEDURE [dbo].[rptEmployeeScheduleEmployees]
AS
BEGIN

	SET NOCOUNT ON;

	(
		SELECT e.EmployeeFullNameCalc, e.EmployeeGUID
		FROM datEmployee e
			INNER JOIN cfgEmployeePositionJoin epj ON e.EmployeeGUID = epj.EmployeeGUID
			INNER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		WHERE e.IsActiveFlag = 1 AND ep.CanScheduleFlag = 1
	) UNION (
		--HACK in order to allow NULL as a field
		SELECT '' AS EmployeeFullNameCalc, NULL AS EmployeeGUID
	)
	ORDER BY EmployeeFullNameCalc
END
GO
