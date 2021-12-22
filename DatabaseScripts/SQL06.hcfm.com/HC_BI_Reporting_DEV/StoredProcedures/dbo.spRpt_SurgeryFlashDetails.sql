/*
==============================================================================

PROCEDURE:				sprpt_SurgeryFlashDetails

VERSION:				v2.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:

LAST AUTHOR REVISION:	Kevin Murdoch

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED:		6/2/2011

LAST REVISION DATE: 	6/2/2011

==============================================================================
DESCRIPTION:	Shows all new business surgery sales for a date range
==============================================================================

==============================================================================
NOTES:
	06/02/2011 -- KM --	Initial Rewrite to new Data Warehouse
	08/25/2011 -- KM -- (66154) Added logic to Net sales to handle cancels
	12/22/2011	- MB - Filtered out BeBacks from Consultations (WO# 70091)
	08/24/2012	- MB - Changed report to use the transaction center instead of
						the client center
	08/28/2012 - MB - Changed report to use client center instead of transaction
						center (WO# 78889)
	09/11/2012  - HD - Corrected the surgery offered count to exclude bebacks
==============================================================================
GRANT EXECUTE ON sprpt_SurgeryFlashDetails TO IIS
==============================================================================
SAMPLE EXECUTION:
EXEC [sprpt_SurgeryFlashDetails] '12/6/2011', '12/21/2011', 301, 14
EXEC [sprpt_SurgeryFlashDetails] '9/1/2009', '9/10/2009', 301, 21
==============================================================================
*/

CREATE PROCEDURE [dbo].[sprpt_SurgeryFlashDetails]
	@StartDate	SMALLDATETIME
,	@EndDate	SMALLDATETIME
,	@Center	SMALLINT
,	@ReportType	TINYINT
AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF
	DECLARE
		@StartDateKey INT
	,	@EndDateKey INT
	,	@NSCenterNum SMALLINT

	SET @EndDate = @EndDate + ' 23:59'
	SET @NSCenterNum =
		CASE
				when  @Center between 300 and 399 then  @Center - 100
				when  @Center between 500 and 699 then  @Center + 200
				else  @Center end

	SET @StartDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(@StartDate))
      + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(@StartDate)))=1 THEN '0' + CONVERT(VARCHAR, MONTH(@StartDate)) else CONVERT(VARCHAR, MONTH(@StartDate)) END
      + CASE WHEN LEN(CONVERT(VARCHAR, DAY(@StartDate)))=1 THEN '0' + CONVERT(VARCHAR, DAY(@StartDate)) ELSE CONVERT(VARCHAR, DAY(@StartDate)) END)

	SET @EndDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(@EndDate))
      + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(@EndDate)))=1 THEN '0' + CONVERT(VARCHAR, MONTH(@EndDate)) ELSE CONVERT(VARCHAR, MONTH(@EndDate)) END
      + CASE WHEN LEN(CONVERT(VARCHAR, DAY(@EndDate)))=1 THEN '0' + CONVERT(VARCHAR, DAY(@EndDate)) ELSE CONVERT(VARCHAR, DAY(@EndDate)) END)


	/*--------------------------------------------------------------------------------------------------------------------
	-- Return the detail records of the column selected by the user.
	----------------------------------------------------------------------------------------------------------------------
        Report Type (@ReportType)

        1 = First Surgery Sales
        2 = First Surgery Collected
        3 = First Surgery Grafts
        13 = First Surgery $ Est
        15 = First Surgery POSTEXTPMT $

        4 = Additional Surgery Sales
        5 = Additional Surgery Collected
        6 = Additional Surgery Grafts
        14 = Additional Surgery $ Est
        16 = Additional Surgery POSTEXTPMT $

        7 = Total Surgery Performed
        8 = Total Surgery Net$
        9 = Total Surgery Grafts
        17 = Total Surgery POSTEXT #
        18 = Total Surgery POSTEXT $

        10 = Outstanding Procedures Total
        11 = Outstanding Procedures Total$
        12 = Outstanding Procedures $ Est

        20 = Deposits #
		21 = Surgery Consultations #
    */
    --------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------*/
	CREATE TABLE #TempAccumByDate (
		CenterID INT
	,	ClientMembershipGUID UNIQUEIDENTIFIER
	,	ClientGUID UNIQUEIDENTIFIER
	,	Membership INT
	,	EstimatedGrafts INT
	,	PlacedGrafts INT
	,	PricePerGraft DECIMAL(21,6)
	,	EstimatedContractPrice DECIMAL(21,6)
	,	PlacedContractPrice DECIMAL(21,6)
	,	FreeGrafts INT
	)

	IF (@ReportType = 1) -- First Surgery Net Sales
	BEGIN
		SELECT
			ClientHomeCenterID as 'center'
		,	ClientIdentifier as 'client_no'
		,	ClientLastName as 'last_name'
		,	ClientFirstName as 'first_name'
		,	InvoiceNumber as 'ticket_no'
		,	OrderDate as 'date'
		,	SalesCodeDescription as 'Description'
		,	SalesCodeDescriptionShort as 'Code'
		,	FirstSurgeryContract$ as 'Contract_amount'
		,	CASE WHEN SalesCodeDepartmentID IN (1010) THEN 1 ELSE -1 END AS 'qty'
		,	MembershipDescriptionShort AS 'member'
		,	FirstSurgeryGraft# AS  'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM dbo.vw_SurgerySalesOrderDetail SURG
		WHERE OrderDate BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1010, 1099)
		AND MembershipID = 43
		AND ClientHomeCenterID =  @Center
		AND (AccumulatorKey = 48 OR SalescodeDescriptionShort = 'CANCEL')
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 2) -- First Surgery Net $
	BEGIN
		SELECT
			ClientHomeCenterID as 'center'
		,	ClientIdentifier as 'client_no'
		,	ClientLastName as 'last_name'
		,	ClientFirstName as 'first_name'
		,	InvoiceNumber as 'ticket_no'
		,	OrderDate as 'date'
		,	SalesCodeDescription as 'Description'
		,	SalescodeDescriptionShort as 'Code'
		,	FirstSurgeryCollected$ 'Contract_amount'
		,	FirstSurgerySales#'qty'
		,	MembershipDescriptionShort 'member'
		,	FirstSurgeryGraft# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM dbo.vw_SurgerySalesOrderDetail SURG
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (2020)
		AND MembershipID = 43
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 3) -- First Surgery Grafts
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	FirstSurgeryContract$ 'Contract_amount'
		,	FirstSurgerySales# 'qty'
		,	MembershipDescriptionShort 'member'
		,	FirstSurgeryGraft# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM dbo.vw_SurgerySalesOrderDetail
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag= 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1010,1030,1040)
		AND MembershipID = 43
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 13) -- First Surgery Contract Amount
	BEGIN

		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	FirstSurgeryContract$ 'Contract_amount'
		,	FirstSurgeryGraft# 'qty'
		,	MembershipDescriptionShort 'member'
		,	FirstSurgeryGraft# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM dbo.vw_SurgerySalesOrderDetail
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
			AND SalesOrderVoidedFlag = 0
			AND SalesOrderClosedFlag = 1
			AND SalesCodeDepartmentID IN (1010,1030,1040)
			AND MembershipID = 43
			AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 4) -- Addtl Surgery Net Sales
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	AddtlSurgeryCollected$ 'Contract_amount'
		,	CASE WHEN SalesCodeDepartmentID IN (1075, 1090) THEN 1 ELSE -1 END AS 'qty'
		,	MembershipDescriptionShort 'member'
		,	AddtlSurgeryGrafts# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1075, 1090, 1099)
		AND MembershipID = 44
		AND (AccumulatorKey = 48 OR SalescodeDescriptionShort = 'CANCEL')
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 5) -- Addtl Surgery Net $
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	AddtlSurgeryCollected$ 'Contract_amount'
		,	AddtlSurgerySales# 'qty'
		,	MembershipDescriptionShort 'member'
		,	AddtlSurgeryGrafts# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (2020)
		AND MembershipID = 44
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 6) -- Addtl Surgery Grafts
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	AddtlSurgeryContract$ 'Contract_amount'
		,	AddtlSurgerySales# 'qty'
		,	MembershipDescriptionShort 'member'
		,	AddtlSurgeryGrafts# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1075, 1090, 1030,1040)
		AND MembershipID = 44
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 14) -- Addtl Surgery Contract Amount
	BEGIN

		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	AddtlSurgeryContract$'Contract_amount'
		,	AddtlSurgerySales# 'qty'
		,	MembershipDescriptionShort 'member'
		,	AddtlSurgeryGrafts# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1075, 1090, 1030,1040)
		AND MembershipID = 44
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 7) -- Total surgery performed
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	SurgeryPerformed$ 'Contract_amount'
		,	SurgeryPerformed# 'qty'
		,	MembershipDescriptionShort 'member'
		,	SurgeryPerformedGrafts# 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (5060)
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 8) -- Total surgery net $
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	SurgeryPerformed$ 'Contract_amount'
		,	SurgeryPerformed# 'qty'
		,	MembershipDescriptionShort 'member'
		,	SurgeryPerformedGrafts#'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND ClientHomeCenterID =  @Center
		AND SalesCodeDepartmentID IN (5060)
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 9) -- Total surgery grafts
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	SurgeryPerformed$ 'Contract_amount'
		,	SurgeryPerformed# 'qty'
		,	MembershipDescriptionShort 'member'
		,	SurgeryPerformedGrafts#'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND ClientHomeCenterID =  @Center
		AND SalesCodeDepartmentID IN (5060)
		ORDER BY [OrderDate]
	END

	IF (@ReportType IN (17, 18)) -- Total surgery POSTEXT #
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	PostEXT$ 'Contract_amount'
		,	PostEXT# 'qty'
		,	MembershipDescriptionShort 'member'
		,	0 'est_grafts'
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (2025)
		AND ClientHomeCenterID =  @Center
		ORDER BY [OrderDate]
	END

	IF (@ReportType IN (20)) -- Deposit #
	BEGIN

		SELECT 	so.ClientHomeCenterID 'center'
		,	ClientIdentifier 'Client_no'
		,	ClientLastName 'last_name'
		,	ClientFirstName 'first_name'
		,	InvoiceNumber 'ticket_no'
		,	[OrderDate] 'date'
		,	SalesCodeDescription 'Description'
		,	SalesCodeDescriptionShort 'Code'
		,	Deposit$ 'Contract_amount'
		,	Deposit# As 'qty'
		,	MembershipDescriptionShort 'member'
		,	0 'est_grafts'
		,	[ClientGUID]
		,	NULL AS 'Client'
		,	NULL AS 'center_name'
		,	NULL AS 'CreateDate'
		,	NULL AS 'ResultCode'
		,	NULL AS 'NoSaleReason'
		,	NULL AS 'Performer'
		FROM [vw_SurgerySalesOrderDetail] so
		WHERE so.[OrderDate] BETWEEN @StartDate AND @EndDate
			AND so.SalesOrderVoidedFlag = 0
			AND so.SalesOrderClosedFlag = 1
			AND so.SalesCodeDepartmentID IN (7015)
			AND so.ClientHomeCenterID =  @Center
		ORDER BY[OrderDate]

	END

	IF (@ReportType IN (21)) -- Surgery Consultations #
	BEGIN
		SELECT
			CASE
				WHEN ACT.CenterSSID BETWEEN 200 AND 299 THEN ACT.CenterSSID + 100
				WHEN ACT.CenterSSID BETWEEN 700 AND 899 THEN ACT.CenterSSID - 200
				ELSE ACT.CenterSSID
			END AS 'Center'
		,	CLT.ContactFullName AS 'Client'
		,	CONVERT(VARCHAR, CASE
				WHEN ACT.CenterSSID BETWEEN 200 AND 299 THEN ACT.CenterSSID + 100
				WHEN ACT.CenterSSID BETWEEN 700 AND 899 THEN ACT.CenterSSID - 200
				ELSE ACT.CenterSSID
			END) + ' - ' + CTR.CenterDescription AS 'center_name'
		,	ACT.ActivityCompletionDate AS 'Date'
		,	NULL AS 'CreateDate'
		,	ACT.ActionCodeDescription AS 'Description'
		,	ACT.ActionCodeSSID AS 'Code'
		,	ACTRES.ResultCodeSSID AS 'ResultCode'
		,	ACTDEM.NoSaleReason
		,	ACTDEM.Performer
		,	NULL AS 'client_no'
		,	NULL AS 'last_name'
		,	NULL AS 'first_name'
		,	NULL AS 'ticket_no'
		,	NULL AS 'contract_amount'
		,	NULL AS 'qty'
		,	NULL AS 'member'
		,	NULL AS 'est_grafts'
		FROM dbo.synHC_MKTG_DDS_vwDimActivityResult ACTRES
			INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
				ON FAR.ActivityResultKey = ACTRES.ActivityResultKey
				AND FAR.BeBack = 0
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActivity ACT
				ON ACTRES.ActivitySSID = ACT.ActivitySSID
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActionCode ACTCODE
				ON  ACT.ActionCodeSSID = ACTCODE.ActionCodeSSID
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActivityDemographic ACTDEM
				ON ACT.ActivitySSID = ACTDEM.ActivitySSID
			INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR
				ON ACT.CenterSSID = CTR.CenterSSID
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimContact CLT
				ON ACTRES.ContactSSID = CLT.ContactSSID
		WHERE ACT.ActivityDueDate between @StartDate AND @EndDate
			AND ACT.IsBeBack=0
			AND ACTRES.SurgeryOffered = 'Y'
			AND ACT.CenterSSID = @NSCenterNum
	END
END
