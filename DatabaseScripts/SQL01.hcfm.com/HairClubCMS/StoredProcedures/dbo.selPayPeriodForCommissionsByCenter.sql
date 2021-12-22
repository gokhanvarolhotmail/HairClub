/*
==============================================================================

PROCEDURE:				[selPayPeriodForCommissionsByCenter]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

==============================================================================
DESCRIPTION:	Creates the list of pay periods for a drop-down for commission
					correction reports. The center level only sees the top 10 Pay Periods in the drop-down.
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [selPayPeriodForCommissionsByCenter]

==============================================================================
*/

CREATE PROCEDURE [dbo].[selPayPeriodForCommissionsByCenter]
AS

BEGIN
	SET NOCOUNT ON


		SELECT TOP 10 CONVERT(NVARCHAR,PayPeriodKey) AS 'Value'
			,	CONVERT(VARCHAR, StartDate, 101) + ' - ' + CONVERT(VARCHAR, EndDate, 101) AS 'Description'
		FROM Commission_lkpPayPeriods_TABLE PP
		WHERE PP.PayGroup = 1
			AND PP.PayDate <= (
				SELECT PayDate
				FROM Commission_lkpPayPeriods_TABLE
				WHERE CONVERT(CHAR(10), GETDATE(), 101) BETWEEN StartDate AND EndDate
					AND PayGroup = 1)
		ORDER BY PP.StartDate DESC

END
