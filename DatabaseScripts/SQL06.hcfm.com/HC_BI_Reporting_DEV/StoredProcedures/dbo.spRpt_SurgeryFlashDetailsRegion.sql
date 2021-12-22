/*
==============================================================================

PROCEDURE:				sprpt_SurgeryFlashDetailsRegion

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
	08/15/2011 -- KM -- (65707) Added filter for surgery offered; added centername
						;Added CenterDescriptionFullCalc
	08/18/2011 -- MB -- Added contact name to consultation result set.  Changed
						CenterDescriptionFullCalc to
						ClientHomeCenterDescriptionFullCalc to get the center
						name that the actual transaction belongs to (WO# 65707)
	08/25/2011 -- KM -- (66154) Added logic to Net sales to handle cancels
	12/22/2011	- MB - Filtered out BeBacks from Consultations (WO# 70091)
==============================================================================
GRANT EXECUTE ON sprpt_SurgeryFlashDetailsRegion TO IIS
==============================================================================
SAMPLE EXECUTION:
EXEC [sprpt_SurgeryFlashDetailsRegion] '8/1/2011', '8/18/2011', 9, 7
EXEC [sprpt_SurgeryFlashDetailsRegion] '9/1/2009', '9/10/2009', 9, 21
==============================================================================
*/

CREATE PROCEDURE [dbo].[spRpt_SurgeryFlashDetailsRegion]
	@StartDate	SMALLDATETIME
,	@EndDate	SMALLDATETIME
,	@RegionID	SMALLINT
,	@ReportType	TINYINT
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF
	DECLARE
		@StartDateKey INT
	,	@EndDateKey INT
	--,	@NSCenterNum SMALLINT

	SET @EndDate = @EndDate + ' 23:59'
	--SET @NSCenterNum =
	--	CASE
	--			when @CenterNum between 300 and 399 then @CenterNum - 100
	--			when @CenterNum between 500 and 699 then @CenterNum + 200
	--			else @CenterNum end
	--SET @RegionID = Select RegionSSID from dbo.synHC_ENT_DDS_vwDimCenter
	--					where CenterSSID = @CenterNum

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
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM dbo.vw_SurgerySalesOrderDetail SURG
		WHERE OrderDate BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1010, 1099)
		AND MembershipID = 43
		AND (AccumulatorKey = 48 OR SalescodeDescriptionShort = 'CANCEL')
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 2) -- First Surgery Net $
	BEGIN
		SELECT
			ClientHomeCenterID as 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM dbo.vw_SurgerySalesOrderDetail SURG
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (2020)
		AND MembershipID = 43
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 3) -- First Surgery Grafts
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM dbo.vw_SurgerySalesOrderDetail
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag= 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1010,1030,1040)
		AND MembershipID = 43
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 13) -- First Surgery Contract Amount
	BEGIN
		--INSERT INTO #TempAccumByDate
		--EXEC ('[selClientMembershipAccumulatorsByTimePeriod] ''' + @StartDate + ''',''' + @EndDate + ''',''' +  @CenterNum + ''', NULL' )

		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM dbo.vw_SurgerySalesOrderDetail
			--LEFT JOIN #TempAccumByDate
			--	ON #TempAccumByDate.[ClientMembershipGUID] = [vw_SurgerySalesOrderDetail].[ClientMembershipGUID]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
			AND SalesOrderVoidedFlag = 0
			AND SalesOrderClosedFlag = 1
			AND SalesCodeDepartmentID IN (1010,1030,1040)
			AND MembershipID = 43
			AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 4) -- Addtl Surgery Net Sales
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1075, 1090, 1099)
		AND MembershipID = 44
		AND (AccumulatorKey = 48 OR SalescodeDescriptionShort = 'CANCEL')
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 5) -- Addtl Surgery Net $
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (2020)
		AND MembershipID = 44
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 6) -- Addtl Surgery Grafts
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1075, 1090, 1030, 1040)
		AND MembershipID = 44
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 14) -- Addtl Surgery Contract Amount
	BEGIN
		--INSERT INTO #TempAccumByDate
		--EXEC ('[selClientMembershipAccumulatorsByTimePeriod] ''' + @StartDate + ''',''' + @EndDate + ''',''' +  @CenterNum + ''', NULL' )

		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
			--LEFT JOIN #TempAccumByDate
			--	ON #TempAccumByDate.[ClientMembershipGUID] = [vw_SurgerySalesOrderDetail].[ClientMembershipGUID]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (1075, 1090, 1030, 1040)
		AND MembershipID = 44
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 7) -- Total surgery performed
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (5060)
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 8) -- Total surgery net $
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND DoctorRegionID = @RegionID
		AND SalesCodeDepartmentID IN (5060)
		ORDER BY [OrderDate]
	END

	IF (@ReportType = 9) -- Total surgery grafts
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND DoctorRegionID = @RegionID
		AND SalesCodeDepartmentID IN (5060)
		ORDER BY [OrderDate]
	END

	IF (@ReportType IN (17, 18)) -- Total surgery POSTEXT #
	BEGIN
		SELECT
			ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail]
		WHERE [OrderDate] BETWEEN @StartDate AND @EndDate
		AND SalesOrderVoidedFlag = 0
		AND SalesOrderClosedFlag = 1
		AND SalesCodeDepartmentID IN (2025)
		AND DoctorRegionID = @RegionID
		ORDER BY [OrderDate]
	END

	IF (@ReportType IN (20)) -- Deposit #
	BEGIN

		SELECT 	so.ClientHomeCenterID 'center'
		,	ClientHomeCenterDescription as 'centername'
		,   ClientHomeCenterDescriptionFullCalc as 'CenterDescriptionFullCalc'
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
		FROM [vw_SurgerySalesOrderDetail] so
		WHERE so.[OrderDate] BETWEEN @StartDate AND @EndDate
			AND so.SalesOrderVoidedFlag = 0
			AND so.SalesOrderClosedFlag = 1
			AND so.SalesCodeDepartmentID IN (7015)
			AND DoctorRegionID = @RegionID
		ORDER BY[OrderDate]

	END

	IF (@ReportType IN (21)) -- Surgery Consultations #
	BEGIN

		SELECT
			CASE
				when ACT.CenterSSID between 200 and 299 then ACT.CenterSSID + 100
				when ACT.CenterSSID between 700 and 899 then ACT.CenterSSID - 200
				else ACT.CenterSSID end
					AS 'CenterID',
			CTR.CenterDescription as 'centername',
			ACT.ActivityCompletionDate,
			ACT.ActivityDueDate,
			ACT.ActivityTypeDescription,
			ACT.ActionCodeSSID,
			ACTRES.ResultCodeSSID,
			ACTDEM.NoSaleReason,
			ACTDEM.Performer
		,CTCT.ContactFullName AS 'Client'
		FROM dbo.synHC_MKTG_DDS_vwDimActivityResult ACTRES
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActivity ACT on
				ACTRES.ActivitySSID = ACT.ActivitySSID
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActionCode ACTCODE on
				ACT.ActionCodeSSID = ACTCODE.ActionCodeSSID
			INNER JOIN dbo.synHC_MKTG_DDS_vwDimActivityDemographic ACTDEM on
				ACT.ActivitySSID = ACTDEM.ActivitySSID
                  INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR on
                        CTR.CenterSSID =
                                          CASE
                                          when ACT.CenterSSID between 200 and 299 then ACT.CenterSSID + 100
                                          when ACT.CenterSSID between 700 and 899 then ACT.CenterSSID - 200
                                          else ACT.CenterSSID end
                  INNER JOIN dbo.synHC_ENT_DDS_vwDimDoctorRegion DOCREG on
                        CTR.DoctorRegionSSID = DOCREG.DoctorRegionSSID
             INNER JOIN dbo.synHC_MKTG_DDS_vwDimContact CTCT
				ON ACTRES.ContactSSID = CTCT.ContactSSID
		WHERE ACT.ActivityDueDate between @StartDate AND @EndDate
			AND ACT.IsBeBack=0
			AND ACTRES.SurgeryOffered = 'Y'
			AND DOCREG.DoctorRegionSSID = @RegionID

	END

END
