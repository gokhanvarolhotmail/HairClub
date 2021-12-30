/* CreateDate: 03/12/2014 11:59:51.077 , ModifyDate: 05/20/2019 11:13:23.830 */
GO
/***********************************************************************
PROCEDURE:				rptMonthlyFeeResults_Summary
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairclubCMS
RELATED REPORT:
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:
PayCycleTransactionTypeID	PayCycleTransactionTypeDescription
2							Cash
3							Credit Card
4							ACH
------------------------------------------------------------------------
CHANGE HISTORY:

03/11/2014 - RH - Created Stored Procedure
04/03/2019 - RH - Added AddOnMonthlyFee; added temp tables; Changed Verbiage to NVARCHAR(30)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptMonthlyFeeResults_Summary 240, '5/1/2019', '5/16/2019'
***********************************************************************/
CREATE PROCEDURE [dbo].[rptMonthlyFeeResults_Summary]
(
	@CenterID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)
AS
BEGIN

	SET FMTONLY OFF;


CREATE TABLE #Fee(
		CenterID INT
	,	FeeDate DATETIME
	,	PayCycleTransactionTypeID INT
	,	PayCycleTransactionTypeDescription NVARCHAR(25)
	,	CenterFeeBatchGUID NVARCHAR(50)
	,	CenterDeclineBatchGUID NVARCHAR(50)
	,	SalesOrderGUID NVARCHAR(50)
	,	ClientGUID NVARCHAR(50)
	,	ClientFullNameAltCalc NVARCHAR(250)
	,	ClientIdentifier INT
	,	FeeAmount DECIMAL(18,4)
	,	TaxAmount DECIMAL(18,4)
	,	ChargeAmount DECIMAL(18,4)
	,	Last4Digits INT
	,	AVSResult NVARCHAR(10)
	,	IsSuccessfulFlag INT
	,	HCStatusCode  NVARCHAR(2)
	,	Verbiage NVARCHAR(30) --***20
	,	AddOnMonthlyFee DECIMAL(18,4)
	)

CREATE TABLE #AddOn(
		CenterID INT
	,	ClientIdentifier INT
	,	ClientFullNameCalc  NVARCHAR(250)
	,	ClientGUID  NVARCHAR(50)
	,	AddOnMonthlyFee DECIMAL(18,4)
	)

 /************* Find fees *******************************************************************************/

INSERT INTO #Fee
SELECT fee.CenterID
,	fee.RunDate AS 'FeeDate'
,	PCT.PayCycleTransactionTypeID
,	PCTT.PayCycleTransactionTypeDescription
,	PCT.CenterFeeBatchGUID
,	PCT.CenterDeclineBatchGUID
,	PCT.SalesOrderGUID
,	PCT.ClientGUID
,	C.ClientFullNameAltCalc
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
	AND PCT.IsSuccessfulFlag <> 0


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


/************ SUM the values *******************************************************************************************/

SELECT FeeDate
	,	SUM(ISNULL(CC_Count,0)) AS 'CC_Count'
	,	SUM(ISNULL(CC_Amount,0)) AS 'CC_Amount'
	,	SUM(ISNULL(CC_AddOnAmount,0)) AS 'CC_AddOnAmount'
	,	SUM(ISNULL(Approved_Count,0)) AS 'Approved_Count'
	,	SUM(ISNULL(Approved_Amount,0)) AS 'Approved_Amount'
	,	SUM(ISNULL(Declined_Count,0)) AS 'Declined_Count'
	,	SUM(ISNULL(Declined_Amount,0)) AS 'Declined_Amount'
	,	SUM(ISNULL(Cash_Count,0)) AS 'Cash_Count'
	,	SUM(ISNULL(Cash_Amount,0)) AS 'Cash_Amount'
	,	SUM(ISNULL(r.Cash_AddOnAmount,0)) AS 'Cash_AddOnAmount'
	,	SUM(ISNULL(AR_Count,0)) AS 'AR_Count'
	,	SUM(ISNULL(AR_Amount,0)) AS 'AR_Amount'
	,	SUM(ISNULL(r.AR_AddOnAmount,0)) AS 'AR_AddOnAmount'
FROM
	(
	SELECT FeeDate
		,	CASE WHEN PayCycleTransactionTypeID = 3 THEN COUNT(ClientIdentifier) END AS 'CC_Count'
		,	CASE WHEN PayCycleTransactionTypeID = 3 THEN SUM(ChargeAmount) END AS 'CC_Amount'
		,	CASE WHEN PayCycleTransactionTypeID = 3 THEN SUM(AddOnMonthlyFee) END AS 'CC_AddOnAmount'
		,	CASE WHEN PayCycleTransactionTypeID = 3 AND HCStatusCode = 'A' THEN COUNT(ClientIdentifier) END AS 'Approved_Count'
		,	CASE WHEN PayCycleTransactionTypeID = 3 AND HCStatusCode = 'A' THEN SUM(ChargeAmount) END AS 'Approved_Amount'
		,	CASE WHEN PayCycleTransactionTypeID = 3 AND HCStatusCode = 'D' THEN COUNT(ClientIdentifier) END AS 'Declined_Count'
		,	CASE WHEN PayCycleTransactionTypeID = 3 AND HCStatusCode = 'D' THEN SUM(ChargeAmount) END AS 'Declined_Amount'
		,	CASE WHEN PayCycleTransactionTypeID = 2 THEN COUNT(ClientIdentifier) END AS 'Cash_Count'
		,	CASE WHEN PayCycleTransactionTypeID = 2 THEN SUM(ChargeAmount) END AS 'Cash_Amount'
		,	CASE WHEN PayCycleTransactionTypeID = 2 THEN SUM(AddOnMonthlyFee) END AS 'Cash_AddOnAmount'
		,	CASE WHEN PayCycleTransactionTypeID = 4 THEN COUNT(ClientIdentifier) END AS 'AR_Count'
		,	CASE WHEN PayCycleTransactionTypeID = 4 THEN SUM(ChargeAmount) END AS 'AR_Amount'
		,	CASE WHEN PayCycleTransactionTypeID = 4 THEN SUM(AddOnMonthlyFee) END AS 'AR_AddOnAmount'
	FROM #Fee
	GROUP BY FeeDate,
             PayCycleTransactionTypeID,
             HCStatusCode
	) r
GROUP BY r.FeeDate



END
GO
