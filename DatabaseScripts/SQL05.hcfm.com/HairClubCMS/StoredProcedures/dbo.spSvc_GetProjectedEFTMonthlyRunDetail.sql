/* CreateDate: 06/30/2020 09:54:55.857 , ModifyDate: 09/14/2020 13:42:52.820 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetProjectedEFTMonthlyRunDetail
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/30/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetProjectedEFTMonthlyRunDetail 2, 1
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetProjectedEFTMonthlyRunDetail]
(
	@CenterType INT,
	@FeePayCycleID INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Day INT
,		@Month INT
,		@Year INT
,		@MonthlyFeeSalesCodeID INT
,		@PaymentPlanSalesCodeID INT
,		@AutoRenewSalesCodeID INT
,		@PayCycleValue INT
,		@BatchRunDate DATETIME
,		@PreviousMonth INT
,		@PreviousBatchRunDate DATETIME
,		@MembershipOrderTypeID int


SET @Day = DAY(CURRENT_TIMESTAMP)
SET @Month = CASE WHEN @Day BETWEEN 1 AND 15 THEN MONTH(CURRENT_TIMESTAMP) ELSE MONTH(DATEADD(MONTH, 1, CURRENT_TIMESTAMP)) END
SET @Year = YEAR(CURRENT_TIMESTAMP)
SET @MonthlyFeeSalesCodeID = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE')
SET @PaymentPlanSalesCodeID = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'MTHPLANPMT')
SET @AutoRenewSalesCodeID = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'RENEWAUTO')
SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @FeePayCycleID)
SET @BatchRunDate = CONVERT(DATETIME, CONVERT(NVARCHAR(2), @Month) + '/' + CONVERT(NVARCHAR(2), @PayCycleValue) + '/' + CONVERT(NVARCHAR(4), @Year), 101)
SET @PreviousMonth = CASE WHEN ( @Month = 1 ) THEN 12 ELSE ( @Month - 1 ) END
SET @PreviousBatchRunDate = CONVERT(DATETIME, CONVERT(NVARCHAR(2), (@PreviousMonth)) + '/' + CONVERT(NVARCHAR(2), @PayCycleValue) + '/' + CONVERT(NVARCHAR(4), @Year), 101)
SET @MembershipOrderTypeID = (SELECT SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'MO')


IF @PayCycleValue IS NULL
	RETURN


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	Area VARCHAR(100)
,	CenterID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	CenterType NVARCHAR(100)
)

CREATE TABLE #ClientEFTStatus (
	ClientEFTGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	MembershipID INT
,	ClientGUID UNIQUEIDENTIFIER
,	Area VARCHAR(100)
,	CenterID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	AccountTypeId INT
,	Amount MONEY
,	AddOnAmount MONEY
,	FreezeStartDate DATETIME
,	FreezeEndDate DATETIME
,	AccountExpirationDate DATETIME
,	MembershipBeginDate DATETIME
,	MembershipEndDate DATETIME
,	MembershipDescription NVARCHAR(100)
,	IsProfileExpired BIT
,	IsProfileFrozen BIT
,	IsCreditCardExpired BIT
,	IsMembershipExpired BIT
,	IsFeeAmountZero BIT
,	IsValidToRun BIT
)

CREATE TABLE #Client (
	ClientGUID UNIQUEIDENTIFIER
)

CREATE TABLE #ClientMembershipAddOn (
	ClientMembershipGUID UNIQUEIDENTIFIER
,	TotalAddOnMonthlyFeeAmount MONEY
)

CREATE TABLE #LastServiceDate (
	ClientGUID UNIQUEIDENTIFIER
,	LastServiceDate DATETIME
)

CREATE TABLE #ClientPhone (
	ClientGUID UNIQUEIDENTIFIER
,	PhoneNumber NVARCHAR(15)
,	PhoneType NVARCHAR(100)
,	CanConfirmAppointmentByCall BIT
,	CanConfirmAppointmentByText BIT
,	CanContactForPromotionsByCall BIT
,	CanContactForPromotionsByText BIT
,	ClientPhoneSortOrder INT
)


/********************************** Get list of centers *************************************/
IF ( @CenterType = 0 OR @CenterType = 2 )
   BEGIN
         INSERT INTO #Center
                SELECT  cma.CenterManagementAreaDescription AS 'Area'
                ,       ctr.CenterID
				,		ctr.CenterNumber
                ,       ctr.CenterDescriptionFullCalc
                ,       ct.CenterTypeDescription
                FROM    cfgCenter ctr
						INNER JOIN lkpCenterType ct
							ON ct.CenterTypeID = ctr.CenterTypeID
                        INNER JOIN cfgCenterManagementArea cma
							ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
                WHERE   ct.CenterTypeDescriptionShort = 'C'
                        AND ctr.IsActiveFlag = 1
   END

IF ( @CenterType = 0 OR @CenterType = 8 )
   BEGIN
         INSERT INTO #Center
                SELECT  cma.CenterManagementAreaDescription AS 'Area'
                ,       ctr.CenterID
				,		ctr.CenterNumber
                ,       ctr.CenterDescriptionFullCalc
                ,       ct.CenterTypeDescriptionShort
                FROM    cfgCenter ctr
						INNER JOIN lkpCenterType ct
							ON ct.CenterTypeID = ctr.CenterTypeID
                        INNER JOIN cfgCenterManagementArea cma
							ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
                WHERE   ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
                        AND ctr.IsActiveFlag = 1
   END


/********************************** Get Client EFT Profile Data *************************************/
INSERT	INTO #ClientEFTStatus
		SELECT	c.ClientEFTGUID
		,		c.ClientMembershipGUID
		,		memb.MembershipID
		,		c.ClientGUID
		,		ctr.Area
		,		ctr.CenterID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		c.EFTAccountTypeID
		,		CASE WHEN pp.PaymentPlanID IS NULL THEN
						CASE WHEN cfgmem.IsEFTProcessingRestrictedByContractBalance = 0 THEN
								ISNULL(cm.MonthlyFee, 0)
								* (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate, 0)) + ISNULL(mTaxRate2.TaxRate, ISNULL(cTaxRate2.TaxRate, 0))))
							WHEN cm.ContractPrice <= cm.ContractPaidAmount THEN 0.0
							WHEN (cm.ContractPrice - cm.ContractPaidAmount) > 0
								AND (cm.ContractPrice - cm.ContractPaidAmount) < ISNULL(cm.MonthlyFee, 0.0) THEN
				(cm.ContractPrice - cm.ContractPaidAmount)
				* (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate, 0)) + ISNULL(mTaxRate2.TaxRate, ISNULL(cTaxRate2.TaxRate, 0))))
							ELSE
								ISNULL(cm.MonthlyFee, 0)
								* (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate, 0)) + ISNULL(mTaxRate2.TaxRate, ISNULL(cTaxRate2.TaxRate, 0))))
						END
					WHEN pp.PaymentPlanID IS NOT NULL
						AND ISNULL(pp.RemainingBalance, 0) >= ISNULL(cm.MonthlyFee, 0) THEN
				(ISNULL(cm.MonthlyFee, 0))
				* (1 + (ISNULL(mTaxRate1_2.TaxRate, ISNULL(cTaxRate1_2.TaxRate, 0)) + ISNULL(mTaxRate2_2.TaxRate, ISNULL(cTaxRate2_2.TaxRate, 0))))
					WHEN pp.PaymentPlanID IS NOT NULL
						AND ISNULL(pp.RemainingBalance, 0) < ISNULL(cm.MonthlyFee, 0) THEN
				(ISNULL(pp.RemainingBalance, 0))
				* (1 + (ISNULL(mTaxRate1_2.TaxRate, ISNULL(cTaxRate1_2.TaxRate, 0)) + ISNULL(mTaxRate2_2.TaxRate, ISNULL(cTaxRate2_2.TaxRate, 0))))
				END
		,		NULL AS 'AddOnAmount'
		,		c.Freeze_Start
		,		c.Freeze_End
		,		c.AccountExpiration
		,		cm.BeginDate
		,		cm.EndDate
		,		memb.MembershipDescription
		-- EFT Profile is active
		,		CASE WHEN c.IsActiveFlag IS NULL
						OR	c.IsActiveFlag = 0
						OR	stat.IsEFTActiveFlag IS NULL
						OR	stat.IsEFTActiveFlag = 0 THEN 1
					ELSE 0
				END
		-- Account is not Frozen
		,		CASE WHEN (c.Freeze_Start IS NULL AND c.Freeze_End IS NULL)
						OR (c.Freeze_End IS NULL AND @BatchRunDate < c.Freeze_Start)
						OR (c.Freeze_Start IS NULL AND @BatchRunDate > c.Freeze_End)
						OR (@BatchRunDate < c.Freeze_Start OR @BatchRunDate > c.Freeze_End) THEN 0
					ELSE 1
				END
		-- Credit Card Not Expired
		,		CASE WHEN (
							at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND @BatchRunDate <= c.AccountExpiration
						)
						OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard') THEN 0
					ELSE 1
				END
		-- Membership is  Active
		,		CASE WHEN cm.BeginDate IS NULL
						OR	(
								cm.BeginDate <= @BatchRunDate
								AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= @BatchRunDate
							) THEN 0
					ELSE 1
				END
		-- Fee Amount is Zero
		,		CASE WHEN ISNULL(cm.MonthlyFee, 0) > 0 THEN 0 ELSE 1 END
		,		NULL
		FROM	datClientEFT c
				INNER JOIN datClient cl
					ON cl.ClientGUID = c.ClientGUID
				INNER JOIN #Center ctr
					ON ctr.CenterID = cl.CenterID
				INNER JOIN datClientMembership cm
					ON cm.ClientMembershipGUID = c.ClientMembershipGUID
				INNER JOIN cfgMembership memb
					ON memb.MembershipID = cm.MembershipID
				INNER JOIN cfgConfigurationMembership cfgmem
					ON memb.MembershipID = cfgmem.MembershipID
				INNER JOIN lkpClientMembershipStatus cms
					ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
				INNER JOIN lkpFeePayCycle pc
					ON pc.FeePayCycleID = c.FeePayCycleID
				LEFT OUTER JOIN lkpEFTAccountType at
					ON c.EFTAccountTypeID = at.EFTAccountTypeID
				LEFT OUTER JOIN lkpEFTStatus stat
					ON stat.EFTStatusID = c.EFTStatusID
				-- Tax Calculation
				LEFT OUTER JOIN cfgSalesCodeCenter scc
					ON cl.CenterID = scc.CenterID
					AND scc.SalesCodeID = @MonthlyFeeSalesCodeID
				LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1
					ON scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2
					ON scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
				LEFT OUTER JOIN cfgSalesCodeMembership scm
					ON scc.SalesCodeCenterID = scm.SalesCodeCenterID
					AND scm.MembershipID = memb.MembershipID
				LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1
					ON scm.TaxRate1ID = mTaxRate1.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2
					ON scm.TaxRate2ID = mTaxRate2.CenterTaxRateID
				--Adding PaymentPlan
				LEFT OUTER JOIN datPaymentPlan pp
					ON c.ClientMembershipGUID = pp.ClientMembershipGUID
				LEFT OUTER JOIN lkpPaymentPlanStatus pps
					ON pp.PaymentPlanStatusID = pps.PaymentPlanStatusID
				LEFT OUTER JOIN cfgSalesCodeCenter scc2
					ON cl.CenterID = scc2.CenterID
					AND scc2.SalesCodeID = @PaymentPlanSalesCodeID
				LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_2
					ON scc2.TaxRate1ID = cTaxRate1_2.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_2
					ON scc2.TaxRate2ID = cTaxRate2_2.CenterTaxRateID
				LEFT OUTER JOIN cfgSalesCodeMembership scm2
					ON scc2.SalesCodeCenterID = scm2.SalesCodeCenterID
					AND scm2.MembershipID = memb.MembershipID
				LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_2
					ON scm2.TaxRate1ID = mTaxRate1_2.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_2
					ON scm2.TaxRate2ID = mTaxRate2_2.CenterTaxRateID
		WHERE	pc.FeePayCycleID = @FeePayCycleID
				AND cms.ClientMembershipStatusDescriptionShort = 'A'
				AND memb.MembershipDescriptionShort NOT IN ( 'CANCEL', 'RETAIL' )
				-- Added Payment Plan Filter
				AND ( ( cm.HasInHousePaymentPlan = 0 )
						OR ( pp.StartDate <= CONVERT(DATE, @BatchRunDate)
								AND ( pp.SatisfactionDate IS NULL )
								AND pps.PaymentPlanStatusDescriptionShort = 'Active' ) )


-- Update if client EFT profile is valid to run
UPDATE	#ClientEFTStatus
SET		IsValidToRun = CASE WHEN IsProfileExpired = 0
								AND IsProfileFrozen = 0
								AND IsCreditCardExpired = 0
								AND IsMembershipExpired = 0
								AND IsFeeAmountZero = 0 THEN 1
						ELSE 0
					END


CREATE NONCLUSTERED INDEX IDX_ClientEFTStatus_CenterID ON #ClientEFTStatus (CenterID);
CREATE NONCLUSTERED INDEX IDX_ClientEFTStatus_ClientMembershipGUID ON #ClientEFTStatus (ClientMembershipGUID);
CREATE NONCLUSTERED INDEX IDX_ClientEFTStatus_MembershipID ON #ClientEFTStatus (MembershipID);
CREATE NONCLUSTERED INDEX IDX_ClientEFTStatus_ClientGUID ON #ClientEFTStatus (ClientGUID);


UPDATE STATISTICS #ClientEFTStatus;


/********************************** Get Distinct Client Data *************************************/
INSERT	INTO #Client
		SELECT	DISTINCT
				ces.ClientGUID
		FROM	#ClientEFTStatus ces


CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client (ClientGUID);


UPDATE STATISTICS #Client;


/********************************** Get Add-On Data *************************************/
INSERT	INTO #ClientMembershipAddOn
		SELECT	ClientMembershipGUID
		,		SUM(ClientMembershipAddOns.MonthlyFeeSubTotals) AS 'TotalAddOnMonthlyFeeAmount'
		FROM	(
					SELECT	ces.ClientMembershipGUID
					,		SUM(CASE WHEN cmao.ContractPrice <= cmao.ContractPaidAmount THEN 0.0
									WHEN cmao.ContractBalanceAmount < COALESCE(cmao.MonthlyFee, 0.0) THEN cmao.ContractBalanceAmount
									ELSE COALESCE(cmao.MonthlyFee, 0.0)
								END
								*	(1
									+	(COALESCE(mTaxRate1_CMAO.TaxRate, cTaxRate1_CMAO.TaxRate, mTaxRate1_AO.TaxRate, cTaxRate1_AO.TaxRate, 0.0)
										+ COALESCE(mTaxRate2_CMAO.TaxRate, cTaxRate2_CMAO.TaxRate, mTaxRate2_AO.TaxRate, cTaxRate2_AO.TaxRate, 0.0)
										)
									)
							) AS 'MonthlyFeeSubTotals'
					FROM	datClientMembershipAddOn cmao
							INNER JOIN #ClientEFTStatus ces
								ON ces.ClientMembershipGUID = cmao.ClientMembershipGUID
							INNER JOIN lkpClientMembershipAddOnStatus cmaos
								ON cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
							--AddOn Level Monthly Fee Sales Code and Tax Rates
							INNER JOIN cfgAddOn ao
								ON cmao.AddOnID = ao.AddOnID
							INNER JOIN lkpAddOnType aot
								ON ao.AddOnTypeID = aot.AddOnTypeID
							-- Tax Calculation
							LEFT OUTER JOIN cfgSalesCodeCenter scc_AO
								ON ces.CenterID = scc_AO.CenterID
								AND ao.MonthlyFeeSalesCodeID = scc_AO.SalesCodeID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_AO
								ON scc_AO.TaxRate1ID = cTaxRate1_AO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_AO
								ON scc_AO.TaxRate2ID = cTaxRate2_AO.CenterTaxRateID
							LEFT OUTER JOIN cfgSalesCodeMembership scm_AO
								ON scc_AO.SalesCodeCenterID = scm_AO.SalesCodeCenterID
								AND scm_AO.MembershipID = ces.MembershipID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_AO
								ON scm_AO.TaxRate1ID = mTaxRate1_AO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_AO
								ON scm_AO.TaxRate2ID = mTaxRate2_AO.CenterTaxRateID
							--CenterMembershipAddOn Level Monthly Fee Sales Code and Tax Rates
							LEFT OUTER JOIN cfgCenterMembership ctrm
								ON ces.MembershipID = ctrm.MembershipID
								AND ces.CenterID = ctrm.CenterID
							LEFT OUTER JOIN cfgCenterMembershipAddOn ctrmao
								ON ao.AddOnID = ctrmao.AddOnID
								AND ctrm.CenterMembershipID = ctrmao.CenterMembershipID
							-- Tax Calculation
							LEFT OUTER JOIN cfgSalesCodeCenter scc_CMAO
								ON ces.CenterID = scc_CMAO.CenterID
								AND ctrmao.MonthlyFeeSalesCodeID = scc_CMAO.SalesCodeID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1_CMAO
								ON scc_CMAO.TaxRate1ID = cTaxRate1_CMAO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2_CMAO
								ON scc_CMAO.TaxRate2ID = cTaxRate2_CMAO.CenterTaxRateID
							LEFT OUTER JOIN cfgSalesCodeMembership scm_CMAO
								ON scc_CMAO.SalesCodeCenterID = scm_CMAO.SalesCodeCenterID
								AND ces.MembershipID = scm_CMAO.MembershipID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1_CMAO
								ON scm_CMAO.TaxRate1ID = mTaxRate1_CMAO.CenterTaxRateID
							LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2_CMAO
								ON scm_CMAO.TaxRate2ID = mTaxRate2_CMAO.CenterTaxRateID
					WHERE	cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active'
							AND aot.IsMonthlyAddOnType = 1
					GROUP BY ces.ClientMembershipGUID
					,		cmao.ClientMembershipAddOnID
				) ClientMembershipAddOns
		GROUP BY ClientMembershipGUID


CREATE NONCLUSTERED INDEX IDX_ClientMembershipAddOn_ClientMembershipGUID ON #ClientMembershipAddOn (ClientMembershipGUID);


UPDATE STATISTICS #ClientMembershipAddOn;


UPDATE	ces
SET		ces.AddOnAmount = ISNULL(cmao.TotalAddOnMonthlyFeeAmount, 0)
FROM	#ClientEFTStatus ces
		LEFT OUTER JOIN #ClientMembershipAddOn cmao
			ON cmao.ClientMembershipGUID = ces.ClientMembershipGUID


/********************************** Get Client Full Service Data *************************************/
INSERT	INTO #LastServiceDate
		SELECT	clt.ClientSSID AS 'ClientGUID'
		,		MAX(dd.FullDate) AS 'LastServiceDate'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN #Client c
					ON c.ClientGUID = clt.ClientSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
		WHERE   sc.SalesCodeDescriptionShort IN ( 'SVC', 'SVCSOL', 'SVCPCP' )
				AND so.IsVoidedFlag = 0
		GROUP BY clt.ClientSSID


CREATE NONCLUSTERED INDEX IDX_LastServiceDate_ClientGUID ON #LastServiceDate (ClientGUID);


UPDATE STATISTICS #LastServiceDate;


/********************************** Get Client Phone Data *************************************/
INSERT	INTO #ClientPhone
		SELECT	dcp.ClientGUID
		,		dcp.PhoneNumber
		,		pt.PhoneTypeDescription AS 'PhoneType'
		,		dcp.CanConfirmAppointmentByCall
		,		dcp.CanConfirmAppointmentByText
		,		dcp.CanContactForPromotionsByCall
		,		dcp.CanContactForPromotionsByText
		,		dcp.ClientPhoneSortOrder
		FROM	datClientPhone dcp WITH (NOLOCK)
				INNER JOIN #Client c
					ON c.ClientGUID = dcp.ClientGUID
				INNER JOIN lkpPhoneType pt WITH (NOLOCK)
					ON pt.PhoneTypeID = dcp.PhoneTypeID
		WHERE	dcp.ClientPhoneSortOrder = 1
		GROUP BY dcp.ClientGUID
		,		dcp.PhoneNumber
		,		pt.PhoneTypeDescription
		,		dcp.CanConfirmAppointmentByCall
		,		dcp.CanConfirmAppointmentByText
		,		dcp.CanContactForPromotionsByCall
		,		dcp.CanContactForPromotionsByText
		,		dcp.ClientPhoneSortOrder


CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone (ClientGUID);


UPDATE STATISTICS #ClientPhone;
SELECT TOP 1000 * FROM datClient clt

/********************************** Combine Data *************************************/
SELECT	estat.Area
,		estat.CenterDescription AS 'CenterName'
,		c.ClientIdentifier
,		c.ClientFullNameAltCalc AS 'ClientName'
,		CASE WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', '')))) > 0  -- Invalid characters
			OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be starting character
			OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be ending character
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%'                 -- Must contain at least one @ and one .
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%..%'                      -- Cannot have two periods in a row
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@%@%'                     -- Cannot have two @ anywhere
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.@%'
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.cm'
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.or'
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
			THEN ''
			ELSE LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(c.EMailAddress, ''), ']', ''), '[', '')))
		END AS 'EmailAddress'
,		ISNULL(p.PhoneNumber, '') AS 'PhoneNumber'
,		ISNULL(p.PhoneType, '') AS 'PhoneType'
,		estat.AccountTypeId
,		act.EFTAccountTypeDescription AS 'AccountType'
,		estat.MembershipDescription AS 'Membership'
,		CONVERT(VARCHAR(11), CAST(estat.MembershipBeginDate AS DATE), 101) AS 'MembershipBeginDate'
,		CONVERT(VARCHAR(11), CAST(estat.MembershipEndDate AS DATE), 101) AS 'MembershipEndDate'
,		estat.Amount AS 'FeeAmount'
,		estat.AddOnAmount
,		ISNULL((estat.Amount + estat.AddOnAmount), 0) AS 'TotalFees'
,		ISNULL(CONVERT(VARCHAR(11), CAST(estat.FreezeStartDate AS DATE), 101), '') AS 'FreezeStartDate'
,		ISNULL(CONVERT(VARCHAR(11), CAST(estat.FreezeEndDate AS DATE), 101), '') AS 'FreezeEndDate'
,		ISNULL(fr.FeeFreezeReasonDescription, '') AS 'FreezeReason'
,		ISNULL(CONVERT(VARCHAR(11), CAST(ls.LastServiceDate AS DATE), 101), '') AS 'LastServiceDate'
,		estat.AccountExpirationDate
,		c.ARBalance
,		estat.IsProfileExpired
,		estat.IsProfileFrozen
,		estat.IsCreditCardExpired
,		estat.IsMembershipExpired
,		estat.IsFeeAmountZero
,		estat.IsValidToRun
,		ISNULL(c.DoNotCallFlag, 0) AS 'DoNotCallFlag'
,		ISNULL(c.DoNotContactFlag, 0) AS 'DoNotContactFlag'
INTO	#Data
FROM	#ClientEFTStatus estat
		INNER JOIN lkpEFTAccountType act
			ON estat.AccountTypeId = act.EFTAccountTypeID
		INNER JOIN datClientEFT ce
			ON ce.ClientEFTGUID = estat.ClientEFTGUID
		INNER JOIN datClient c
			ON c.ClientGUID = ce.ClientGUID
        LEFT OUTER JOIN lkpFeeFreezeReason fr
            ON ce.FeeFreezeReasonId = fr.FeeFreezeReasonID
		LEFT OUTER JOIN #LastServiceDate ls
			ON ls.ClientGUID = estat.ClientGUID
		LEFT OUTER JOIN #ClientPhone p
			ON p.ClientGUID = c.ClientGUID


/********************************** Import Data *************************************/
TRUNCATE TABLE tmpProjectedEFTMonthlyDetail


INSERT	INTO tmpProjectedEFTMonthlyDetail
		SELECT	d.Area
		,		d.CenterName
		,		d.ClientIdentifier
		,		d.ClientName
		,		d.EmailAddress
		,		d.PhoneNumber
		,		d.PhoneType
		,		d.AccountTypeId
		,		d.AccountType
		,		d.Membership
		,		d.MembershipBeginDate
		,		d.MembershipEndDate
		,		d.FeeAmount
		,		d.AddOnAmount
		,		d.TotalFees
		,		d.FreezeStartDate
		,		d.FreezeEndDate
		,		d.FreezeReason
		,		d.LastServiceDate
		,		d.ARBalance
		,		d.DoNotCallFlag
		,		d.DoNotContactFlag
		FROM	#Data d
		ORDER BY d.Area
		,		d.CenterName
		,		d.AccountTypeId
		,		d.ClientName


END
GO
