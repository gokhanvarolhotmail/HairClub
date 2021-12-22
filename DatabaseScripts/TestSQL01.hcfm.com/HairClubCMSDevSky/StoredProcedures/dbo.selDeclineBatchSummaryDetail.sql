/* CreateDate: 06/25/2012 09:47:42.947 , ModifyDate: 02/27/2017 09:49:31.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selDeclineBatchSummaryDetail

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/22/2012

LAST REVISION DATE: 	06/22/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the Center Decline Batches and their status

		06/22/2012 - MT: Created Stored Proc
		06/25/2012 - MT: Modified to also check that CC is not expired when determining if any transactions
						 exist for the fee run that need to be re-processed.
		02/06/2014 - MM: Fixed issue with Date Conversion
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[selDeclineBatchSummaryDetail]

***********************************************************************/
CREATE PROCEDURE [dbo].[selDeclineBatchSummaryDetail]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @LastFeeRunDate date, @StartRunDate Date

	SELECT @LastFeeRunDate = MAX(RunDate) FROM datCenterFeeBatch
	-- Determine how far back to go by subtracting 2 Months and 3 days from the Last Run Date
	SET @StartRunDate = DATEADD(Day, -3, DATEADD(Month, -2, @LastFeeRunDate))

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

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

	-------------------------------------------
	-- Temporary table to store all Fee Batches that
	-- should have had declines run on for specified date.
	-------------------------------------------
	DECLARE @ApplicableFeeBatches TABLE	(
			RunDate Date NOT NULL,
			CenterFeeBatchGUID uniqueidentifier NOT NULL
	)


	-- The logic for determining if the declines should have been run for a
	-- center fee batch uses the current state of the batch. So if today there are
	-- no declines to run, we assume that it would be ok for batch to not be included
	-- in previous decline runs, but if it was included in previous runs, we show it.
	INSERT INTO @ApplicableFeeBatches
	SELECT drd.RunDate, cfb.CenterFeeBatchGUID
	FROM datCenterFeeBatch cfb
		INNER JOIN lkpFeePayCycle pc ON cfb.FeePayCycleID = pc.FeePayCycleID and pc.FeePayCycleDescriptionShort <> 'MANUAL'
		INNER JOIN @DeclineRunDates drd ON drd.RunDate <=
				DATEADD(Day, -1, DATEADD(Month, 1, CAST(CONVERT(nvarchar(2), cfb.FeeMonth) + '/' +  CONVERT(nvarchar(2), pc.FeePayCycleValue)
					+ '/' +  CONVERT(nvarchar(4), cfb.FeeYear) AS Date)))
		INNER JOIN datPayCycleTransaction pct ON pct.CenterFeeBatchGUID = cfb.CenterFeeBatchGUID
								AND pct.CenterDeclineBatchGUID IS NULL
		INNER JOIN datClientEFT ceft ON ceft.ClientGUID = pct.ClientGUID
		LEFT OUTER JOIN datCenterDeclineBatch cdb ON cdb.CenterFeeBatchGUID = cfb.CenterFeeBatchGUID
				AND DATEADD(dd, DATEDIFF(dd, 0, cdb.RunDate), 0) = drd.RunDate
	WHERE cdb.CenterDeclineBatchGUID IS NOT NULL -- Declines have been run for this batch on specified date
		OR
		(
			-- center fee batch still has transactions that need to be re-processed
			pct.IsReprocessFlag = 1
			AND (
					pct.ClientGUID NOT IN (
                        (SELECT so.ClientGUID
                              FROM datSalesOrder so
                                    INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
                                                AND sod.SalesCodeID = @PAYMENT_RECEIVED
                              WHERE pct.ClientGUID = so.ClientGUID
                                    AND so.OrderDate BETWEEN
										CONVERT(DATETIME, CONVERT(VARCHAR(10), cfb.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))

				)
			AND ceft.AccountExpiration >= drd.RunDate
			AND cfb.RunDate < drd.RunDate
		)
	GROUP BY cfb.CenterFeeBatchGUID, drd.RunDate


	-------------------------------------------
	-- Temporary table to store status for decline
	-- batches that should exist for each Fee Batch and
	-- Decline Run Date.
	-------------------------------------------
	DECLARE @DeclineBatchStatus TABLE	(
			RunDate Date NOT NULL,
			CenterFeeBatchGUID uniqueidentifier NOT NULL,
			CenterDeclineBatchGUID uniqueidentifier NULL,
			IsStatusInvalid bit NOT NULL,
			IsBatchMissing bit NOT NULL,
			AreSalesOrdersInvalid bit NOT NULL,
			IsValid bit NOT NULL
	)


	INSERT INTO @DeclineBatchStatus
	SELECT
		afb.RunDate,
		afb.CenterFeeBatchGUID,
		cdb.CenterDeclineBatchGUID,
		CASE WHEN stat.CenterDeclineBatchStatusDescriptionShort = 'Completed'
			THEN 0 ELSE 1 END,
		CASE WHEN cdb.CenterDeclineBatchGUID IS NULL
			THEN 1 ELSE 0 END,
		CASE WHEN (SELECT COUNT(*)
					FROM datPayCycleTransaction pct
						LEFT OUTER JOIN datSalesOrder so
								ON pct.SalesOrderGUID = so.SalesOrderGUID
						LEFT OUTER JOIN datSalesOrderTender sot
								ON so.SalesOrderGUID = sot.SalesOrderGUID
					WHERE pct.CenterDeclineBatchGUID = cdb.CenterDeclineBatchGUID
						AND sot.SalesOrderTenderGUID IS NULL) > 0 THEN 1 ELSE 0 END,
		1 -- Default to Valid
	FROM @ApplicableFeeBatches afb
		LEFT OUTER JOIN datCenterDeclineBatch cdb ON cdb.CenterFeeBatchGUID = afb.CenterFeeBatchGUID
							AND DATEADD(dd, DATEDIFF(dd, 0, cdb.RunDate), 0) = afb.RunDate
		LEFT OUTER JOIN lkpCenterDeclineBatchStatus stat ON stat.CenterDeclineBatchStatusID = cdb.CenterDeclineBatchStatusID



	-- Update the 'IsValid' flag to reflect correct validity
	UPDATE @DeclineBatchStatus SET
		IsValid = CASE WHEN IsStatusInvalid = 0 AND IsBatchMissing = 0
									AND AreSalesOrdersInvalid = 0 THEN 1 ELSE 0 END



	-- Final select
	SELECT
		 dbstat.RunDate,
		 dbstat.CenterFeeBatchGUID,
		 dbstat.CenterDeclineBatchGUID,
		 cfb.CenterId,
		 CAST(CONVERT(nvarchar(2), cfb.FeeMonth) + '/' +  CONVERT(nvarchar(2), pc.FeePayCycleValue)
											+ '/' +  CONVERT(nvarchar(4), cfb.FeeYear) AS Date) AS PayCycleDate,
		 stat.CenterDeclineBatchStatusDescription,
		 ISNULL(SUM(CASE WHEN pct.PayCycleTransactionGUID IS NOT NULL THEN 1 ELSE 0 END), 0) AS TotalCount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 1 THEN pct.ChargeAmount ELSE ipct.ChargeAmount END), 0)  AS TotalAmount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 1 THEN 1 ELSE 0 END), 0) AS ApprovedCount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 1 THEN pct.ChargeAmount ELSE 0 END), 0) AS ApprovedAmount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 0 THEN 1 ELSE 0 END), 0) AS DeclinedCount,
		 ISNULL(SUM(CASE WHEN pct.IsSuccessfulFlag = 0 THEN ipct.ChargeAmount ELSE 0 END), 0) AS DeclinedAmount,
		 dbstat.IsStatusInvalid,
		 dbstat.IsBatchMissing,
		 dbstat.AreSalesOrdersInvalid,
		 dbstat.IsValid
	FROM @DeclineBatchStatus dbstat
		INNER JOIN datCenterFeeBatch cfb ON cfb.CenterFeeBatchGUID = dbstat.CenterFeeBatchGUID
		INNER JOIN lkpFeePayCycle pc ON cfb.FeePayCycleID = pc.FeePayCycleID
		LEFT OUTER JOIN datCenterDeclineBatch cdb ON cdb.CenterDeclineBatchGUID = dbstat.CenterDeclineBatchGUID
		LEFT OUTER JOIN lkpCenterDeclineBatchStatus stat ON stat.CenterDeclineBatchStatusID = cdb.CenterDeclineBatchStatusID
		LEFT OUTER JOIN datPayCycleTransaction pct ON cdb.CenterDeclineBatchGUID = pct.CenterDeclineBatchGUID
		LEFT OUTER JOIN datPayCycleTransaction ipct ON ipct.CenterFeeBatchGUID = pct.CenterFeeBatchGUID
						AND ipct.CenterDeclineBatchGUID IS NULL
						AND ipct.ClientGUID = pct.ClientGUID
	GROUP BY
		dbstat.CenterDeclineBatchGUID
		,dbstat.RunDate
		,dbstat.CenterFeeBatchGUID
		,cfb.CenterId
		,cfb.FeeMonth
		,cfb.FeeYear
		,pc.FeePayCycleValue
		,stat.CenterDeclineBatchStatusDescription
		,dbstat.IsStatusInvalid
		,dbstat.IsBatchMissing
		,dbstat.AreSalesOrdersInvalid
		,dbstat.IsValid
	ORDER BY dbstat.RunDate

END
GO
