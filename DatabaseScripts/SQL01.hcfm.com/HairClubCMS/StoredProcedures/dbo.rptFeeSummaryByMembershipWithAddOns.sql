/* CreateDate: 05/20/2019 11:09:41.523 , ModifyDate: 05/20/2019 11:09:41.523 */
GO
/***********************************************************************

PROCEDURE:				rptFeeSummaryByMembershipWithAddOns

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/04/2011

LAST REVISION DATE: 	05/10/2019

--------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT summary by Membership for the specified Pay Cycle, Month, Year, and Center for the specified month.

08/04/2011 - AS - Created Stored Proc
06/11/2012 - MLM -Added Tax into the Fee Totals
05/10/2019 - RH - Added Membership Add-On Fees (Case #7719]; renamed the stored procedure "WithAddOns"
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptFeeSummaryByMembershipWithAddOns 1, 4, 2019, 240

***********************************************************************/
CREATE PROCEDURE [dbo].[rptFeeSummaryByMembershipWithAddOns]
	@feePayCycleId as int,
	@month as int,
	@year as int,
	@centerId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


DECLARE @MonthlyFeeSalesCodeID int
		,@PaymentPlanSalesCodeID int

SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'
SELECT @PaymentPlanSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'MTHPLANPMT'

DECLARE @PayCycleValue int
SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @feePayCycleId)

IF @PayCycleValue IS NULL
	RETURN

DECLARE @BatchRunDate datetime
SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@month) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@year), 101)


-- create temp table for each EFT profile
CREATE TABLE #ClientEFTStatus
(
	ClientEFTGUID uniqueidentifier,
	Amount DECIMAL(18,4) NOT NULL,
	AddOnAmount DECIMAL(18,4) NOT NULL,
	MembershipDescription nvarchar(50) NOT NULL,
	MembershipId int NOT NULL,
	IsProfileExpired bit NOT NULL,
	IsProfileFrozen bit NOT NULL,
	IsCreditCardExpired bit NOT NULL,
	IsMembershipExpired bit NOT NULL,
	IsFeeAmountZero bit NOT NULL,
	IsValidToRun bit NULL
)



-- Insert into temp table if EFT Profile is valid to run
INSERT INTO #ClientEFTStatus  (ClientEFTGUID, Amount, AddOnAmount, MembershipDescription, MembershipId, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired, IsFeeAmountZero, IsValidToRun)
	SELECT
		c.ClientEFTGUID,
		CASE WHEN pp.PaymentPlanID IS NULL THEN
				ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0))))
				WHEN pp.PaymentPlanID is NOT null AND ISNULL(pp.RemainingBalance, 0) >= ISNULL(cm.MonthlyFee, 0) THEN
				(ISNULL(cm.MonthlyFee, 0)) * (1 + (ISNULL(mTaxRate1_2.TaxRate, ISNULL(cTaxRate1_2.TaxRate, 0)) + ISNULL(mtaxrate2_2.TaxRate, ISNULL(cTaxRate2_2.TaxRate, 0))))
				WHEN pp.PaymentPlanID is NOT null AND ISNULL(pp.RemainingBalance, 0) < ISNULL(cm.MonthlyFee, 0) THEN
				(ISNULL(pp.RemainingBalance, 0)) * (1 + (ISNULL(mTaxRate1_2.TaxRate, ISNULL(cTaxRate1_2.TaxRate, 0)) + ISNULL(mtaxrate2_2.TaxRate, ISNULL(cTaxRate2_2.TaxRate, 0))))
		END,
		ISNULL(o_AddOns.TotalAddOnMonthlyFeeAmount, 0) AS AddOnAmount,

		memb.MembershipDescription,
		memb.MembershipId,

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

		-- Fee Amount is Zero
		CASE
			WHEN ISNULL(cm.MonthlyFee, 0) > 0 THEN 0 ELSE 1 END AS IsFeeAmountZero,

			NULL AS IsValidToRun

FROM datClientEFT c
	INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
	INNER JOIN datClientMembership cm
		ON cm.ClientMembershipGUID = c.ClientMembershipGUID and cm.ClientGUID = c.ClientGUID
	INNER JOIN cfgMembership memb ON memb.MembershipID = cm.MembershipID
	INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
	INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID
	LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
	LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
	-- Tax Calculation
	LEFT OUTER JOIN cfgSalesCodeCenter scc ON cl.CenterID = scc.CenterID
		AND scc.SalesCodeID = @MonthlyFeeSalesCodeID
	LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1 on scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
	LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2 on scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
	LEFT OUTER JOIN cfgSalesCodeMembership scm on scc.SalesCodeCenterID = scm.SalesCodeCenterID
		AND scm.MembershipID = memb.MembershipID
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
	AND scm2.MembershipID = memb.MembershipID
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
						AND scm_AO.MembershipID = memb.MembershipID
					LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_AO ON scm_AO.TaxRate1ID = mTaxRate1_AO.CenterTaxRateID
					LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_AO ON scm_AO.TaxRate2ID = mTaxRate2_AO.CenterTaxRateID

					--CenterMembershipAddOn Level Monthly Fee Sales Code and Tax Rates
					LEFT OUTER JOIN cfgCenterMembership ctrm ON memb.MembershipID = ctrm.MembershipID
						AND cl.CenterID = ctrm.CenterID
					LEFT OUTER JOIN cfgCenterMembershipAddOn ctrmao ON ao.AddOnID = ctrmao.AddOnID
						AND ctrm.CenterMembershipID = ctrmao.CenterMembershipID
					-- Tax Calculation
					LEFT OUTER JOIN cfgSalesCodeCenter scc_CMAO ON cl.CenterID = scc_CMAO.CenterID
						AND ctrmao.MonthlyFeeSalesCodeID = scc_CMAO.SalesCodeID
					LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_CMAO ON scc_CMAO.TaxRate1ID = cTaxRate1_CMAO.CenterTaxRateID
					LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_CMAO ON scc_CMAO.TaxRate2ID = cTaxRate2_CMAO.CenterTaxRateID
					LEFT OUTER JOIN cfgSalesCodeMembership scm_CMAO ON scc_CMAO.SalesCodeCenterID = scm_CMAO.SalesCodeCenterID
						AND memb.MembershipID = scm_CMAO.MembershipID
					LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_CMAO ON scm_CMAO.TaxRate1ID = mTaxRate1_CMAO.CenterTaxRateID
					LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_CMAO ON scm_CMAO.TaxRate2ID = mTaxRate2_CMAO.CenterTaxRateID
				WHERE cmao.ClientMembershipGUID = cm.ClientMembershipGUID
					and cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active'
					and aot.IsMonthlyAddOnType = 1
				GROUP BY cmao.ClientMembershipAddOnID) AS ClientMembershipAddOns
		) o_AddOns
WHERE pc.FeePayCycleId = @feePayCycleId
	AND cl.CenterID = @centerId
	AND cms.ClientMembershipStatusDescriptionShort = 'A'
	AND memb.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
	-- Added Payment Plan Filter
	AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@BatchRunDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))



-- Update if client EFT profile is valid to run
UPDATE #ClientEFTStatus
SET IsValidToRun =  CASE WHEN (IsProfileExpired = 0
						AND IsCreditCardExpired = 0 AND IsMembershipExpired = 0 AnD IsFeeAmountZero = 0) THEN 1 ELSE 0 END




DECLARE @FeeTotal AS DECIMAL(18,4)
DECLARE @WillRunTotal As DECIMAL(18,4)
DECLARE @ExceptionsTotal as DECIMAL(18,4)
DECLARE @FrozenTotal AS DECIMAL(18,4)

SELECT
	@FeeTotal = SUM(estat.Amount + estat.AddOnAmount),
	@ExceptionsTotal = SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END),
	@FrozenTotal = SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END),
	@WillRunTotal = SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0  THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END)

FROM #ClientEFTStatus  estat


SELECT
	estat.MembershipId,
	estat.MembershipDescription,
	COUNT(estat.MembershipDescription) AS MembershipCount,
	SUM(estat.Amount + estat.AddOnAmount) AS MembershipTotal,
	CASE WHEN @FeeTotal = 0 THEN 0 ELSE (SUM(estat.Amount + estat.AddOnAmount)/@FeeTotal) END AS TotalPercent,

	SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN 1 ELSE 0 END) AS ExceptionsCount,
	SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END) AS ExceptionsAmount,
	CASE WHEN @ExceptionsTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END)/@ExceptionsTotal) END AS ExceptionsPercent,

	SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN 1 ELSE 0 END) AS FrozenCount,
	SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END) AS FrozenAmount,
	CASE WHEN @FrozenTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END)/@FrozenTotal) END AS FrozenPercent,

	SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0 THEN 1 ELSE 0 END) AS WillRunCount,
	SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END) AS WillRunAmount,
	CASE WHEN @WillRunTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0 THEN (estat.Amount + estat.AddOnAmount) ELSE 0 END)/@WillRunTotal) END AS WillRunPercent

FROM #ClientEFTStatus  estat
GROUP BY estat.MembershipDescription,
	estat.MembershipId

END
GO
