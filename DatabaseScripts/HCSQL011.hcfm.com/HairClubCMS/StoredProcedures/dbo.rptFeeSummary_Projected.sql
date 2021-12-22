/* CreateDate: 04/24/2014 11:26:04.547 , ModifyDate: 05/20/2019 11:11:05.347 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************************************************************

PROCEDURE:				rptFeeSummary_Projected
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED: 		04/23/2014

---------------------------------------------------------------------------------------------------------------
NOTES: 	@feePayCycleId = 1 is the 1st of MONTH; 2 = 15th of Month
---------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
12/01/2017 - RH - Added code to find the Last Payment Transaction Type (credit card, cash or ACH); added EFTAccountTypeDescription (#133612)
05/08/2019 - RH - Added AddOn Membership Fees (Case #7719)
---------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

rptFeeSummary_Projected 1, 4, 2019, 240

***************************************************************************************************************/

CREATE PROCEDURE [dbo].[rptFeeSummary_Projected]
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
SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'

DECLARE @PayCycleValue int
SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @feePayCycleId)

IF @PayCycleValue IS NULL
	RETURN

DECLARE @BatchRunDate DATETIME
DECLARE @PreviousBatchRunDate DATETIME
DECLARE @PreviousBatchEndDate DATETIME
SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@month) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@year), 101)
SET @PreviousBatchRunDate = DATEADD(M,-1,@BatchRunDate)			--Use the @PreviousBatchRunDate to find the Transaction Type (credit card, cash, or ACH)
SET @PreviousBatchEndDate = DATEADD(D,1,@PreviousBatchRunDate)  --Add one day to the @PreviousBatchRunDate as the "end date" to be sure to include the batch for the previous day


/*************Create temp tables - one for each EFT profile, and one for the Previous Run ****************************************/


CREATE TABLE #ClientEFTStatus
(
	ClientGUID  NVARCHAR(50) NOT NULL,
	ClientEFTGUID  NVARCHAR(50) NOT NULL,
	ClientIdentifier INT NOT NULL,
	ClientFullName nvarchar(200),
	EFTAccountTypeDescription NVARCHAR(50),
	MembershipDescription nvarchar(50),
	MembershipStart date,
	MembershipEnd Date,
	MonthlyFee DECIMAL(18,4),
	AddOnMonthlyFee DECIMAL(18,4),
	EFTCreditCardExpiration date,
	EFTFreezeStart date,
	EFTFreezeEnd date,
	IsProfileExpired bit NOT NULL,
	IsCreditCardExpired bit NOT NULL,
	IsMembershipExpired bit NOT NULL,
	IsFeeAmountZero bit NOT NULL
)


CREATE TABLE #PreviousRun(CenterID INT
,	FeeDate datetime
,	PayCycleTransactionTypeID INT
,	PayCycleTransactionTypeDescription	NVARCHAR(25)
,	ClientGUID NVARCHAR(50)
,	ClientIdentifier NVARCHAR(25)
)


 CREATE TABLE #AddOn(
	CenterID INT
,	ClientIdentifier INT
,	ClientFullNameCalc  NVARCHAR(150)
,	ClientGUID  NVARCHAR(50)
,	AddOnMonthlyFee DECIMAL(18,4)
 )


/************ Insert into temp table if EFT Profile is valid to run *******************************************************/

INSERT INTO #ClientEFTStatus
SELECT
	c.ClientGUID,
	c.ClientEFTGUID,
	cl.ClientIdentifier,
	cl.ClientFullNameCalc AS ClientName,
	EFTAccountTypeDescription,
	memb.MembershipDescription as Membership,
	cm.BeginDate as MembershipStart,
	cm.EndDate as MembershipEnd,
	ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0)))) AS MonthlyFee,
	NULL AS AddOnMonthlyFee,
	c.AccountExpiration,
	c.Freeze_Start,
	c.Freeze_End,

	-- EFT Profile is active
	CASE
		WHEN (c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0)
				OR stat.IsEFTActiveFlag IS NULL
				OR (stat.IsEFTActiveFlag = 0 AND stat.IsFrozenFlag = 0 )
		THEN 1 ELSE 0 END,

	-- Credit Card Not Expired
	CASE
		WHEN (at.EFTAccountTypeDescriptionShort = 'CreditCard'
					AND @BatchRunDate <= c.AccountExpiration)
				OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard') THEN 0
			ELSE 1 END,

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
	INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
	INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID
	LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
	LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
	-- Tax Calculation
	LEFT OUTER JOIN cfgSalesCodeCenter scc ON cl.CenterID = scc.CenterID
		AND scc.SalesCodeID = @MonthlyFeeSalesCodeID
	LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1 ON scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
	LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2 ON scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
	LEFT OUTER JOIN cfgSalesCodeMembership scm ON scc.SalesCodeCenterID = scm.SalesCodeCenterID
		AND scm.MembershipID = memb.MembershipID
	LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1 ON scm.TaxRate1ID = mTaxRate1.CenterTaxRateID
	LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2 ON scm.TaxRate2ID = mTaxRate2.CenterTaxRateID
WHERE pc.FeePayCycleId = @feePayCycleId
	AND cl.CenterID = @centerId
	AND cms.ClientMembershipStatusDescriptionShort = 'A'
	AND memb.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
	AND ( (c.Freeze_Start IS NULL OR (c.Freeze_End IS NULL AND  @BatchRunDate < c.Freeze_Start))
			OR (c.Freeze_End IS NOT NULL AND ((@BatchRunDate < c.Freeze_Start) OR (@BatchRunDate > c.Freeze_End))) )

--Find Add-On fees
INSERT INTO #AddOn
SELECT CM.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID
,   SUM(ISNULL(CMA.MonthlyFee,0)) AS AddOnMonthlyFee
FROM dbo.datClientMembershipAddOn CMA
INNER JOIN dbo.cfgAddOn ADDON
	ON ADDON.AddOnID = CMA.AddOnID
INNER JOIN dbo.datClientMembership CM
	ON CM.ClientMembershipGUID = CMA.ClientMembershipGUID
INNER JOIN dbo.datClient CLT
	ON CLT.ClientGUID = CM.ClientGUID
INNER JOIN dbo.lkpAddOnType AOT
	ON AOT.AddOnTypeID = ADDON.AddOnTypeID
WHERE  CMA.ClientMembershipAddOnStatusID = 1 --Active
AND CMA.MonthlyFee IS NOT NULL
AND CM.CenterID = @centerId
AND AOT.IsMonthlyAddOnType = 1
GROUP BY CM.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID

--UPDATE AddOnMonthlyFee
UPDATE  EFT
SET EFT.AddOnMonthlyFee =  ISNULL(#AddOn.AddOnMonthlyFee,0)
FROM #ClientEFTStatus EFT
INNER JOIN #AddOn
ON #AddOn.ClientIdentifier = EFT.ClientIdentifier
WHERE EFT.AddOnMonthlyFee IS NULL

/********** Find info from the Previous Fee Run - specifically, the PayCycleTransactionTypeDescription *************/

INSERT INTO #PreviousRun
SELECT fee.CenterID
,	fee.RunDate AS 'FeeDate'
,	PCT.PayCycleTransactionTypeID
,	PCTT.PayCycleTransactionTypeDescription
,	PCT.ClientGUID
,	C.ClientIdentifier
FROM dbo.datPayCycleTransaction PCT
INNER JOIN lkpPayCycleTransactionType PCTT
	ON PCT.PayCycleTransactionTypeID = PCTT.PayCycleTransactionTypeID
INNER JOIN datClient C
	ON PCT.ClientGUID = C.ClientGUID
INNER JOIN datCenterFeeBatch fee
	ON fee.CenterFeeBatchGUID = PCT.CenterFeeBatchGUID
WHERE fee.RunDate between @PreviousBatchRunDate AND @PreviousBatchEndDate
	AND PCT.CenterDeclineBatchGUID IS NULL
	AND fee.CenterID = @CenterID
	AND PCT.IsSuccessfulFlag <> 0

/*********** INSERT Previous Run Transaction Type ***************************************************************/

SELECT
	estat.ClientGUID,
	estat.ClientEFTGUID,
	estat.ClientIdentifier,
	estat.ClientFullName AS ClientName,
	estat.EFTAccountTypeDescription,
	estat.MembershipDescription,
	estat.MembershipStart,
	estat.MembershipEnd,
	estat.EFTCreditCardExpiration AS CreditCardExpiration,
	estat.EFTFreezeStart AS FreezeStart,
	estat.EFTFreezeEnd AS FreezeEnd,
	estat.MonthlyFee,
		estat.AddOnMonthlyFee,
	estat.IsCreditCardExpired,
	estat.IsMembershipExpired,
	estat.IsProfileExpired,
	estat.IsFeeAmountZero,
	PR.PayCycleTransactionTypeDescription AS 'PreviousRunTransactionType'
FROM #ClientEFTStatus estat
LEFT JOIN #PreviousRun PR
	ON estat.ClientGUID = PR.ClientGUID
WHERE estat.IsMembershipExpired <> 1
AND estat.IsCreditCardExpired <> 1
AND estat.IsProfileExpired <> 1
AND estat.IsFeeAmountZero <> 1



END
GO
