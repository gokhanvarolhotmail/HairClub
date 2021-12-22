/**********************************************************************************************************

PROCEDURE:				rptFeeExceptions

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		02/11/2012

LAST REVISION DATE: 	02/11/2012

-------------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT Exceptions for the specified Pay Cycle, Month, Year, and Center.
@feePayCycleId = 1 is the 1st of MONTH; 2 = 15th of Month
-------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
02/11/2012 - MVT: Created Stored Proc
06/11/2012 - MLM: Added Tax into the Fee Totals
12/01/2017 - RMH: Added code to find the Last Payment Transaction Type (credit card, cash or ACH); Added Membership Begin and End Dates, EFTAccountTypeDescription,	IsFeeAmountZero (#133612)
12/14/2017 - RMH: Added WHEN at.EFTAccountTypeDescriptionShort IN('Checking','Savings','A/R') THEN 0 for 'Credit Card Expired' - this should only show up for those using CC to pay fees (#145769)
04/19/2019 - RMH: Added AddOnMonthlyFee and ClientIdentifier
-------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

rptFeeExceptions 1, 03, 2019, 201

************************************************************************************************************/

CREATE PROCEDURE [dbo].[rptFeeExceptions]
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

/*************create temp tables - one for each EFT profile, and one for the Previous Run ******************************************/

CREATE TABLE #ClientEFTStatus
(   ClientIdentifier INT,
	ClientGUID NVARCHAR(50),
	ClientEFTGUID uniqueidentifier,
	ClientFullName nvarchar(200),
	EFTAccountTypeDescription NVARCHAR(50),
	MembershipDescription nvarchar(200),
	MembershipStart DATETIME,
	MembershipEnd DATETIME,
	AddOnMonthlyFee DECIMAL(18,4),
	MonthlyFee DECIMAL(18,4),
	EFTCreditCardExpiration date,
	EFTFreezeStart date,
	EFTFreezeEnd date,
	IsProfileExpired bit NOT NULL,
	IsProfileFrozen bit NOT NULL,
	IsCreditCardExpired bit NOT NULL,
	IsMembershipExpired bit NOT NULL,
	IsFeeAmountZero bit NOT NULL
)

CREATE TABLE #AddOn(
	CenterID INT
,	ClientIdentifier INT
,	ClientFullNameCalc  NVARCHAR(150)
,	ClientGUID  NVARCHAR(50)
,	AddOnMonthlyFee DECIMAL(18,4)
 )

CREATE TABLE #PreviousRun(CenterID INT
,	FeeDate datetime
,	PayCycleTransactionTypeID INT
,	PayCycleTransactionTypeDescription	NVARCHAR(25)
,	ClientGUID NVARCHAR(50)
,	ClientIdentifier NVARCHAR(25)
)


/*********Insert into temp table if EFT Profile is valid to run ***********************************************************************/
INSERT INTO #ClientEFTStatus
SELECT cl.ClientIdentifier,
	c.ClientGUID,
	c.ClientEFTGUID,
	cl.ClientFullNameCalc AS ClientName,
	EFTAccountTypeDescription,
	--memb.MembershipDescriptionShort + ' (' + Convert(nvarchar, cm.EndDate, 101) + ')' AS Membership,
	memb.MembershipDescription,
	cm.BeginDate as MembershipStart,
	cm.EndDate as MembershipEnd,
	NULL AS AddOnMonthlyFee,
	ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0)))) AS 'MonthlyFee',
	c.AccountExpiration AS 'EFTCreditCardExpiration',
	c.Freeze_Start AS 'EFTFreezeStart',
	c.Freeze_End AS 'EFTFreezeEnd',

	-- EFT Profile is active
	CASE
		WHEN (c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0)
				AND (stat.IsEFTActiveFlag IS NULL OR stat.IsEFTActiveFlag = 0)
		THEN 1 ELSE 0 END AS 'IsProfileExpired',

	-- Account is not Frozen
	CASE
		WHEN c.Freeze_Start IS NULL
					OR (c.Freeze_End IS NULL AND  @BatchRunDate < c.Freeze_Start)
					OR (c.Freeze_End IS NOT NULL AND (@BatchRunDate < c.Freeze_Start
							OR @BatchRunDate > c.Freeze_End))
		THEN 0 ELSE 1 END AS 'IsProfileFrozen',

	-- Credit Card Not Expired
	CASE
		WHEN at.EFTAccountTypeDescriptionShort = 'CreditCard' AND @BatchRunDate <= c.AccountExpiration THEN 0
			WHEN at.EFTAccountTypeDescriptionShort IN('Checking','Savings','A/R') THEN 0
			ELSE 1 END AS 'IsCreditCardExpired',

	-- Membership is  Active
	CASE
		WHEN cm.BeginDate IS NULL OR (cm.BeginDate <= @BatchRunDate
						AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= @BatchRunDate)
		THEN 0 ELSE 1 END AS 'IsMembershipExpired',

	-- Fee Amount is Zero
			CASE WHEN ISNULL(cm.MonthlyFee, 0) > 0 THEN 0 ELSE 1 END AS 'IsFeeAmountZero'
FROM datClientEFT c
	INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
	INNER JOIN datClientMembership cm
		ON cm.ClientMembershipGUID = (SELECT Top(1) clMem.ClientMembershipGUID
										FROM datClientMembership clMem
											INNER JOIN cfgMembership m ON m.MembershipID = clMem.MembershipID
											INNER JOIN lkpClientMembershipStatus cms ON clMem.ClientMembershipStatusID = cms.ClientMembershipStatusID
										WHERE clMem.ClientGUID = c.ClientGUID
											AND cms.ClientMembershipStatusDescriptionShort = 'A'
											AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
										ORDER BY clMem.EndDate desc)
	INNER JOIN cfgMembership memb ON memb.MembershipID = cm.MembershipID
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
WHERE pc.FeePayCycleId = @feePayCycleId
	AND cl.CenterID = @centerId

/***********Find Add Ons *************************************************************************/

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
AND CM.CenterID = @CenterID
AND AOT.IsMonthlyAddOnType = 1
GROUP BY CM.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID


UPDATE EFT
SET EFT.AddOnMonthlyFee =  #AddOn.AddOnMonthlyFee
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

/*********** INSERT Previous Run Transaction Type ******************************************************************/

SELECT
	estat.ClientEFTGUID
,	estat.ClientFullName AS ClientName
,	estat.ClientIdentifier
,	estat.EFTAccountTypeDescription
,	estat.MembershipDescription
,	estat.MembershipStart
,	estat.MembershipEnd
,	Convert(nvarchar(20), estat.EFTCreditCardExpiration, 101)AS EFTCreditCardExpiration
,	estat.ClientGUID
,	Convert(nvarchar(20), estat.EFTFreezeStart, 101)AS EFTFreezeStart
,	Convert(nvarchar(20), estat.EFTFreezeEnd, 101)AS EFTFreezeEnd
,	estat.AddOnMonthlyFee
,	estat.MonthlyFee
,	estat.IsCreditCardExpired
,	estat.IsMembershipExpired
,	estat.IsProfileExpired
,	estat.IsProfileFrozen
,	estat.IsFeeAmountZero
,	PR.PayCycleTransactionTypeDescription AS 'PreviousRunTransactionType'
FROM #ClientEFTStatus estat
LEFT JOIN #PreviousRun PR
	ON estat.ClientGUID = PR.ClientGUID
WHERE (estat.IsCreditCardExpired = 1 OR estat.IsMembershipExpired = 1
		OR estat.IsProfileExpired = 1 OR estat.IsProfileFrozen = 1)


END
