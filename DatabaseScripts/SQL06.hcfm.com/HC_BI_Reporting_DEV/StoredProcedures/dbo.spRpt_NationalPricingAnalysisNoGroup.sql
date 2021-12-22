/***********************************************************************
PROCEDURE:				spRpt_NationalPricingAnalysisNoGroup
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			National Pricing Analysis - No Group
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/19/2013
------------------------------------------------------------------------
NOTES:

11/05/2013 - DL - Converted Stored procedure
11/15/2016 - RH - Changed DM.MembershipMonthlyFee to DCM.ClientMembershipMonthlyFee so the difference makes sense; Added TransactionDate (Monthly Fee Change Date) (#132172)
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
07/18/2017 - RH - (#140979) Changed source of National Rates from HC_DeferredRevenue.dbo.DimMembershipRatesByCenter to SQL05.HairClubCMS.dbo.cfgCenterMembership
08/25/2017 - RH - (#142423) National Pricing should only include Recurring Business
04/16/2018 - RH - (#145957) Combined Regions and Areas into MainGroups
02/12/2019 - DL - Changed the CASE statement for the NationalRate to use the NationalMonthlyFee value on the DimClientMembership table (if it exists) instead of the rate in the #NationalRates table
08/08/2019 - RH - (#185) Added TotalContractPrice, TotalPayments, Difference2, DaysRemaining, ClientIdentifier, join on HC_Accounting.dbo.dbaClient; pull membership rates from HC_DeferredRevenue_DAILY.dbo.DimMembershipRatesByCenter
08/23/2019 - RH - (#12821) Removed @SpecifiyDate, @Month2, @Year2
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NationalPricingAnalysisNoGroup 2, 0, 7, 2019, 1

EXEC spRpt_NationalPricingAnalysisNoGroup 8, 0, 8, 2019, 1
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NationalPricingAnalysisNoGroup]
(
	@CenterType INT
,	@Filter INT
,	@Month INT
,	@Year INT
,	@NationalRate INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/*
@CenterType
	2 - Corporate
	8 - Franchise

@Filter
	0 - All Clients
	1 - Clients LESS THAN the national rate
	2 - Clients GREATER THAN the national rate

@NationalRate
	0 - Old National Rates
	1 - New National Rates
*/


DECLARE @MonthStart DATETIME
DECLARE @PreviousTwoMonthsStart DATETIME
DECLARE @EndOfLastMonth DATETIME
DECLARE @MemBeginDate DATETIME
DECLARE @MemEndDate DATETIME



		SET @MonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year))




IF @NationalRate = 0
	BEGIN
		SET @MemBeginDate = DATEADD(MONTH, -24, '3/31/11 23:59')
		SET @MemEndDate = '3/31/11 23:59'
	END
ELSE
	BEGIN
		SET @MemBeginDate = '4/1/11'
		SET @MemEndDate = GETDATE()
	END


SET @PreviousTwoMonthsStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DATEADD(MONTH, -2, GETDATE()))) + '/1/' + CONVERT(VARCHAR, YEAR(DATEADD(MONTH, -2, GETDATE()))))
SET @EndOfLastMonth = DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, DATEADD(MONTH, 1, @PreviousTwoMonthsStart)) + 1, 0))


/********************************** Create Temp Table Objects *************************************/
CREATE TABLE #Centers (
	MainGroupSSID INT
,	MainGroupDescription VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterDescription VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(10)
)


CREATE TABLE #Comparison (
	MainGroupSSID INT
,	MainGroupDescription VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(10)
,	ClientIdentifier INT
,	GenderSSID INT
,	Client VARCHAR(250)
,	ClientLastName VARCHAR(250)
,	ClientFirstName VARCHAR(250)
,	MembershipKey INT
,	ClientMembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	CurrentRate MONEY
,	NationalRate MONEY
,	AvgEFT MONEY
,	DeferredBalance MONEY
,	TransactionDate DATETIME
)


CREATE TABLE #PreviousTwoMonths (
	CenterNumber INT
,	ClientIdentifier INT
,	ClientKey INT
,	ClientMembershipKey INT
,	SalesCodeDepartmentSSID INT
,	Price MONEY
,	Qty INT
)


CREATE TABLE #EFT (
	CenterNumber INT
,	ClientKey INT
,	ClientMembershipKey INT
,	AvgEFT MONEY
)


CREATE TABLE #National(
	MainGroupSSID INT
,   MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	Center INT
,   CenterName NVARCHAR(50)
,	ClientIdentifier INT
,   ClientName NVARCHAR(50)
,   Membership NVARCHAR(50)
,   MembershipStartDate DATETIME
,   MembershipEndDate DATETIME
,   CurrentRate MONEY
,   NationalRate MONEY
,   [Difference] MONEY
,   AvgEFT MONEY
,   DeferredBalance MONEY
,	TransactionDate DATETIME
)

/********************************** Get List of Centers *************************************/
IF @CenterType = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupSSID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DC.CenterDescription
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE   DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
	END


IF @CenterType = 8
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupSSID'
				,		DR.RegionDescription AS 'MainGroupDescription'
				,		DR.RegionSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DC.CenterDescription
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   DCT.CenterTypeDescriptionShort IN ('F','JV')
						AND DC.Active = 'Y'
	END


/********************************** Get Report Data *************************************/
INSERT  INTO #Comparison
		SELECT	C.MainGroupSSID
		,		C.MainGroupDescription
		,		C.MainGroupSortOrder
		,		C.CenterNumber
		,		C.CenterDescription
		,		C.CenterDescriptionNumber
		,		C.CenterTypeDescriptionShort
		,		CLT.ClientIdentifier
		,		CLT.GenderSSID
		,       CLT.ClientFullName
		,		CLT.ClientLastName
		,		CLT.ClientFirstName
		,		DM.MembershipKey
		,		DCM.ClientMembershipKey
		,		DM.MembershipDescription
		,		DCM.ClientMembershipBeginDate
		,		DCM.ClientMembershipEndDate
		,		DCM.ClientMembershipMonthlyFee AS 'CurrentRate'
		,		nrates.MembershipRate AS 'NationalRate'
		,		0 AS 'AvgEFT'
		,		ISNULL(FDRH.Deferred, 0) AS 'DeferredBalance'
		,		CONVERT(VARCHAR(30),TransactionDate,101) AS 'TransactionDate'
		FROM    SQL05.HairClubCMS.dbo.datClientEFT DCE
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON DCE.ClientGUID = CLT.ClientSSID
				INNER JOIN #Centers C
					ON CLT.CenterSSID = C.CenterSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
					ON DCE.ClientMembershipGUID = DCM.ClientMembershipSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON DCM.MembershipKey = DM.MembershipKey
				LEFT OUTER JOIN HC_DeferredRevenue_DAILY.dbo.FactDeferredRevenueHeader FDRH
					ON DCM.ClientMembershipKey = FDRH.ClientMembershipKey
				LEFT OUTER JOIN
				(SELECT NR.CenterSSID
					, NR.MembershipKey
					, NR.MembershipRate
					, ROW_NUMBER()OVER(PARTITION BY NR.CenterSSID, NR.MembershipKey ORDER BY NR.MembershipRate DESC) AS 'Rank'
				FROM HC_DeferredRevenue_DAILY.dbo.DimMembershipRatesByCenter NR
				INNER JOIN #Centers C
					ON C.CenterSSID = NR.CenterSSID
				) nrates
			ON CLT.CenterSSID = nrates.CenterSSID AND nrates.MembershipKey = DM.MembershipKey AND nrates.[Rank] = 1
				LEFT OUTER JOIN
						(SELECT CT.ClientGUID
							, CT.TransactionDate
							, CT.MonthlyFeeAmount
							, ROW_NUMBER()OVER(PARTITION BY CT.ClientGUID ORDER BY CT.TransactionDate DESC) AS 'Ranking'
						FROM [dbo].[synHairclubCMS_datClientTransaction] CT
						WHERE CT.ClientProcessID = 8
							AND TransactionDate >= @MonthStart) trans
					ON DCE.ClientGUID = trans.ClientGUID AND trans.Ranking = 1
		WHERE	DCM.ClientMembershipEndDate >= @MonthStart
				AND DCM.ClientMembershipBeginDate BETWEEN @MemBeginDate AND @MemEndDate
				AND DM.RevenueGroupSSID = 2

--Reset to NULL - values where the MembershipStartDate is greater than or equal to the TransactionDate (Monthly Fee Adjustment Date)

UPDATE #Comparison
SET TransactionDate = NULL
FROM #Comparison
WHERE ClientMembershipBeginDate >= #Comparison.TransactionDate


--Get previous two months of transactions
INSERT	INTO #PreviousTwoMonths
        SELECT  DC.CenterNumber
		,		COMP.ClientIdentifier
		,		FST.ClientKey
		,		FST.ClientMembershipKey
		,		DSC.SalesCodeDepartmentSSID
		,		FST.Price
		,		FST.Quantity
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                    ON FST.SalesCodeKey = DSC.SalesCodeKey
				INNER JOIN #Comparison COMP
                    ON FST.ClientMembershipKey = COMP.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                    ON FST.ClientMembershipKey = DCM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                    ON DCM.MembershipKey = DM.MembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON DCM.CenterKey = DC.CenterKey
                INNER JOIN #Centers
                    ON DC.CenterSSID = #Centers.CenterSSID
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
        WHERE   DD.FullDate BETWEEN @PreviousTwoMonthsStart AND @EndOfLastMonth
				AND DSC.SalesCodeDepartmentSSID IN ( 2020 )
				AND DM.RevenueGroupSSID = 2


/*********** Get average EFT for the previous two months **************************/
--First find the SUM
INSERT	INTO #EFT
		SELECT  CenterNumber
		,       ClientKey
		,       ClientMembershipKey
		,       SUM(Price) AS 'AvgEFT'
		FROM    #PreviousTwoMonths
		WHERE   SalesCodeDepartmentSSID IN ( 2020 )
		GROUP BY CenterNumber
		,       ClientKey
		,       ClientMembershipKey


--Update table with EFT average
UPDATE  #Comparison
SET     #Comparison.AvgEFT = #EFT.AvgEFT / 2
FROM    #Comparison
        INNER JOIN #EFT
            ON #Comparison.ClientMembershipKey = #EFT.ClientMembershipKey

/******************** Select statement for the report ******************************/

IF	@Filter = 0 --ALL
	BEGIN
		INSERT INTO #National
		SELECT  C.MainGroupSSID
        ,       C.MainGroupDescription
		,		C.MainGroupSortOrder
		,       C.CenterNumber AS 'Center'
		,       C.CenterDescription AS 'CenterName'
		,		C.ClientIdentifier
		,       C.Client AS 'ClientName'
		,       C.MembershipDescription
		,		C.ClientMembershipBeginDate
		,		C.ClientMembershipEndDate
		,       C.CurrentRate
		,       C.NationalRate
		,       C.CurrentRate - C.NationalRate AS 'Difference'
		,       C.AvgEFT
		,       C.DeferredBalance
		,		C.TransactionDate
		FROM	#Comparison C
		WHERE   CurrentRate < NationalRate
				OR CurrentRate > NationalRate
	END


IF	@Filter = 1 --Less than
	BEGIN
		INSERT INTO #National
		SELECT  C.MainGroupSSID
        ,       C.MainGroupDescription
		,		C.MainGroupSortOrder
		,       C.CenterNumber AS 'Center'
		,       C.CenterDescription AS 'CenterName'
		,		C.ClientIdentifier
		,       C.Client AS 'ClientName'
		,       C.MembershipDescription
		,		C.ClientMembershipBeginDate
		,		C.ClientMembershipEndDate
		,       C.CurrentRate
		,       C.NationalRate
		,       C.CurrentRate - C.NationalRate AS 'Difference'
		,       C.AvgEFT
		,       C.DeferredBalance
		,		C.TransactionDate
		FROM	#Comparison C
		WHERE   CurrentRate < NationalRate
	END


IF	@Filter = 2 --Greater than
	BEGIN
		INSERT INTO #National
		SELECT  C.MainGroupSSID
        ,       C.MainGroupDescription
		,		C.MainGroupSortOrder
		,       C.CenterNumber AS 'Center'
		,       C.CenterDescription AS 'CenterName'
		,		C.ClientIdentifier
		,       C.Client AS 'ClientName'
		,       C.MembershipDescription
		,		C.ClientMembershipBeginDate
		,		C.ClientMembershipEndDate
		,       C.CurrentRate
		,       C.NationalRate
		,       C.CurrentRate - C.NationalRate AS 'Difference'
		,       C.AvgEFT
		,       C.DeferredBalance
		,		C.TransactionDate
		FROM	#Comparison C
		WHERE   CurrentRate > NationalRate
	END


SELECT		NAT.MainGroupSSID
    ,       NAT.MainGroupDescription
	,		NAT.MainGroupSortOrder
	,       NAT.Center
	,       NAT.CenterName
	,		NAT.ClientIdentifier
    ,		NAT.ClientName
    ,		NAT.Membership
    ,		NAT.MembershipStartDate
    ,		NAT.MembershipEndDate
    ,		NAT.CurrentRate
    ,		NAT.NationalRate
    ,		NAT.[Difference]
    ,		NAT.AvgEFT
    ,		NAT.DeferredBalance
    ,		NAT.TransactionDate
	,	(dCLT.BIO_ContractPrice + dCLT.EXT_ContractPrice+ dCLT.SUR_ContractPrice+ dCLT.XTR_ContractPrice) AS TotalContractPrice
,	(dCLT.BIO_TotalPayments + dCLT.EXT_TotalPayments+ dCLT.SUR_TotalPayments+ dCLT.XTR_TotalPayments) AS TotalPayments
,	(dCLT.BIO_ContractPrice + dCLT.EXT_ContractPrice+ dCLT.SUR_ContractPrice+ dCLT.XTR_ContractPrice) - (dCLT.BIO_TotalPayments + dCLT.EXT_TotalPayments+ dCLT.SUR_TotalPayments+ dCLT.XTR_TotalPayments) AS [Difference2]
,	DATEDIFF(DAY,GETDATE(),NAT.MembershipEndDate) AS DaysRemaining
FROM #National NAT
	INNER JOIN HC_ACcounting.dbo.dbaClient dCLT
		ON dCLT.ClientIdentifier = NAT.ClientIdentifier
WHERE NAT.MembershipEndDate >= @MonthStart
				AND NAT.MembershipStartDate BETWEEN @MemBeginDate AND @MemEndDate

END
