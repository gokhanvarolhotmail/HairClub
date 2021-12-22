/***********************************************************************
PROCEDURE:				rptMonthlyFeeResults
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairclubCMS
RELATED REPORT:
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:
------------------------------------------------------------------------
CHANGE HISTORY:

03/11/2014 - Rachelen Hut - Created Stored Procedure
03/18/2014 - Rachelen Hut - Changed ClientName to LastName and FirstName
04/03/2019 - Rachelen Hut - Added AddOnMonthlyFee; added temp tables
07/23/2019 - Rachelen Hut - Removed "AND PCT.IsSuccessfulFlag <> 0" to match the cONEct version - what is displayed on the screen
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptMonthlyFeeResults 240, '7/1/2019', '7/31/2019'
***********************************************************************/
CREATE PROCEDURE [dbo].[rptMonthlyFeeResults]
(
	@CenterID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)
AS
BEGIN

	SET FMTONLY OFF;

/********* Create temp tables *******************************************/

CREATE TABLE #Fee(
		CenterID INT
	,	FeeDate DATETIME
	,	PayCycleTransactionTypeID INT
	,	PayCycleTransactionTypeDescription NVARCHAR(25)
	,	CenterFeeBatchGUID NVARCHAR(50)
	,	CenterDeclineBatchGUID NVARCHAR(50)
	,	SalesOrderGUID NVARCHAR(50)
	,	ClientGUID NVARCHAR(50)
	,	LastName NVARCHAR(50)
	,	FirstName NVARCHAR(50)
	,	ClientIdentifier INT
	,	FeeAmount DECIMAL(18,4)
	,	TaxAmount DECIMAL(18,4)
	,	ChargeAmount DECIMAL(18,4)
	,	Last4Digits INT
	,	AVSResult NVARCHAR(10)
	,	IsSuccessfulFlag INT
	,	HCStatusCode  NVARCHAR(2)
	,	Verbiage NVARCHAR(20)
	,	AddOnMonthlyFee DECIMAL(18,4)
	)

 CREATE TABLE #AddOn(
	CenterID INT
,	ClientIdentifier INT
,	ClientFullNameCalc  NVARCHAR(150)
,	ClientGUID  NVARCHAR(50)
,	AddOnMonthlyFee DECIMAL(18,4)
 )

/********* Find fees  **************************************************/

INSERT INTO #Fee
SELECT fee.CenterID
	,	fee.RunDate AS 'FeeDate'
	,	PCT.PayCycleTransactionTypeID
	,	PCTT.PayCycleTransactionTypeDescription
	,	PCT.CenterFeeBatchGUID
	,	PCT.CenterDeclineBatchGUID
	,	PCT.SalesOrderGUID
	,	PCT.ClientGUID
	,	C.LastName
	,	C.FirstName
	,	C.ClientIdentifier
	,	PCT.FeeAmount
	,	PCT.TaxAmount
	,	PCT.ChargeAmount
	,	PCT.Last4Digits
	,	PCT.AVSResult
	,	PCT.IsSuccessfulFlag
	,	PCT.HCStatusCode
	,	PCT.Verbiage
	,	NULL AS AddOnMonthlyFee
FROM dbo.datPayCycleTransaction PCT
INNER JOIN lkpPayCycleTransactionType PCTT
	ON PCT.PayCycleTransactionTypeID = PCTT.PayCycleTransactionTypeID
INNER JOIN datClient C
	ON PCT.ClientGUID = C.ClientGUID
INNER JOIN datCenterFeeBatch fee
	ON fee.CenterFeeBatchGUID = PCT.CenterFeeBatchGUID
WHERE fee.RunDate BETWEEN @StartDate AND @EndDate
	AND PCT.CenterDeclineBatchGUID IS NULL
	AND fee.CenterID = @CenterID
	AND PCT.PayCycleTransactionTypeID <> 1 --Frozen
	--AND PCT.IsSuccessfulFlag <> 0

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

--Update AddOnMonthlyFee in the #Fee temp table

UPDATE #Fee
SET #Fee.AddOnMonthlyFee =  #AddOn.AddOnMonthlyFee
FROM #Fee
INNER JOIN #AddOn
ON #AddOn.ClientIdentifier = #Fee.ClientIdentifier
WHERE #Fee.AddOnMonthlyFee IS NULL

/***********Final select *************************************************************************/

SELECT CenterID
,       FeeDate
,       PayCycleTransactionTypeID
,       PayCycleTransactionTypeDescription
,       CenterFeeBatchGUID
,       CenterDeclineBatchGUID
,       SalesOrderGUID
,       ClientGUID
,       LastName
,       FirstName
,       ClientIdentifier
,       FeeAmount
,       TaxAmount
,       ChargeAmount
,       Last4Digits
,       AVSResult
,       IsSuccessfulFlag
,       HCStatusCode
,       Verbiage
,       AddOnMonthlyFee
FROM #Fee

END
