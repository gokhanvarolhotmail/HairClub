/***********************************************************************
PROCEDURE:				[selEFTReconcileDeclineBatchSummary]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				MTovbin
IMPLEMENTOR: 			MTovbin
DATE IMPLEMENTED: 		05/07/2012
LAST REVISION DATE: 	05/07/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return summary for Reconcile screen for Declines, user to select Centers to reconcile
		05/07/2012 - MTovbin Created Stored Proc
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTReconcileDeclineBatchSummary]
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTReconcileDeclineBatchSummary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- create temp table to store pay cycle dates
	DECLARE @CenterPayCycleDates TABLE
	(
		FeePayCycleId Int NOT NULL,
		FeePayCycleDate Date NOT NULL
	)

	DECLARE @TodayDate AS Date, @MonetraProcessingBuffer Int
	SET @TodayDate = CONVERT(Date, GETDATE(), 101)
	SET @MonetraProcessingBuffer = (SELECT TOP(1) MonetraProcessingBufferInMinutes FROM dbo.cfgConfigurationApplication)


	-- Insert dates for all pay cycles
	INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate)
		SELECT
			p.FeePayCycleId,
			CONVERT(Date, Convert(nvarchar(2), MONTH(@TodayDate)) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(@TodayDate)), 101)
		FROM lkpFeePayCycle p
		WHERE p.FeePayCycleValue > 0


	-- Update to only include last run date for each pay cycle
	UPDATE @CenterPayCycleDates SET
		FeePayCycleDate = DATEADD(MONTH, -1, FeePayCycleDate)
	WHERE FeePayCycleDate > @TodayDate


	/*******************************************/


	SELECT
		dcab.CenterDeclineBatchGUID,
		st.CenterDeclineBatchStatusDescription AS CenterDeclineBatchStatusDescription,
		CAST(CASE WHEN DATEADD(MINUTE,@MonetraProcessingBuffer,dcab.LastUpdate) < GETUTCDATE()
			THEN 1 ELSE 0 END AS Bit) AS CanRecon,   -- check that the processing buffer expired

		SUM(pct.ChargeAmount) AS TotalAmount,
		SUM(1) AS TotalCount,

		dcab.RunDate,
		cab.CenterID,
		pcd.FeePayCycleDate,
		pcd.FeePayCycleID,
		ctr.CenterDescriptionFullCalc,
		tz.UTCOffset
	FROM datCenterFeeBatch cab
		INNER JOIN @CenterPayCycleDates pcd ON pcd.FeePayCycleId = cab.FeePayCycleId
							AND cab.FeeMonth = MONTH(FeePayCycleDate)
							AND cab.FeeYear = YEAR(FeePayCycleDate)
		INNER JOIN datCenterDeclineBatch dcab ON dcab.CenterFeeBatchGUID = cab.CenterFeeBatchGUID
		INNER JOIN lkpCenterDeclineBatchStatus st ON st.CenterDeclineBatchStatusID = dcab.CenterDeclineBatchStatusID
		INNER JOIN cfgCenter ctr ON ctr.CenterID = cab.CenterID
		INNER JOIN datPayCycleTransaction pct ON pct.CenterFeeBatchGUID  = cab.CenterFeeBatchGUID AND pct.CenterDeclineBatchGUID IS NULL
		INNER JOIN datClient cl ON cl.ClientGUID = pct.ClientGUID
		INNER JOIN datClientEFT c ON cl.ClientGUID = c.ClientGUID
		LEFT JOIN dbo.lkpTimeZone tz ON tz.TimeZoneID = ctr.TimeZoneID
	WHERE  st.CenterDeclineBatchStatusDescriptionShort = 'PROCESSING'
		AND pct.IsReprocessFlag = 1
	GROUP BY
		dcab.CenterDeclineBatchGUID,
		dcab.LastUpdate,
		dcab.RunDate,
		st.CenterDeclineBatchStatusDescription,
		cab.CenterID,
		pcd.FeePayCycleDate,
		pcd.FeePayCycleID,
		ctr.CenterDescriptionFullCalc,
		tz.UTCOffset
	ORDER BY pcd.FeePayCycleDate, tz.UTCOffset DESC, ctr.CenterDescriptionFullCalc

END
