/*===============================================================================================
-- Procedure Name:				rptEFTProfileChanges
-- Procedure Description:
--
-- Created By:					Rachelen Hut
-- Implemented By:				Rachelen Hut
-- Last Modified By:			Rachelen Hut
--
-- Date Created:				12/20/13
-- Date Implemented:
-- Date Last Modified:			12/20/13
--
-- Destination Server:			HairclubCMS
-- Destination Database:
-- Related Application:			Hairclub CMS
================================================================================================
**NOTES**
================================================================================================
CHANGE HISTORY:

04/30/2015 - RH - Added code for @CenterID to allow Corporate or Franchise All
05/19/2015 - DL - Added code to include Franchise centers when a specific center is selected (#114755)
05/29/2017 - RH - Added @ClientProcessID as a multi-select, removed @EmployeeGUID and @IsSurgeryCenter; Added Membership Revenue (#137114)
06/01/2017 - RH - Added Is CC on File (#139551); Added WHEN CT.ClientProcessID = 10 THEN CONVERT(NVARCHAR,CT.BankAccountNumber) and PreviousBankAccountNumber
06/13/2017 - RH - Added WHEN CT.ClientProcessID = 9, CT.PreviousFeeFreezeReasonDescription and CT.FeeFreezeReasonDescription (#140082)

================================================================================================
Sample Execution:
EXEC rptEFTProfileChanges '6/1/2017','6/30/2017',292,'All', '260B1960-B340-4A59-B510-12762151F5F9'

EXEC rptEFTProfileChanges '6/1/2017','6/31/2017',292,'9','All'

EXEC rptEFTProfileChanges '6/1/2017','6/30/2017',201,'1,2,3,4,5,6','All'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptEFTProfileChanges]
	@StartDate DATETIME
,	@EndDate DATETIME
,	@CenterID INT
,	@ClientProcessID NVARCHAR(50)
,	@ClientGUID NVARCHAR(50) = NULL
AS
BEGIN


/************** Insert into #Process **********************************************/

CREATE TABLE #Process(ClientProcessID INT)

IF @ClientProcessID = 'All'
BEGIN
INSERT INTO #Process
SELECT DISTINCT ClientProcessID
FROM dbo.lkpClientProcess
END
ELSE
BEGIN
INSERT INTO #Process
SELECT item
FROM dbo.fnSplit(@ClientProcessID,',')
END

/************ Create the #Changes temp table *****************************************/

CREATE TABLE #Changes(CenterID INT
,	CenterDescriptionFullCalc NVARCHAR(104)
,	ClientIdentifier INT
,	ClientGUID NVARCHAR(50)
,	ClientFullNameCalc NVARCHAR(150)
,	ClientMembershipGUID NVARCHAR(50)
,	TransactionDate DATETIME
,	ClientProcessID INT
,	ClientProcessDescription  NVARCHAR(150)
,	BeginningValue NVARCHAR(150)
,	EndingValue NVARCHAR(150)
,	EnteredBy NVARCHAR(50)
)




/***************** Select statements ********************************************************/
IF @ClientGUID = 'All'
BEGIN
INSERT INTO #Changes
SELECT CTR.CenterID
,	CTR.CenterDescriptionFullCalc
,	CLT.ClientIdentifier
,	CLT.ClientGUID
,	CLT.ClientFullNameCalc
,	CM.ClientMembershipGUID
,	CT.TransactionDate
,	#Process.ClientProcessID
,	CP.ClientProcessDescription
,	CASE WHEN CT.ClientProcessID = 1 THEN CONVERT(NVARCHAR,CT.PreviousEFTFreezeStartDate,101)
		WHEN CT.ClientProcessID = 2 THEN CONVERT(NVARCHAR,CT.PreviousEFTFreezeEndDate, 101)
		WHEN CT.ClientProcessID = 3 THEN CONVERT(NVARCHAR,CT.PreviousEFTHoldEndDate,101)
		WHEN CT.ClientProcessID = 4 THEN CONVERT(NVARCHAR,CT.PreviousEFTHoldStartDate,101)
		WHEN CT.ClientProcessID = 5 THEN CONVERT(NVARCHAR,CT.PreviousCCNumber)
		WHEN CT.ClientProcessID = 6 THEN CONVERT(NVARCHAR,CT.PreviousCCExpirationDate,101)
		WHEN CT.ClientProcessID = 7 THEN CONVERT(NVARCHAR,fpc1.FeePayCycleDescription)
		WHEN CT.ClientProcessID = 8 THEN CONVERT(NVARCHAR,CT.PreviousMonthlyFeeAmount)
		WHEN CT.ClientProcessID = 9 THEN CT.PreviousFeeFreezeReasonDescription
		WHEN CT.ClientProcessID = 10 THEN CONVERT(NVARCHAR,CT.PreviousBankAccountNumber)
	END BeginningValue
,	CASE WHEN CT.ClientProcessID = 1 THEN CONVERT(NVARCHAR,CT.EFTFreezeStartDate,101)
		WHEN CT.ClientProcessID = 2 THEN CONVERT(NVARCHAR,CT.EFTFreezeEndDate,101)
		WHEN CT.ClientProcessID = 3 THEN CONVERT(NVARCHAR,CT.EFTHoldEndDate,101)
		WHEN CT.ClientProcessID = 4 THEN CONVERT(NVARCHAR,CT.EFTHoldStartDate,101)
		WHEN CT.ClientProcessID = 5 THEN CONVERT(NVARCHAR,CT.CCNumber)
		WHEN CT.ClientProcessID = 6 THEN CONVERT(NVARCHAR,CT.CCExpirationDate,101)
		WHEN CT.ClientProcessID = 7 THEN CONVERT(NVARCHAR,FPC2.FeePayCycleDescription)
		WHEN CT.ClientProcessID = 8 THEN CONVERT(NVARCHAR,CT.MonthlyFeeAmount)
		WHEN CT.ClientProcessID = 9 THEN CT.FeeFreezeReasonDescription
		WHEN CT.ClientProcessID = 10 THEN CONVERT(NVARCHAR,CT.BankAccountNumber)
	END EndingValue
,	CT.CreateUser as EnteredBy
FROM datClientTransaction CT
	INNER JOIN datClient CLT
		ON CT.ClientGUID = CLT.ClientGUID
	INNER JOIN cfgCenter CTR
		ON CLT.CenterID = CTR.CenterID
	INNER JOIN dbo.datClientMembership CM
		ON (CLT.CurrentBioMatrixClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentSurgeryClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentXtrandsClientMembershipGUID = CM.ClientMembershipGUID)
	INNER JOIN #Process
		ON CT.ClientProcessID = #Process.ClientProcessID
	INNER JOIN lkpClientProcess  CP
		ON #Process.ClientProcessID = CP.ClientProcessID
	LEFT OUTER JOIN lkpFeePayCycle FPC1
		ON CT.PreviousFeePayCycleID = FPC1.FeePayCycleID
	LEFT OUTER JOIN lkpFeePayCycle FPC2
		ON CT.FeePayCycleID = FPC2.FeePayCycleID
WHERE CT.TransactionDate BETWEEN @StartDate AND @EndDate
AND CLT.CenterID = @CenterID
AND CT.ClientProcessID IN (SELECT ClientProcessID FROM #Process)
END
ELSE
BEGIN
INSERT INTO #Changes
SELECT CTR.CenterID
,	CTR.CenterDescriptionFullCalc
,	CLT.ClientIdentifier
,	CLT.ClientGUID
,	CLT.ClientFullNameCalc
,	CM.ClientMembershipGUID
,	CT.TransactionDate
,	#Process.ClientProcessID
,	CP.ClientProcessDescription
,	CASE WHEN CT.ClientProcessID = 1 THEN CONVERT(NVARCHAR,CT.PreviousEFTFreezeStartDate,101)
		WHEN CT.ClientProcessID = 2 THEN CONVERT(NVARCHAR,CT.PreviousEFTFreezeEndDate, 101)
		WHEN CT.ClientProcessID = 3 THEN CONVERT(NVARCHAR,CT.PreviousEFTHoldEndDate,101)
		WHEN CT.ClientProcessID = 4 THEN CONVERT(NVARCHAR,CT.PreviousEFTHoldStartDate,101)
		WHEN CT.ClientProcessID = 5 THEN CONVERT(NVARCHAR,CT.PreviousCCNumber)
		WHEN CT.ClientProcessID = 6 THEN CONVERT(NVARCHAR,CT.PreviousCCExpirationDate,101)
		WHEN CT.ClientProcessID = 7 THEN CONVERT(NVARCHAR,fpc1.FeePayCycleDescription)
		WHEN CT.ClientProcessID = 8 THEN CONVERT(NVARCHAR,CT.PreviousMonthlyFeeAmount)
		WHEN CT.ClientProcessID = 9 THEN CT.PreviousFeeFreezeReasonDescription
		WHEN CT.ClientProcessID = 10 THEN CONVERT(NVARCHAR,CT.PreviousBankAccountNumber)
	END BeginningValue
,	CASE WHEN CT.ClientProcessID = 1 THEN CONVERT(NVARCHAR,CT.EFTFreezeStartDate,101)
		WHEN CT.ClientProcessID = 2 THEN CONVERT(NVARCHAR,CT.EFTFreezeEndDate,101)
		WHEN CT.ClientProcessID = 3 THEN CONVERT(NVARCHAR,CT.EFTHoldEndDate,101)
		WHEN CT.ClientProcessID = 4 THEN CONVERT(NVARCHAR,CT.EFTHoldStartDate,101)
		WHEN CT.ClientProcessID = 5 THEN CONVERT(NVARCHAR,CT.CCNumber)
		WHEN CT.ClientProcessID = 6 THEN CONVERT(NVARCHAR,CT.CCExpirationDate,101)
		WHEN CT.ClientProcessID = 7 THEN CONVERT(NVARCHAR,FPC2.FeePayCycleDescription)
		WHEN CT.ClientProcessID = 8 THEN CONVERT(NVARCHAR,CT.MonthlyFeeAmount)
		WHEN CT.ClientProcessID = 9 THEN CT.FeeFreezeReasonDescription
		WHEN CT.ClientProcessID = 10 THEN CONVERT(NVARCHAR,CT.BankAccountNumber)
	END EndingValue
,	CT.CreateUser as EnteredBy
FROM datClientTransaction CT
	INNER JOIN datClient CLT
		ON CT.ClientGUID = CLT.ClientGUID
	INNER JOIN cfgCenter CTR
		ON CLT.CenterID = CTR.CenterID
	INNER JOIN dbo.datClientMembership CM
		ON (CLT.CurrentBioMatrixClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentSurgeryClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentXtrandsClientMembershipGUID = CM.ClientMembershipGUID)
	INNER JOIN #Process
		ON CT.ClientProcessID = #Process.ClientProcessID
	INNER JOIN lkpClientProcess  CP
		ON #Process.ClientProcessID = CP.ClientProcessID
	LEFT OUTER JOIN lkpFeePayCycle FPC1
		ON CT.PreviousFeePayCycleID = FPC1.FeePayCycleID
	LEFT OUTER JOIN lkpFeePayCycle FPC2
		ON CT.FeePayCycleID = FPC2.FeePayCycleID
WHERE CT.TransactionDate BETWEEN @StartDate AND @EndDate
AND CLT.CenterID = @CenterID
AND CT.ClientProcessID IN (SELECT ClientProcessID FROM #Process)
AND CLT.ClientGUID = @ClientGUID
END

/*********** Find Distinct Client Identifiers ************************************************/

SELECT ClientIdentifier
,	ClientGUID
,	NULL AS 'CreditCardOnFile'
INTO #Clients
FROM #Changes
GROUP BY ClientIdentifier
,	ClientGUID

/**************Do these ClientGUID's have a CC on file? **************************************/

SELECT #Clients.ClientGUID
,	CC.ClientCreditCardID
,	CC.AccountExpiration
,	1 AS 'CreditCardOnFile'
INTO #CC
FROM #Clients
INNER JOIN datClientCreditCard CC
	ON #Clients.ClientGUID = CC.ClientGUID
WHERE CC.ClientGUID IN(SELECT ClientGUID FROM #Changes)
AND CC.AccountExpiration > GETDATE()


/************ Find monthly fees ***************************************************************/

DECLARE @MembershipReveueID int
DECLARE @MembershipPaymentID int

SELECT @MembershipReveueID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment where SalesCodeDepartmentDescriptionShort = 'MRRevenue'
SELECT @MembershipPaymentID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment where SalesCodeDepartmentDescriptionShort = 'MSARPmt'

SELECT #Changes.ClientIdentifier
,	CAST(SO.ClientMembershipGUID AS NVARCHAR(50)) AS 'ClientMembershipGUID'
,	M.MembershipDescription
,	CM.BeginDate
,	CM.EndDate
,	M.MembershipSortOrder
,	SO.InvoiceNumber
,	SO.OrderDate
,	SC.SalesCodeDescription
,	TT.TenderTypeDescription
,	SOT.[Amount] as TenderAmount
INTO #TenderAmt
FROM #Changes
LEFT JOIN datSalesOrder SO
	ON #Changes.ClientMembershipGUID = SO.ClientMembershipGUID
		AND #Changes.ClientGUID = SO.ClientGUID
	LEFT JOIN datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	LEFT JOIN cfgSalesCode SC
		ON SOD.SalesCodeId = SC.SalesCodeID
	INNER JOIN datSalesOrderTender sot
		ON SO.SalesOrderGUID = SOT.SalesOrderGUID
	INNER JOIN lkpTenderType TT
		ON SOT.TenderTypeID = TT.TenderTypeID
	INNER JOIN datClientMembership CM
		ON SO.ClientMembershipGUID = CM.ClientMembershipGUID
	INNER JOIN cfgMembership M
		ON CM.MembershipID = M.MembershipID
WHERE ClientIdentifier IN (SELECT ClientIdentifier FROM #Clients)
AND SO.OrderDate BETWEEN @StartDate AND @EndDate
	AND (SC.SalesCodeDepartmentID  = @MembershipReveueID OR SC.SalesCodeDepartmentID = @MembershipPaymentID)
	AND SO.IsVoidedFlag = 0
	AND TenderTypeDescription <> 'Accounts Receivable'
	AND TenderTypeDescription <> 'Inter Company'
GROUP BY CAST(SO.ClientMembershipGUID AS NVARCHAR(50))
       , ClientIdentifier
       , M.MembershipDescription
       , CM.BeginDate
       , CM.EndDate
       , M.MembershipSortOrder
       , SO.InvoiceNumber
       , SO.OrderDate
       , SC.SalesCodeDescription
       , TT.TenderTypeDescription
       , SOT.Amount

/*********** Final select with SUM of monthly fees ********************************************/

SELECT CenterID
,	CenterDescriptionFullCalc
,	#Changes.ClientIdentifier
,	ClientFullNameCalc
,	TransactionDate
,	ClientProcessID
,	ClientProcessDescription
,	BeginningValue
,	EndingValue
,	EnteredBy
,	SUM(ISNULL(TenderAmount,0)) AS 'TenderAmount'
,	ISNULL(#CC.CreditCardOnFile,0) AS 'CreditCardOnFile'
FROM #Changes
LEFT JOIN #TenderAmt
	ON #Changes.ClientIdentifier = #TenderAmt.ClientIdentifier
		AND #Changes.ClientMembershipGUID = #TenderAmt.ClientMembershipGUID
LEFT JOIN #CC
	ON #CC.ClientGUID = #Changes.ClientGUID
GROUP BY CenterID
,	CenterDescriptionFullCalc
,	ClientFullNameCalc
,	#Changes.ClientIdentifier
,	TransactionDate
,	ClientProcessID
,	ClientProcessDescription
,	BeginningValue
,	EndingValue
,	EnteredBy
,	ISNULL(#CC.CreditCardOnFile,0)

END
