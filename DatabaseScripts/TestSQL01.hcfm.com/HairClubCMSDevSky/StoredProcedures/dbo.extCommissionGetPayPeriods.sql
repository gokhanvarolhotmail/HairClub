/* CreateDate: 03/04/2013 22:33:51.483 , ModifyDate: 06/17/2013 23:04:32.073 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extCommissionGetPayPeriods

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		1/24/2013

LAST REVISION DATE: 	1/24/2013

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used for getting the pay periods for commission management
		* 1/24/2013 MVT - Created stored proc
		* 02/19/2013 MVT - Updated to use synonyms
		* 03/05/2013 MB - Updated to limit available pay periods to the current and prior
							periods.  Also, only Las Vegas should see the pay period ending 03/01/2013
		* 06/13/2013 MLM - Changed Proc to get Current plus 3 pior periods.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC extCommissionGetPayPeriods 292

***********************************************************************/

CREATE PROCEDURE [dbo].[extCommissionGetPayPeriods] (@CenterID int)

AS
BEGIN
	SET NOCOUNT ON


	CREATE TABLE #PayPeriods (
		PayPeriodKey INT
	,	StartDate DATETIME
	,	EndDate DATETIME
	,	PayPeriodDescription VARCHAR(25)
	)

	INSERT INTO #PayPeriods
	SELECT PayPeriodKey
	,	StartDate
	,	EndDate
	,	'Current'
	FROM Commission_lkpPayPeriods_TABLE
	WHERE PayGroup = 1
		AND CONVERT(CHAR(10),GETDATE(), 101) BETWEEN startdate AND EndDate


	INSERT INTO #PayPeriods
	SELECT TOP 3 PayPeriodKey
	,	StartDate
	,	EndDate
	,	'Prior'
	FROM Commission_lkpPayPeriods_TABLE
	WHERE PayGroup=1
		AND StartDate < (
		SELECT StartDate
		FROM #PayPeriods
	)
	ORDER BY StartDate DESC



	SELECT PP.PayPeriodKey
	,	PP.StartDate
	,	PP.EndDate
	,	ISNULL(LCBS.BatchStatusDescription, 'Pending Approval') AS 'PayPeriodBatchStatusDescription'
	,	ISNULL(LCBS.BatchStatusID, 5) AS 'PayPeriodBatchStatusID'
	FROM #PayPeriods PP
		LEFT OUTER JOIN Commission_FactCommissionBatch_TABLE FCB
			ON PP.PayPeriodKey = FCB.PayPeriodKey
			AND @CenterID = FCB.CenterSSID
		LEFT OUTER JOIN Commission_lkpCommissionBatchStatus_TABLE LCBS
			ON FCB.BatchStatusID = LCBS.BatchStatusID
	ORDER BY PP.StartDate DESC

END
GO
