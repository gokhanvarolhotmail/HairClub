/* CreateDate: 05/14/2012 17:40:57.397 , ModifyDate: 05/04/2020 09:59:06.783 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[selEFTProcessCenterSummary]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED: 		02/02/2012
LAST REVISION DATE: 	02/02/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return summary for processing screen, user to select Centers to process
		02/02/2012 - HDu Created Stored Proc
		05/10/2012 - MTovbin Modified the "CanProcess" logic to include batches in 'RECON' status.
		06/11/2012 - MLM: Added Tax into the Fee Totals
		06/20/2012 - MLM: Added IsClientEFTUpdated check
		03/07/2013 - MLM: Added HasFullAccess check
		01/30/2014 - MLM: Add EmployeeGUID parameter to the proc
		02/07/2014 - MVT: Added progress flags for the batch
		01/06/2015 - KPL: Added NACHAFileProfileID for the batch
		03/11/2015 - MVT: Modified NACHAFileProfileID to be Nullable.
		03/16/2015 - MVT: Modified to return Nacha Profile Name.
		08/01/2016 - MLM: Added In-House Payment Plan Processing
		09/06/2016 - SAL: Updated CASE statement for "Amount" to use the Payment Plan Sales Code's tax
							whenever the monthly fee is for a payment plan versus the Monthly Fee Sales
							Code's tax
		01/30/2019 - SAL: Updated Projected Amounts and Totals currently being returned to include
							Add-On Amounts. (TFS #11935)
		04/02/2019 - JLM: Update logic to determine add-on amount. (TFS #12202)
		06/23/2019 - SAL: Update the logic for memberships' Monthly Fees to consider
								cfgConfigurationMembership.IsEFTProcessingRestrictedByContractBalance (TFS #12679)
		02/13/2020 - MVT: Modified logic to include HW in fee processing (TFS #13838)
		04/09/2020 - SAL: Modified logic to exclude HW in fee processing (TFS #14248)

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

selEFTProcessCenterSummary '54905628-47f8-40a1-b7d5-ca828df01392', 2, 2019, 02

***********************************************************************/
CREATE   PROCEDURE [dbo].[selEFTProcessCenterSummary]
 @EmployeeGUID char(36) = null
 ,@PayCycleID INT
 ,@FeeYear INT
 ,@FeeMonth INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Build MyCenter table based on EmployeeGUID
	--DECLARE @MyCenter TABLE ( CenterID int not null )
	CREATE TABLE #MyCenter ( CenterID int not null );
	IF ISNULL(RTRIM(LTRIM(@EmployeeGUID)),'') = ''
		BEGIN
			INSERT INTO #MyCenter(CenterID)
				SELECT DISTINCT CenterID
				FROM cfgCenter c
					inner join lkpCenterType ct on c.CenterTypeID = ct.CenterTypeID
				--WHERE (ct.CenterTypeDescriptionShort = 'C' OR ct.CenterTypeDescriptionShort = 'HW')
				WHERE ct.CenterTypeDescriptionShort = 'C'
					AND c.IsCorporateHeadquartersFlag = 0
		END
	ELSE
		BEGIN
			INSERT INTO #MyCenter(CenterID) SELECT DISTINCT CenterID From datEmployeeCenter where EmployeeGuID = @EmployeeGUID
		END


	DECLARE @MonthlyFeeSalesCodeID int
			,@PaymentPlanSalesCodeID int
	SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'
	SELECT @PaymentPlanSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'MTHPLANPMT'

	DECLARE @PayCycleValue int
	SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @PayCycleID)

	DECLARE @BatchRunDate datetime
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@FeeMonth) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@FeeYear), 101)
	print @BatchRunDate
	print DATEADD(DAY, 15 - 1, @BatchRunDate)

	-- Default CenterFeeBatchStatus (Waiting for Approval)
	DECLARE @Waiting_CenterFeeBatchStatus nvarchar(100)
	SELECT @Waiting_CenterFeeBatchStatus = CenterFeeBatchStatusDescription From lkpCenterFeeBatchStatus where CenterFeeBatchStatusDescriptionShort = 'WAITING'

	-- create temp table for each EFT profile
	--DECLARE @ClientEFTStatus TABLE
	CREATE TABLE #ClientEFTStatus
	(
		NACHAFileProfileID int NULL,
		NACHAFileProfileName nvarchar(100) NULL,
		CenterID INT NOT NULL,
		ClientEFTGUID uniqueidentifier NOT NULL,
		Amount money NOT NULL,
		AddOnAmount money NOT NULL,
		IsProfileExpired bit NOT NULL,
		IsProfileFrozen bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL,
		IsValidToRun bit NULL,
		IsClientEFTUpdated bit NOT NULL
	)

	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO #ClientEFTStatus (NACHAFileProfileID, NACHAFileProfileName, CenterId, ClientEFTGUID, Amount, AddOnAmount, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired, IsClientEFTUpdated)
			SELECT cc.NACHAFileProfileID
			,nacha.NACHAFileProfileName
			,cl.CenterID,
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
			ISNULL(o_AddOns.TotalAddOnMonthlyFeeAmount, 0) AS AddOnAmount,

			-- EFT Profile is active
			CASE
				WHEN c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0
						OR stat.IsEFTActiveFlag IS NULL OR stat.IsEFTActiveFlag = 0
				THEN 1 ELSE 0 END,

			-- Account is not Frozen
			CASE
				WHEN (c.Freeze_Start IS NULL AND c.Freeze_End IS NULL)
							OR (c.Freeze_End IS NULL AND  @BatchRunDate < c.Freeze_Start)
							OR (c.Freeze_Start IS NULL AND  @BatchRunDate > c.Freeze_End)
							OR (@BatchRunDate < c.Freeze_Start OR @BatchRunDate > c.Freeze_End)
				THEN 0 ELSE 1 END,

			-- Credit Card Not Expired
			CASE
				WHEN (at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND @BatchRunDate <= c.AccountExpiration)
					  OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard')
					THEN 0 ELSE 1 END,

			-- Membership is  Active
			CASE
				WHEN cm.BeginDate IS NULL OR (cm.BeginDate <= @BatchRunDate
								AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= @BatchRunDate)
				THEN 0 ELSE 1 END,
			CASE
				WHEN cc.HasFullAccess = 1 THEN 1
				WHEN cc.LastClientEFTUpdate IS NULL OR cc.LastClientEFTUpdate < DATEADD(hour,-24,GETDATE()) THEN 0
				ELSE 1
			END

		FROM datClientEFT c
			INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
			INNER JOIN cfgConfigurationCenter cc on cl.CenterId = cc.CenterID
			INNER JOIN #MyCenter mc on cc.CenterID = mc.CenterID
			INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = c.ClientMembershipGUID
			INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
			INNER JOIN cfgConfigurationMembership cfgmem ON m.MembershipID = cfgmem.MembershipID
			INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
			INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID	AND pc.FeePayCycleID = @PayCycleID
			LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
			LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
			-- Tax Calculation
			LEFT OUTER JOIN cfgSalesCodeCenter scc ON cl.CenterID = scc.CenterID
				AND scc.SalesCodeID = @MonthlyFeeSalesCodeID
			LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1 on scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
			LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2 on scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
			LEFT OUTER JOIN cfgSalesCodeMembership scm on scc.SalesCodeCenterID = scm.SalesCodeCenterID
				AND scm.MembershipID = m.MembershipID
			LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1 on scm.TaxRate1ID = mTaxRate1.CenterTaxRateID
			LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2 on scm.TaxRate2ID = mTaxRate2.CenterTaxRateID
			LEFT OUTER JOIN cfgNACHAFileProfile nacha  ON nacha.NACHAFileProfileID = cc.NACHAFileProfileID
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
			--Add Ons
			OUTER APPLY (
				SELECT SUM(ClientMembershipAddOns.MonthlyFeeSubTotals) AS TotalAddOnMonthlyFeeAmount
				FROM (SELECT SUM(
						CASE
							WHEN cmao.ContractPrice <= cmao.ContractPaidAmount THEN 0.0
							WHEN cmao.ContractBalanceAmount < COALESCE(cmao.MonthlyFee, 0.0) THEN cmao.ContractBalanceAmount
							ELSE COALESCE(cmao.MonthlyFee, 0.0)
						END * (1 + (COALESCE(mTaxRate1_CMAO.TaxRate, cTaxRate1_CMAO.TaxRate, mTaxRate1_AO.TaxRate, cTaxRate1_AO.TaxRate, 0.0) + COALESCE(mTaxRate2_CMAO.TaxRate, cTaxRate2_CMAO.TaxRate, mTaxRate2_AO.TaxRate, cTaxRate2_AO.TaxRate, 0.0)))) AS MonthlyFeeSubTotals
					  FROM datClientMembershipAddOn cmao
							INNER JOIN lkpClientMembershipAddOnStatus cmaos ON cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID

							--AddOn Level Monthly Fee Sales Code and Tax Rates
							INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
							INNER JOIN lkpAddOnType aot ON ao.AddOnTypeID = aot.AddOnTypeID
							-- Tax Calculation
							LEFT OUTER JOIN cfgSalesCodeCenter scc_AO ON cl.CenterID = scc_AO.CenterID
								AND ao.MonthlyFeeSalesCodeID = scc_AO.SalesCodeID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_AO ON scc_AO.TaxRate1ID = cTaxRate1_AO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_AO ON scc_AO.TaxRate2ID = cTaxRate2_AO.CenterTaxRateID
							LEFT OUTER JOIN cfgSalesCodeMembership scm_AO ON scc_AO.SalesCodeCenterID = scm_AO.SalesCodeCenterID
								AND scm_AO.MembershipID = m.MembershipID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_AO ON scm_AO.TaxRate1ID = mTaxRate1_AO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_AO ON scm_AO.TaxRate2ID = mTaxRate2_AO.CenterTaxRateID

							--CenterMembershipAddOn Level Monthly Fee Sales Code and Tax Rates
							LEFT OUTER JOIN cfgCenterMembership ctrm ON m.MembershipID = ctrm.MembershipID
								AND cl.CenterID = ctrm.CenterID
							LEFT OUTER JOIN cfgCenterMembershipAddOn ctrmao ON ao.AddOnID = ctrmao.AddOnID
								AND ctrm.CenterMembershipID = ctrmao.CenterMembershipID
							-- Tax Calculation
							LEFT OUTER JOIN cfgSalesCodeCenter scc_CMAO ON cl.CenterID = scc_CMAO.CenterID
								AND ctrmao.MonthlyFeeSalesCodeID = scc_CMAO.SalesCodeID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_CMAO ON scc_CMAO.TaxRate1ID = cTaxRate1_CMAO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_CMAO ON scc_CMAO.TaxRate2ID = cTaxRate2_CMAO.CenterTaxRateID
							LEFT OUTER JOIN cfgSalesCodeMembership scm_CMAO ON scc_CMAO.SalesCodeCenterID = scm_CMAO.SalesCodeCenterID
								AND m.MembershipID = scm_CMAO.MembershipID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_CMAO ON scm_CMAO.TaxRate1ID = mTaxRate1_CMAO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_CMAO ON scm_CMAO.TaxRate2ID = mTaxRate2_CMAO.CenterTaxRateID
					  WHERE cmao.ClientMembershipGUID = cm.ClientMembershipGUID
							and cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active'
							and aot.IsMonthlyAddOnType = 1
					  GROUP BY cmao.ClientMembershipAddOnID) AS ClientMembershipAddOns
				) o_AddOns
		WHERE cms.ClientMembershipStatusDescriptionShort = 'A'
			AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
			AND cc.IsFeeProcessedCentrallyFlag = 1
			-- Added Payment Plan Filter
			AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@BatchRunDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))


	-- Update if client EFT profile is valid to run
	UPDATE #ClientEFTStatus SET
		IsValidToRun = CASE WHEN IsProfileExpired = 0
								AND IsCreditCardExpired = 0 AND IsMembershipExpired = 0 THEN 1 ELSE 0 END

	SELECT *,
	ProjectedCount + ProjectedCheckSavingsCount + ProjectedARCount AS TotalCount,
	ProjectedAmount + ProjectedCheckSavingsAmount + ProjectedARAmount AS  TotalAmount

	FROM (
		SELECT
			CAST(
				CASE
					WHEN cab.CenterFeeBatchStatusID IS NOT NULL AND (st.CenterFeeBatchStatusDescriptionShort = 'APPROVED' OR st.CenterFeeBatchStatusDescriptionShort = 'RECON') THEN 1
					WHEN eftStat.IsClientEFTUpdated = 0 THEN 0
					ELSE 0 END AS BIT
			) AS CanProcess,
			ISNULL(st.CenterFeeBatchStatusDescription, @Waiting_CenterFeeBatchStatus) AS CenterFeeBatchStatusDescription,
			eftStat.NACHAFileProfileID,
			eftStat.NACHAFileProfileName,
			cab.CenterFeeBatchGUID,
			Center.CenterID,
			Center.CenterDescriptionFullCalc,

			SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='CreditCard' THEN 1 ELSE 0 END) AS ProjectedCount,
			CAST(SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='CreditCard' THEN (eftstat.Amount + eftstat.AddOnAmount) ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedAmount,

			SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND (at.EFTAccountTypeDescriptionShort='Checking' OR at.EFTAccountTypeDescriptionShort='Savings') THEN 1 ELSE 0 END) AS ProjectedCheckSavingsCount,
			CAST(SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND (at.EFTAccountTypeDescriptionShort='Checking' OR at.EFTAccountTypeDescriptionShort='Savings') THEN (eftstat.Amount + eftstat.AddOnAmount) ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedCheckSavingsAmount,

			SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='A/R' THEN 1 ELSE 0 END) AS ProjectedARCount,
			CAST(SUM(CASE WHEN eftStat.IsValidToRun = 1 AND eftStat.IsProfileFrozen = 0 AND at.EFTAccountTypeDescriptionShort='A/R' THEN (eftstat.Amount + eftstat.AddOnAmount) ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedARAmount,

			SUM(CASE WHEN eftStat.IsValidToRun = 0 AND eftStat.IsProfileFrozen = 0 THEN 1 ELSE 0 END) AS ProjectedOtherCount,
			CAST(SUM(CASE WHEN eftStat.IsValidToRun = 0 AND eftStat.IsProfileFrozen = 0 THEN (eftstat.Amount + eftstat.AddOnAmount) ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedOtherAmount,

			SUM(CASE WHEN eftStat.IsProfileFrozen = 1 THEN 1 ELSE 0 END) AS ProjectedFrozenCount,
			CAST(SUM(CASE WHEN eftStat.IsProfileFrozen = 1 THEN (eftstat.Amount + eftstat.AddOnAmount) ELSE 0 END) AS DECIMAL(18,2)) AS ProjectedFrozenAmount,

			cab.RunDate,
			tz.UTCOffset,
			eftStat.IsClientEFTUpdated,
			cab.AreSalesOrdersCreated,
			cab.IsMonetraProcessingCompleted,
			cab.AreMonetraResultsProcessed,
			cab.IsACHFileCreated,
			cab.AreAccumulatorsExecuted,
			cab.AreARPaymentsApplied,
			cab.IsNACHAFileCreated
		FROM #ClientEFTStatus eftStat
			INNER JOIN cfgCenter Center ON Center.CenterID = eftStat.CenterID
			LEFT JOIN dbo.lkpTimeZone tz ON tz.TimeZoneID = Center.TimeZoneID
			LEFT JOIN datClientEFT ceft ON eftStat.ClientEFTGUID = ceft.ClientEFTGUID
			LEFT JOIN datClient c ON c.ClientGUID = ceft.ClientGUID
			LEFT JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID
				AND pc.FeePayCycleID = @PayCycleID
			LEFT JOIN datCenterFeeBatch cab ON cab.CenterID = Center.CenterID
				AND cab.FeeMonth = @FeeMonth
				AND cab.FeeYear = @FeeYear
				AND cab.FeePayCycleID = @PayCycleID
			LEFT JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
			LEFT JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
		--WHERE eftStat.IsValidToRun = 1
		GROUP BY
			eftStat.NACHAFileProfileID,
			eftStat.NACHAFileProfileName,
			cab.CenterFeeBatchGUID,
			Center.CenterID,
			Center.CenterDescriptionFullCalc,
			pc.FeePayCycleValue,
			st.CenterFeeBatchStatusDescription,
			cab.CenterFeeBatchStatusID,
			st.CenterFeeBatchStatusDescriptionShort,
			cab.RunDate,
			cab.CenterID,
			UTCOffset,
			eftStat.IsClientEFTUpdated,
			cab.AreSalesOrdersCreated,
			cab.IsMonetraProcessingCompleted,
			cab.AreMonetraResultsProcessed,
			cab.IsACHFileCreated,
			cab.AreAccumulatorsExecuted,
			cab.AreARPaymentsApplied,
			cab.IsNACHAFileCreated
	) TBL
	ORDER BY UTCOffset DESC, CenterDescriptionFullCalc
END
GO
