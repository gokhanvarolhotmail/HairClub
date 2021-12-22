/* CreateDate: 06/25/2012 09:47:42.927 , ModifyDate: 02/27/2017 09:49:31.383 */
GO
/***********************************************************************

PROCEDURE:				selDeclineBatchSummary

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/22/2012

LAST REVISION DATE: 	08/22/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the Decline Summary for Batches

		06/22/2012 - MT: Created Stored Proc
		08/22/2012 - MT: Modified the sort order
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selDeclineBatchSummary

***********************************************************************/
CREATE PROCEDURE [dbo].[selDeclineBatchSummary]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @LastFeeRunDate date, @StartRunDate Date

	SELECT @LastFeeRunDate = MAX(RunDate) FROM datCenterFeeBatch
	-- Determine how far back to go by subtracting 2 Months and 3 days from the Last Run Date
	SET @StartRunDate = DATEADD(Day, -3, DATEADD(Month, -2, @LastFeeRunDate))

	-------------------------------------------
	-- Temporary table to store all distinct dates declines
	-- were run for the Fee Batches that were run after the @StartRunDate
	-------------------------------------------
	DECLARE @DeclineRunDates TABLE	(
			RunDate Date NOT NULL
	)

	INSERT INTO @DeclineRunDates
	SELECT Distinct(DATEADD(dd, DATEDIFF(dd, 0, cdb.RunDate), 0))
		FROM datCenterFeeBatch cfb
			INNER JOIN datCenterDeclineBatch cdb ON cfb.CenterFeeBatchGUID = cdb.CenterFeeBatchGUID
		WHERE cfb.RunDate >= @StartRunDate
		GROUP BY DATEADD(dd, DATEDIFF(dd, 0, cdb.RunDate), 0)


	-- Final select
	SELECT
		 drd.RunDate,
		 ISNULL(SUM(CASE WHEN pct.PayCycleTransactionGUID IS NOT NULL THEN 1 ELSE 0 END), 0) AS TotalCount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 1 THEN pct.ChargeAmount ELSE ipct.ChargeAmount END), 0)  AS TotalAmount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 1 THEN 1 ELSE 0 END), 0) AS ApprovedCount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 1 THEN pct.ChargeAmount ELSE 0 END), 0) AS ApprovedAmount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 0 THEN 1 ELSE 0 END), 0) AS DeclinedCount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 0 THEN ipct.ChargeAmount ELSE 0 END), 0) AS DeclinedAmount
	FROM datCenterDeclineBatch cdb
		INNER JOIN @DeclineRunDates drd ON DATEADD(dd, DATEDIFF(dd, 0, cdb.RunDate), 0) = drd.RunDate
		INNER JOIN datPayCycleTransaction pct ON cdb.CenterDeclineBatchGUID = pct.CenterDeclineBatchGUID
		INNER JOIN datPayCycleTransaction ipct ON ipct.CenterFeeBatchGUID = pct.CenterFeeBatchGUID
						AND ipct.CenterDeclineBatchGUID IS NULL
						AND ipct.ClientGUID = pct.ClientGUID
	GROUP BY
		drd.RunDate
	ORDER BY drd.RunDate desc

END
GO
