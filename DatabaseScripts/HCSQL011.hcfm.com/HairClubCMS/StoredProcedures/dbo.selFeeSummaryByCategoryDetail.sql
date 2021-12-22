/* CreateDate: 05/14/2012 17:40:57.883 , ModifyDate: 02/11/2021 17:49:22.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selFeeSummaryByCategoryDetail

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/04/2011

LAST REVISION DATE: 	08/04/2011

--------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT summary by Category for the specified Pay Cycle, Month, Year, and Center for the specified month.

		08/04/2011 - AS: Created Stored Proc
		06/11/2012 - MLM: Added Tax into the Fee Totals
		08/01/2016 - MLM: Added In-House Payment Plan Processing
		09/06/2016 - SAL: Updated CASE statement for "Amount" to use the Payment Plan Sales Code's tax
							whenever the monthly fee is for a payment plan versus the Monthly Fee Sales
							Code's tax
		06/23/2019 - SAL: Update the logic for memberships' Monthly Fees to consider
								cfgConfigurationMembership.IsEFTProcessingRestrictedByContractBalance (TFS #12679)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selFeeSummaryByCategoryDetail 1, 5, 2012, 204

***********************************************************************/
CREATE PROCEDURE [dbo].[selFeeSummaryByCategoryDetail]
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

	IF @month = 2 and @PayCycleValue >28
	   SET @PayCycleValue = 28

	IF @PayCycleValue IS NULL
		RETURN

	DECLARE @BatchRunDate datetime
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@month) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@year), 101)


	-- create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
	(
		ClientEFTGUID uniqueidentifier,
		Amount money NOT NULL,
		FreezeStartDate datetime NULL,
		FreezeEndDate datetime NULL,
		AccountExpirationDate datetime NULL,
		MembershipBeginDate datetime NULL,
		MembershipEndDate datetime NULL,
		MembershipDescription nvarchar(100) NOT NULL,
		IsProfileExpired bit NOT NULL,
		IsProfileFrozen bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL,
		IsFeeAmountZero bit NOT NULL,
		IsValidToRun bit NULL
	)


	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (ClientEFTGUID, Amount, FreezeStartDate, FreezeEndDate, AccountExpirationDate, MembershipBeginDate, MembershipEndDate,
						MembershipDescription, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired, IsFeeAmountZero)
		SELECT
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

			c.Freeze_Start,
			c.Freeze_End,
			c.AccountExpiration,
			cm.BeginDate,
			cm.EndDate,

			memb.MembershipDescription,

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
				WHEN ISNULL(cm.MonthlyFee, 0) > 0 THEN 0 ELSE 1 END

		FROM datClientEFT c
		 INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
		 INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = c.ClientMembershipGUID
		 INNER JOIN cfgMembership memb ON memb.MembershipID = cm.MembershipID
		 INNER JOIN cfgConfigurationMembership cfgmem ON memb.MembershipID = cfgmem.MembershipID
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
		WHERE pc.FeePayCycleId = @feePayCycleId
			AND cl.CenterID = @centerId
			AND cms.ClientMembershipStatusDescriptionShort = 'A'
			AND memb.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
			-- Added Payment Plan Filter
			AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@BatchRunDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))

	-- Update if client EFT profile is valid to run
	UPDATE @ClientEFTStatus SET
		IsValidToRun = CASE WHEN IsProfileExpired = 0 AND IsProfileFrozen = 0
								AND IsCreditCardExpired = 0 AND IsMembershipExpired = 0 AND IsFeeAmountZero = 0 THEN 1 ELSE 0 END

	SELECT
		c.ClientFullNameCalc,
		c.ClientGUID,
		estat.Amount,
		estat.FreezeStartDate,
		estat.FreezeEndDate,
		estat.AccountExpirationDate,
		estat.MembershipBeginDate,
		estat.MembershipEndDate,
		estat.MembershipDescription,
		estat.IsProfileExpired,
		estat.IsProfileFrozen,
		estat.IsCreditCardExpired,
		estat.IsMembershipExpired,
		estat.IsFeeAmountZero,
		estat.IsValidToRun
	FROM @ClientEFTStatus estat
		INNER JOIN datClientEFT ce ON ce.ClientEFTGUID = estat.ClientEFTGUID
		INNER JOIN datClient c ON c.ClientGUID = ce.ClientGUID
	WHERE estat.IsValidToRun = 0

END
GO
