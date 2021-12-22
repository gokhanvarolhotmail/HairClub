/***********************************************************************

PROCEDURE:				selFeeProjectedToRun

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		02/11/2012

LAST REVISION DATE: 	02/11/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Return Projected Fees To Run for the specified Pay Cycle, Month, Year, and Center.

		02/11/2012 - MVT: Created Stored Proc
		06/18/2012 - JGE: Add Tax Calculation
		08/01/2016 - MLM: Added In-House Payment Plan Processing
		09/06/2016 - SAL: Updated CASE statement for "Amount" to use the Payment Plan Sales Code's tax
							whenever the monthly fee is for a payment plan versus the Monthly Fee Sales
							Code's tax
		09/28/2017 - SAL: Added the return of IsAutoRenew.  This will be true if this is the first pay cycle
							since the membership was auto renewed.
		10/14/2017 - MVT: (TFS #9739) Modified the logic that determines Auto Renewal to use Auto Apply to prevent
						duplicate records from being returned.
		01/30/2019 - SAL: Added the return of Add-On Amount and Total Fees. (TFS #11935)
		04/02/2019 - JLM: Update the logic to determine add-on amount. (TFS #12202)
		06/23/2019 - SAL: Update the logic for memberships' Monthly Fees to consider
								cfgConfigurationMembership.IsEFTProcessingRestrictedByContractBalance (TFS #12679)
	    03/15/2021 - AP: Fix pay cycle dates when the date is 30 TFS14844
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selFeeProjectedToRun 2, 02, 2019, 201

***********************************************************************/
CREATE PROCEDURE [dbo].[selFeeProjectedToRun]
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
		,@AutoRenewSalesCodeID int
	SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'
	SELECT @PaymentPlanSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'MTHPLANPMT'
	SELECT @AutoRenewSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'RENEWAUTO'

	DECLARE @PayCycleValue int
	SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @feePayCycleId)

	IF @month = 2 and @PayCycleValue >28
	   SET @PayCycleValue = 28

	IF @PayCycleValue IS NULL
		RETURN

	DECLARE @BatchRunDate datetime
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@month) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@year), 101)

	DECLARE @PreviousMonth int
	IF (@month = 1)
		SET @PreviousMonth = 12
	ELSE
		SET @PreviousMonth = @month - 1
	  IF (@PreviousMonth = 2 and @PayCycleValue = 30)
	      SET @PayCycleValue = 28

	DECLARE @PreviousBatchRunDate datetime
	SET @PreviousBatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),(@PreviousMonth)) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@year), 101)

	DECLARE @MembershipOrderTypeID int
	SELECT @MembershipOrderTypeID = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'MO'

	-- create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
	(
		ClientGUID uniqueidentifier,
		ClientEFTGUID uniqueidentifier,
		ClientName nvarchar(200),
		Membership nvarchar(50),
		MonthlyFee money,
		AddOnAmount money,
		AccountTypeDescription nvarchar(100),
		IsAutoRenew bit
	)

	-- Insert into temp table
	INSERT INTO @ClientEFTStatus (ClientGUID, ClientEFTGUID, ClientName, Membership, MonthlyFee, AddOnAmount, AccountTypeDescription, IsAutoRenew)

		SELECT
			c.ClientGUID,
			c.ClientEFTGUID,
			cl.ClientFullNameCalc AS ClientName,

			memb.MembershipDescription as Membership,
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
			END AS MonthlyFee,
			ISNULL(o_AddOns.TotalAddOnMonthlyFeeAmount, 0) AS AddOnAmount,
			at.EFTAccountTypeDescription as AccountTypeDescription,

			-- Is First Pay Cycle Since Auto Renew
			CASE
				WHEN CAST(cm.BeginDate AS Date) > @PreviousBatchRunDate and o_sod.SalesCodeID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS IsAutoRenew

		FROM datClientEFT c
			INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
			INNER JOIN datClientMembership cm ON c.ClientMembershipGuid = cm.ClientMembershipGUID
			INNER JOIN cfgMembership memb ON memb.MembershipID = cm.MembershipID
			INNER JOIN cfgConfigurationMembership cfgmem ON memb.MembershipID = cfgmem.MembershipID
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
			--Auto Renew Membership Order
			OUTER APPLY (
				SELECT TOP(1) sod.SalesCodeID
				FROM datSalesOrder so
					INNER JOIN datSalesOrderDetail sod ON sod.SalesOrderGUID = so.SalesOrderGUID
				WHERE so.ClientMembershipGUID = cm.ClientMembershipGUID
					AND CAST(so.OrderDate AS Date) = CAST(cm.BeginDate AS Date)
					AND so.SalesOrderTypeID = @MembershipOrderTypeID
					AND sod.SalesCodeID = @AutoRenewSalesCodeID
				) o_sod
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
				-- Not Frozen
				AND (  (c.Freeze_Start IS NULL AND c.Freeze_End IS NULL)
					OR (c.Freeze_Start IS NULL AND (c.Freeze_End IS NOT NULL AND c.Freeze_End < @BatchRunDate))
					OR (c.Freeze_End IS NULL AND (c.Freeze_Start IS NOT NULL AND c.Freeze_Start > @BatchRunDate))
					OR NOT (@BatchRunDate BETWEEN c.Freeze_Start AND c.Freeze_End) )
				-- Profile is Active
				AND ISNULL(c.IsActiveFlag,0) = 1
				AND ISNULL(stat.IsEFTActiveFlag,0) = 1
				-- Membership Is Active
				AND ( (cm.BeginDate IS NULL AND (cm.EndDate >= @BatchRunDate))
					OR (@BatchRunDate BETWEEN cm.BeginDate AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate))) )
				-- Credit Card Not Expired
				AND ( (at.EFTAccountTypeDescriptionShort = 'CreditCard' AND @BatchRunDate <= c.AccountExpiration)
							OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard') )
				-- Added Payment Plan Filter
				AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@BatchRunDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))
			ORDER BY cm.EndDate

	SELECT
		estat.ClientGUID,
		estat.ClientEFTGUID,
		estat.ClientName,
		estat.Membership,
		estat.MonthlyFee,
		estat.AddOnAmount,
		(estat.MonthlyFee + estat.AddOnAmount) AS TotalFees,
		estat.AccountTypeDescription,
		estat.IsAutoRenew
	FROM @ClientEFTStatus estat

END






SET ANSI_NULLS ON
