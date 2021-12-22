/* CreateDate: 04/02/2015 11:08:05.537 , ModifyDate: 05/20/2019 11:08:50.933 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:                  rptMonthlyFeeResults_CreditCard
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              04/15/2014
 Destination Server:        HairclubCMS
 Destination Database:      SQL01
 Related Application:       Conect
================================================================================================
**NOTES**
This stored procedure is used for the third grid in the report rptMonthlyFeeResults.rdl
================================================================================================
CHANGE HISTORY:
04/03/2019 - RH - Added code to find the AddOnMonthlyFee; added temp tables
================================================================================================
SAMPLE EXECUTION:
EXEC [rptMonthlyFeeResults_CreditCard] 201, '3/1/2019', '3/31/2019'

EXEC [rptMonthlyFeeResults_CreditCard] 292, '2/1/2019', '2/28/2019'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptMonthlyFeeResults_CreditCard]
	@CenterID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME

AS
BEGIN

	DECLARE @CCTenderTypeID int
	SELECT @CCTenderTypeID = TenderTypeID from lkpTendertype Where TenderTypeDescriptionShort = 'CC'

/********** Create temp tables *********************************************************************/

CREATE TABLE #Fee(
		InvoiceNumber NVARCHAR(50)
	,	CreditCardTypeID INT
	,	CreditCardTypeDescription NVARCHAR(50)
	,	CenterID INT
	,	FeeDate DATETIME
	,	PayCycleTransactionTypeID INT
	,	PayCycleTransactionTypeDescription NVARCHAR(25)
	,	CenterFeeBatchGUID NVARCHAR(50)
	,	SalesOrderGUID NVARCHAR(50)
	,	ClientGUID NVARCHAR(50)
	,	ClientFullNameAltCalc NVARCHAR(150)
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

/************* Find fees *******************************************************************************/
INSERT INTO #Fee
SELECT SO.InvoiceNumber
,	origtender.CreditCardTypeID
,	cct.CreditCardTypeDescription
,	q.CenterID
,	q.FeeDate
,	q.PayCycleTransactionTypeID
,	q.PayCycleTransactionTypeDescription
,	q.CenterFeeBatchGUID
,	q.SalesOrderGUID
,	q.ClientGUID
,	q.ClientFullNameAltCalc
,	q.ClientIdentifier
,	q.FeeAmount
,	q.TaxAmount
,	q.ChargeAmount
,	q.Last4Digits
,	q.AVSResult
,	q.IsSuccessfulFlag
,	q.HCStatusCode
,	q.Verbiage
,	NULL AS AddOnMonthlyFee
FROM
		(SELECT fee.CenterID
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
			AND PCT.PayCycleTransactionTypeID = 3  --Credit Card
			AND PCT.IsSuccessfulFlag <> 0
		)q
INNER JOIN dbo.datSalesOrder SO
	ON q.SalesOrderGUID = SO.SalesOrderGUID
OUTER APPLY
		(
			SELECT TOP 1 sot.*
				FROM datSalesOrderDetail sod
					INNER JOIN datSalesOrderTender sot ON sod.SalesOrderGUID = sot.SalesOrderGUID
				WHERE sod.SalesOrderGUID = q.SalesOrderGUID
					AND sot.TenderTypeID = @CCTenderTypeID
					AND sot.CreditCardLast4Digits = q.Last4Digits
		) origtender
LEFT JOIN lkpCreditCardType cct on origtender.CreditCardTypeID = cct.CreditCardTypeID


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

/*********** Final select *************************************************************************/

SELECT InvoiceNumber
,       CreditCardTypeID
,       CreditCardTypeDescription
,       CenterID
,       FeeDate
,       PayCycleTransactionTypeID
,       PayCycleTransactionTypeDescription
,       CenterFeeBatchGUID
,       SalesOrderGUID
,       ClientGUID
,       ClientFullNameAltCalc
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
GO
