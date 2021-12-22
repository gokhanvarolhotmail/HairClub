/* CreateDate: 02/17/2015 14:52:50.570 , ModifyDate: 02/17/2015 14:52:50.570 */
GO
/*
==============================================================================

PROCEDURE:				[selPayPeriodForCommissions]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

==============================================================================
DESCRIPTION:	Creates the list of pay periods for a drop-down for commission
					correction reports. Only HR needs to see the entire list of Pay Periods,
					the center level only sees the top 10 Pay Periods in the drop-down.
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [selPayPeriodForCommissions] '281'

EXEC [selPayPeriodForCommissions] '281,292'

EXEC [selPayPeriodForCommissions] '1'  --All centers
==============================================================================
*/

CREATE PROCEDURE [dbo].[selPayPeriodForCommissions] (
@CenterID NVARCHAR(MAX))

AS

BEGIN
	SET NOCOUNT ON

	DECLARE @Centers TABLE
		(
			CenterID INT NOT NULL
		)

	INSERT INTO @Centers (CenterID)
	SELECT item FROM fnSplit(@CenterID,',')

	IF(SELECT COUNT(CenterID) FROM @Centers)> 1  --More than one center may only be selected by HR
		OR  (SELECT CenterID FROM @Centers) = 1  --'All Centers' is selected
	BEGIN
		SELECT PayPeriodKey AS 'Value'
			,	CONVERT(VARCHAR, StartDate, 101) + ' - ' + CONVERT(VARCHAR, EndDate, 101) AS 'Description'
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
	ELSE
	BEGIN  -- Only show the top ten pay periods for an individual center
		SELECT TOP 10 PayPeriodKey AS 'Value'
			,	CONVERT(VARCHAR, StartDate, 101) + ' - ' + CONVERT(VARCHAR, EndDate, 101) AS 'Description'
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

END
GO
