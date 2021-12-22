/***********************************************************************

PROCEDURE:				extCommissionGetAllPayPeriods

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		3/13/2013

LAST REVISION DATE: 	3/13/2013

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used for getting the pay periods for HR commission management
		* 3/13/2013 MB - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC extCommissionGetAllPayPeriods

***********************************************************************/

CREATE PROCEDURE [dbo].[extCommissionGetAllPayPeriods]

AS
BEGIN
	SET NOCOUNT ON

	SELECT PP.PayPeriodKey
	,	PP.StartDate
	,	PP.EndDate
	,	PP.PayDate
	,	'' AS 'PayPeriodBatchStatusDescription'
	,	0 AS 'PayPeriodBatchStatusID'
	FROM Commission_lkpPayPeriods_TABLE PP
	WHERE PP.PayGroup = 1
		AND PP.PayDate <= (
			SELECT PayDate
			FROM Commission_lkpPayPeriods_TABLE
			WHERE CONVERT(CHAR(10), GETDATE(), 101) BETWEEN StartDate AND EndDate
				AND PayGroup = 1
		)
	ORDER BY PP.StartDate DESC

END
