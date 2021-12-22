/***********************************************************************
PROCEDURE:				[selEFTReconcileBatchSummary]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				MTovbin
IMPLEMENTOR: 			MTovbin
DATE IMPLEMENTED: 		05/07/2012
LAST REVISION DATE: 	05/07/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return summary for Reconcile screen, user to select Centers to reconcile
		05/07/2012 - MTovbin Created Stored Proc
		06/11/2012 - MLM: Added Tax into the Fee Totals
		07/02/2012 - MTovbin Fixed issue with duplicates
		08/01/2016 - MLM: Added In-House Payment Plan Processing
		09/06/2016 - SAL: Updated CASE statement for "Amount" to use the Payment Plan Sales Code's tax
							whenever the monthly fee is for a payment plan versus the Monthly Fee Sales
							Code's tax
		06/23/2019 - SAL: Update the logic for memberships' Monthly Fees to consider
								cfgConfigurationMembership.IsEFTProcessingRestrictedByContractBalance (TFS #12679)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTReconcileBatchSummary]
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTReconcileBatchSummary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MonthlyFeeSalesCodeID int
			,@PaymentPlanSalesCodeID int
	SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'
	SELECT @PaymentPlanSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'MTHPLANPMT'

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


	-- create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
	(
		CenterID INT NOT NULL,
		ClientEFTGUID uniqueidentifier NOT NULL,
		Amount money NOT NULL,
		IsProfileExpired bit NOT NULL,
		IsProfileFrozen bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL,
		PayCycleDate date NOT NULL,
		FeePayCycleID int NOT NULL,
		IsValidToRun bit NULL
	)

	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (CenterId, ClientEFTGUID, Amount, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired, PayCycleDate, FeePayCycleID)
			SELECT cl.CenterID,
			c.ClientEFTGUID,
			CASE WHEN pp.PaymentPlanID IS NULL THEN
					--ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0))))
					 CASE WHEN cfgmem.IsEFTProcessingRestrictedByContractBalance = 0 THEN
								ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0))))
						  WHEN cm.ContractPrice <= cm.ContractPaidAmount THEN
								0.0
						  WHEN (cm.ContractPrice - cm.ContractPaidAmount) > 0 AND (cm.ContractPrice - cm.ContractPaidAmount) < ISNULL(cm.MonthlyFee, 0.0) THEN
								(cm.ContractPrice - cm.ContractPaidAmount) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0))))
						  ELSE ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0))))
					 END
				 WHEN pp.PaymentPlanID is NOT null AND ISNULL(pp.RemainingBalance, 0) >= ISNULL(cm.MonthlyFee, 0) THEN
					(ISNULL(cm.MonthlyFee, 0)) * (1 + (ISNULL(mTaxRate1_2.TaxRate, ISNULL(cTaxRate1_2.TaxRate, 0)) + ISNULL(mtaxrate2_2.TaxRate, ISNULL(cTaxRate2_2.TaxRate, 0))))
				 WHEN pp.PaymentPlanID is NOT null AND ISNULL(pp.RemainingBalance, 0) < ISNULL(cm.MonthlyFee, 0) THEN
					(ISNULL(pp.RemainingBalance, 0)) * (1 + (ISNULL(mTaxRate1_2.TaxRate, ISNULL(cTaxRate1_2.TaxRate, 0)) + ISNULL(mtaxrate2_2.TaxRate, ISNULL(cTaxRate2_2.TaxRate, 0))))
			END,

			-- EFT Profile is active
			CASE
				WHEN c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0
						OR stat.IsEFTActiveFlag IS NULL OR stat.IsEFTActiveFlag = 0
				THEN 1 ELSE 0 END,

			-- Account is not Frozen
			CASE
				WHEN (c.Freeze_Start IS NULL AND c.Freeze_End IS NULL)
							OR (c.Freeze_End IS NULL AND  pcd.FeePayCycleDate < c.Freeze_Start)
							OR (c.Freeze_Start IS NULL AND  pcd.FeePayCycleDate > c.Freeze_End)
							OR (pcd.FeePayCycleDate < c.Freeze_Start OR pcd.FeePayCycleDate > c.Freeze_End)
				THEN 0 ELSE 1 END,

			-- Credit Card Not Expired
			CASE
				WHEN (at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND pcd.FeePayCycleDate <= c.AccountExpiration)
					  OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard')
					THEN 0 ELSE 1 END,

			-- Membership is  Active
			CASE
				WHEN cm.BeginDate IS NULL OR (cm.BeginDate <= pcd.FeePayCycleDate
								AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= pcd.FeePayCycleDate)
				THEN 0 ELSE 1 END,
			pcd.FeePayCycleDate,
			pcd.FeePayCycleID
		FROM datClientEFT c
		 INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
		 INNER JOIN cfgConfigurationCenter cc on cl.CenterId = cc.CenterID
		 INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = c.ClientMembershipGUID
		 INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
		 INNER JOIN cfgConfigurationMembership cfgmem ON m.MembershipID = cfgmem.MembershipID
		 INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
		 INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID
		 INNER JOIN @CenterPayCycleDates pcd ON pcd.FeePayCycleId = pc.FeePayCycleId
		 LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
		 LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
		 INNER JOIN datCenterFeeBatch cab ON cab.CenterId = cl.CenterId AND pc.FeePayCycleID = cab.FeePayCycleID
		 INNER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
		 -- Tax Calculation
		 LEFT OUTER JOIN cfgSalesCodeCenter scc ON cl.CenterID = scc.CenterID
				AND scc.SalesCodeID = @MonthlyFeeSalesCodeID
		 LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1 on scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
		 LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2 on scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
		 LEFT OUTER JOIN cfgSalesCodeMembership scm on scc.SalesCodeCenterID = scm.SalesCodeCenterID
				AND scm.MembershipID = m.MembershipID
		 LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1 on scm.TaxRate1ID = mTaxRate1.CenterTaxRateID
		 LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2 on scm.TaxRate2ID = mTaxRate2.CenterTaxRateID
		 --Adding PaymentPlan
		 LEFT OUTER JOIN datPaymentPlan pp on c.ClientMembershipGUID = pp.ClientMembershipGUID
		 LEFT OUTER JOIN lkpPaymentPlanStatus pps on pp.PaymentPlanStatusID = pps.PaymentPlanStatusID
		 LEFT OUTER JOIN cfgSalesCodeCenter scc2 ON cl.CenterID = scc2.CenterID
				AND scc2.SalesCodeID = @PaymentPlanSalesCodeID
		 LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_2 on scc2.TaxRate1ID = cTaxRate1_2.CenterTaxRateID
		 LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_2 on scc2.TaxRate2ID = cTaxRate2_2.CenterTaxRateID
		 LEFT OUTER JOIN cfgSalesCodeMembership scm2 on scc2.SalesCodeCenterID = scm2.SalesCodeCenterID
				AND scm2.MembershipID = m.MembershipID
		 LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_2 on scm2.TaxRate1ID = mTaxRate1_2.CenterTaxRateID
		 LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_2 on scm2.TaxRate2ID = mTaxRate2_2.CenterTaxRateID
		WHERE cms.ClientMembershipStatusDescriptionShort = 'A'
			AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
			AND cc.IsFeeProcessedCentrallyFlag = 1
			AND st.CenterFeeBatchStatusDescriptionShort = 'PROCESSING'
			AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@TodayDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))

	-- Update if client EFT profile is valid to run
	UPDATE @ClientEFTStatus SET
		IsValidToRun = CASE WHEN IsProfileExpired = 0
								AND IsCreditCardExpired = 0 AND IsMembershipExpired = 0 THEN 1 ELSE 0 END




SELECT *,
ProjectedCount + ProjectedCheckSavingsCount + ProjectedARCount AS TotalCount,
ProjectedAmount + ProjectedCheckSavingsAmount + ProjectedARAmount AS  TotalAmount

FROM (
	SELECT
		st.CenterFeeBatchStatusDescription AS CenterFeeBatchStatusDescription,
		CAST(CASE WHEN DATEADD(MINUTE,@MonetraProcessingBuffer,cab.LastUpdate) < GETUTCDATE() THEN 1 ELSE 0 END AS Bit) AS CanRecon, -- check that the processing buffer expired
		cab.CenterFeeBatchGUID,
		Center.CenterID,
		Center.CenterDescriptionFullCalc,
		eftStat.PayCycleDate,

		SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='CreditCard' THEN 1 ELSE 0 END) AS ProjectedCount,
		CAST(SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='CreditCard' THEN eftstat.Amount ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedAmount,

		SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND (at.EFTAccountTypeDescriptionShort='Checking' OR at.EFTAccountTypeDescriptionShort='Savings') THEN 1 ELSE 0 END) AS ProjectedCheckSavingsCount,
		CAST(SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND (at.EFTAccountTypeDescriptionShort='Checking' OR at.EFTAccountTypeDescriptionShort='Savings') THEN eftstat.Amount ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedCheckSavingsAmount,

		SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='A/R' THEN 1 ELSE 0 END) AS ProjectedARCount,
		CAST(SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='A/R' THEN eftstat.Amount ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedARAmount,

		SUM(CASE WHEN eftStat.IsValidToRun = 0 AND eftStat.IsProfileFrozen = 0 THEN 1 ELSE 0 END) AS ProjectedOtherCount,
		CAST(SUM(CASE WHEN eftStat.IsValidToRun = 0 AND eftStat.IsProfileFrozen = 0 THEN eftstat.Amount ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedOtherAmount,

		SUM(CASE WHEN eftStat.IsProfileFrozen = 1 THEN 1 ELSE 0 END) AS ProjectedFrozenCount,
		CAST(SUM(CASE WHEN eftStat.IsProfileFrozen = 1 THEN eftstat.Amount ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedFrozenAmount,

		cab.RunDate,
		tz.UTCOffset
	FROM @ClientEFTStatus eftStat
		INNER JOIN cfgCenter Center ON Center.CenterID = eftStat.CenterID
		INNER JOIN datCenterFeeBatch cab ON cab.CenterID = Center.CenterID
		INNER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = eftStat.FeePayCycleID
		LEFT JOIN dbo.lkpTimeZone tz ON tz.TimeZoneID = Center.TimeZoneID
		LEFT JOIN datClientEFT ceft ON eftStat.ClientEFTGUID = ceft.ClientEFTGUID
		LEFT JOIN datClient c ON c.ClientGUID = ceft.ClientGUID
		LEFT JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
	WHERE st.CenterFeeBatchStatusDescriptionShort = 'PROCESSING'
	GROUP BY
		cab.CenterFeeBatchGUID,
		cab.LastUpdate,
		eftStat.PayCycleDate,
		Center.CenterID,
		Center.CenterDescriptionFullCalc,
		pc.FeePayCycleValue,
		st.CenterFeeBatchStatusDescription,
		cab.CenterFeeBatchStatusID,
		st.CenterFeeBatchStatusDescriptionShort,
		cab.RunDate,
		cab.CenterID,
		UTCOffset
) TBL
ORDER BY PayCycleDate, UTCOffset DESC, CenterDescriptionFullCalc
--*/
END





SET ANSI_NULLS ON
