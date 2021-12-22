/***********************************************************************

PROCEDURE:				extCommissionGetAllPayDates

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		4/03/2015

LAST REVISION DATE: 	4/03/2015

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used for getting all pay dates for commission management
		* 04/03/2015 SAL - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC extCommissionGetAllPayDates

***********************************************************************/

CREATE PROCEDURE [dbo].extCommissionGetAllPayDates

AS
BEGIN
	SET NOCOUNT ON

	SELECT PayDate
	FROM Commission_lkpPayPeriods_TABLE
	ORDER BY PayDate

END
