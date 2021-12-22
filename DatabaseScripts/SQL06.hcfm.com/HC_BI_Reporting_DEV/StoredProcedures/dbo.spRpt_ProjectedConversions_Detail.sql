/***********************************************************************
PROCEDURE:				spRpt_ProjectedConversions_Detail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			ProjectedConversions.rdl
AUTHOR:	Rachelen Hut
DATE IMPLEMENTED:		08/24/2016
------------------------------------------------------------------------
NOTES: @ReportType is 2 for "By Area Managers" and 1 for "By Franchise Regions" and 3 for "By Center"
	   @SaleType is 1 for "Xtrands Plus", 2 for "EXT" and 3 for "Xtrands";
	   The Detail is pulled by MainGroupID - for the specific Region or AreaManager, or 100 = Corporate and 101 = Franchise
	   @DrillDown is which drilldown was clicked on the Summary report:
		1 for "NB Sales"
		2 for "Conversions"				--Converted
		3 for "Projected Conversions"	--NotConverted with ExpectedConversionDate within the date parameters
------------------------------------------------------------------------
CHANGE HISTORY:
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
01/20/2017 - RH - (#134854) Changed #Center population for Area Managers where @MainGroupID = 100
07/25/2018 - RH - (#150571) For XTR+ only, show ExpectedConversionDate for those with an NSD
03/04/2020 - RH - TrackIT 4831 Changed the ExpectedConversionDate for XTR+ 12 (based on the NB1A) and EXT 12 memberships (based on the first service date)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ProjectedConversions_Detail] 1, 2, 2020, 1, 6, 1
EXEC [spRpt_ProjectedConversions_Detail] 3, 2, 2020, 1, 201, 1
EXEC [spRpt_ProjectedConversions_Detail] 3, 2, 2020, 2, 821, 3
EXEC [spRpt_ProjectedConversions_Detail] 1, 2, 2020, 2, 6, 1

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_ProjectedConversions_Detail](
	@ReportType INT
,	@Month INT
,	@Year INT
,	@SaleType INT
,	@MainGroupID INT
,	@DrillDown INT
)

AS
BEGIN

--Find the first day of the month and the last day based on @Month and @Year

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
DECLARE @Today DATETIME;

SELECT  @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME);  --Beginning of the month
SELECT  @EndDate = DATEADD(DAY ,-1 ,DATEADD(MONTH ,1 ,@StartDate)) + '23:59:000';   					--End of the same month
SELECT  @Today = DATEADD(day,DATEDIFF(day,0,GETDATE()),0);


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder NVARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
)


CREATE TABLE #NBSales(
	CenterKey INT
,   CenterDescription NVARCHAR(50)
,	ClientKey INT
,   ClientIdentifier INT
,   ClientFullName NVARCHAR(150)
,	ExpectedConversionDate DATETIME
,   FullDate DATETIME
,   SalesCodeDescriptionShort NVARCHAR(50)
,   SalesCodeDescription NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,   MembershipStatus NVARCHAR(50)
,   ContractPrice MONEY
,	ContractPaidAmount MONEY
,   MonthlyFee MONEY
,   MembershipBeginDate DATETIME
,   MembershipEndDate DATETIME
,	BusinessSegmentSSID INT
,	RevenueGroupSSID INT
,	qty INT
,   EmployeeInitials NVARCHAR(2)
,   SalesCodeDepartmentSSID INT
,   Voided NVARCHAR(25)
,	ClientMembershipKey INT
,   NB_Cnt INT
,	IsConverted INT
)


CREATE TABLE #Conv(ClientIdentifier INT
      , ClientKey INT
      , MainGroupID INT
	  , MainGroup NVARCHAR(50)
      , CenterSSID INT
	  ,	CenterKey INT
	  , CenterDescription NVARCHAR(50)
	  , CenterDescriptionNumber NVARCHAR(50)
      , ExpectedConversionDate DATETIME
      , ClientFullName NVARCHAR(150)
	  , ClientMembershipKey INT
      , MembershipBeginDate DATETIME
      , MembershipEndDate DATETIME
	  , MembershipStatus NVARCHAR(50)
      , MembershipDescription NVARCHAR(50)
      , BusinessSegmentSSID INT
      , RevenueGroupSSID INT
      , ContractPrice MONEY
      , ContractPaidAmount MONEY
	  , NB_BIOConvCnt INT
	  , NB_EXTConvCnt INT
	  , NB_XTRConvCnt INT
	  ,	IsConverted INT
	)


CREATE TABLE #newstyle(
	ClientKey INT
,	ClientMembershipKey INT
,	Fulldate DATETIME
,	Ranking INT
)


CREATE TABLE #FirstService(
		FSRank INT
,		ClientKey INT
,		ClientMembershipKey INT
,		AppointmentDate DATETIME
,		FirstServiceDate DATETIME
)


CREATE TABLE #newstyle2(
	ClientKey INT
,	ClientMembershipKey INT
,	Fulldate DATETIME
,	Ranking INT
)


CREATE TABLE #FirstService2(
		FSRank INT
,		ClientKey INT
,		ClientMembershipKey INT
,		AppointmentDate DATETIME
,		FirstServiceDate DATETIME
)


CREATE TABLE #All(CenterKey INT
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(250)
,	ExpectedConversionDate DATETIME
,	ClientMembershipKey INT
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	ClientMembershipStatusDescription NVARCHAR(60)
,	MembershipDescription NVARCHAR(60)
,	BusinessSegmentSSID INT
,	RevenueGroupSSID INT
,	ClientMembershipContractPrice DECIMAL(18,4)
,	ClientMembershipContractPaidAmount DECIMAL(18,4)
)

CREATE TABLE #Final (
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	MainGroupSortOrder NVARCHAR(50)
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(103)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName  NVARCHAR(150)
,	MembershipDescription NVARCHAR(50)
,	MembershipBeginDate DATETIME
,	MembershipStatus NVARCHAR(50)
,	ExpectedConversionDate DATETIME
,	BusinessSegmentSSID INT
,	RevenueGroupSSID INT
,	ContractPrice MONEY
,	ContractPaidAmount MONEY
,	SalesCodeDescriptionShort NVARCHAR(50)
,	InitialNewStyleDate DATETIME
,	IsConverted INT
,	Ranking INT
,	EmployeeInitials NVARCHAR(2)
,	FirstServiceDate DATETIME
,	LastServiceDate DATETIME
,	NextServiceDate DATETIME
,	RemainingSalonVisits INT
,	RemainingProductKits INT
,	qty INT
	);

/********************************** Get list of centers *************************************/
IF (@ReportType = 1  AND @MainGroupID BETWEEN 2 AND 16)					--A Region has been selected
    BEGIN
        INSERT  INTO #Centers
                SELECT  DR.RegionSSID AS 'MainGroupID'
                      , DR.RegionDescription AS 'MainGroup'
					  , CAST(DR.RegionSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
                      , DC.CenterKey
                      , DC.CenterSSID
                      , DC.CenterDescription
                      , DC.CenterDescriptionNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR ON DC.RegionKey = DR.RegionKey
                WHERE   DC.CenterNumber LIKE '[78]%'
                        AND DC.Active = 'Y'
						AND DR.RegionSSID = @MainGroupID;
    END;
ELSE
IF (@ReportType = 2	AND @MainGroupID NOT IN(100,101))					-- An Area Manager has been selected
    BEGIN

        INSERT  INTO #Centers
                SELECT DISTINCT
                        CMA.CenterManagementAreaSSID AS 'MainGroupID'
                      , CMA.CenterManagementAreaDescription AS 'MainGroup'
					  ,	CAST(CMA.CenterManagementAreaSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
                      , DC.CenterKey
                      , DC.CenterSSID
                      , DC.CenterDescription
                      , DC.CenterDescriptionNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
                WHERE   CMA.Active = 'Y'
					AND DC.Active = 'Y'
					AND CMA.CenterManagementAreaSSID = @MainGroupID;
    END
ELSE
IF (@ReportType  = 3	AND @MainGroupID NOT IN (100,101) )			--A Center has been selected
	BEGIN
	INSERT  INTO #Centers
                SELECT  DC.CenterNumber AS 'MainGroupID'
                      , DC.CenterDescriptionNumber AS 'MainGroup'
					  , DC.CenterDescription AS 'MainGroupSortOrder'
                      , DC.CenterKey
                      , DC.CenterSSID
                      , DC.CenterDescription
                      , DC.CenterDescriptionNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                WHERE   DC.CenterNumber = @MainGroupID
                        AND DC.Active = 'Y'
	END
ELSE
IF (@ReportType IN (1,2,3) AND @MainGroupID = 100)						--A Grand Total for Corporate has been selected
	BEGIN
	INSERT  INTO #Centers
                SELECT  100 AS 'MainGroupID'
                      , 'Corporate' AS 'MainGroup'
					  ,	DC.CenterDescription AS 'MainGroupSortOrder'
                      , DC.CenterKey
                      , DC.CenterSSID
                      , DC.CenterDescription
                      , DC.CenterDescriptionNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
                WHERE   DC.Active = 'Y'
					AND CT.CenterTypeDescriptionShort = 'C'
					AND DC.CenterDescription <> 'Virtual'
					AND CenterDescription <> 'Hans Wiemann'
					AND CenterDescription <> 'IHI'
					AND CenterDescription <> 'London Hair Clinic'

	END
ELSE
IF (@ReportType IN(1,3) AND @MainGroupID = 101)								--A Grand Total for Franchise has been selected
	BEGIN
	INSERT  INTO #Centers
                SELECT  101 AS 'MainGroupID'
                      , 'Franchise' AS 'MainGroup'
					  ,	DR.RegionSortOrder AS 'MainGroupSortOrder'
                      , DC.CenterKey
                      , DC.CenterSSID
                      , DC.CenterDescription
                      , DC.CenterDescriptionNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DR.RegionKey = DC.RegionKey
                WHERE   DC.Active = 'Y'
					AND DC.CenterSSID LIKE '[78]%'
	END

	--SELECT * FROM #Centers
;
/********************************** Get sales data *************************************************/

IF (@DrillDown = 1 AND @SaleType = 1)							--XTR+
BEGIN

INSERT INTO #newstyle
SELECT 	FST.ClientKey
,	FST.ClientMembershipKey
,	DD2.FullDate
,	ROW_NUMBER()OVER(PARTITION BY  FST.ClientKey ORDER BY DD2.FullDate DESC) AS 'Ranking'
FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2 ON FST.OrderDateKey = DD2.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON CLT.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
		INNER JOIN #Centers C
		ON DCM.CenterKey = C.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE DD2.FullDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today
	AND CLT.ClientKey = FST.ClientKey
    AND SC.SalesCodeDescriptionShort = 'NB1A'
	AND DM.RevenueGroupSSID = 1
	AND DM.BusinessSegmentSSID = 1
	AND DCM.ClientMembershipStatusDescription = 'Active'
	AND DM.MembershipSSID NOT IN(11,12,49,50,57)
GROUP BY FST.ClientKey,
         FST.ClientMembershipKey,
         DD2.FullDate

		 --SELECT '#newstyle' AS tablename,* FROM #newstyle

INSERT INTO #NBSales
SELECT  C.CenterKey
	,   C.CenterDescription
	,	CLT.ClientKey
	,   CLT.ClientIdentifier
	,   CLT.ClientFullName
	,	DATEADD(MONTH,M.MembershipDurationMonths,NB1A.FullDate) AS ExpectedConversionDate
	,   DD.FullDate
	,   SC.SalesCodeDescriptionShort
	,   SC.SalesCodeDescription
	,	M.MembershipDescription
	,   CM.ClientMembershipStatusDescription AS 'MembershipStatus'
	,   CM.ClientMembershipContractPrice AS 'ContractPrice'
	,	CM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
	,   CM.ClientMembershipMonthlyFee AS 'MonthlyFee'
	,   CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
	,   CM.ClientMembershipEndDate AS 'MembershipEndDate'
	,	M.BusinessSegmentSSID
	,	M.RevenueGroupSSID
	,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
						 WHEN m.BusinessSegmentSSID = 3
							  AND SC.Salescodedepartmentssid = 1010 THEN 1
						 ELSE FST.Quantity
					END AS 'qty'
	,   E.EmployeeInitials
	,   SC.SalesCodeDepartmentSSID
	,	CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
				ELSE ''
		END AS 'Voided'
	,	CM.ClientMembershipKey
	,   (ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0)) AS 'NB_Cnt'
	,	-1 AS 'IsConverted'	--This is to show that it is NBSales
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON FST.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipSSID = M.MembershipSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		--ON FST.CenterKey = c.CenterKey  --Keep Home-Center based to match the summary
		ON CM.CenterKey = C.CenterKey
	INNER JOIN #Centers
		ON C.CenterKey = #Centers.CenterKey
	LEFT OUTER JOIN #newstyle NB1A
		ON (NB1A.ClientMembershipKey = CM.ClientMembershipKey) AND (NB1A.Ranking = 1 OR NB1A.Ranking IS NULL)

WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND CM.ClientMembershipBeginDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND (ISNULL(FST.NB_TradCnt, 0) <> 0 OR ISNULL(FST.NB_GradCnt, 0) <> 0)


	--SELECT '#NBSales' AS tablename, * FROM #NBSales

END



ELSE IF (@DrillDown = 1 AND @SaleType = 2)							--EXT
BEGIN

INSERT INTO #FirstService
SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
,		DA.ClientKey
,		FST.ClientMembershipKey
,		DA.AppointmentDate
,		ISNULL(DD3.FullDate,'') AS 'FirstServiceDate'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD3
			ON FST.OrderDateKey = DD3.DateKey
		INNER JOIN #Centers
			ON #Centers.CenterKey = FST.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
			ON FST.ClientKey = DA.ClientKey
			AND DD3.Fulldate = DA.AppointmentDate
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DA.ClientMembershipKey = FST.ClientMembershipKey
		AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
		AND DD3.FullDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today		--This reduces query time


INSERT INTO #NBSales
SELECT  C.CenterKey
	,   C.CenterDescription
	,	CLT.ClientKey
	,   CLT.ClientIdentifier
	,   CLT.ClientFullName
	,	DATEADD(MONTH,M.MembershipDurationMonths,FS.FirstServiceDate) AS ExpectedConversionDate
	,   DD.FullDate
	,   SC.SalesCodeDescriptionShort
	,   SC.SalesCodeDescription
	,	M.MembershipDescription
	,   CM.ClientMembershipStatusDescription AS 'MembershipStatus'
	,   CM.ClientMembershipContractPrice AS 'ContractPrice'
	,	CM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
	,   CM.ClientMembershipMonthlyFee AS 'MonthlyFee'
	,   CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
	,   CM.ClientMembershipEndDate AS 'MembershipEndDate'
	,	M.BusinessSegmentSSID
	,	M.RevenueGroupSSID
	,	CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
						 WHEN m.BusinessSegmentSSID = 3
							  AND SC.Salescodedepartmentssid = 1010 THEN 1
						 ELSE FST.Quantity
					END AS 'qty'
	,   E.EmployeeInitials
	,   SC.SalesCodeDepartmentSSID
	,	CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
				ELSE ''
		END AS 'Voided'
	,	CM.ClientMembershipKey
	,   ISNULL(FST.NB_ExtCnt, 0)  AS 'NB_Cnt'
	,	-1 AS 'IsConverted'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON SO.ClientMembershipKey = cm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON cm.MembershipSSID = m.MembershipSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		--ON FST.CenterKey = c.CenterKey  --Keep Home-Center based to match the summary
		ON CM.CenterKey = C.CenterKey
	INNER JOIN #Centers
		ON C.CenterKey = #Centers.CenterKey
	LEFT OUTER JOIN #FirstService FS
		ON FS.ClientMembershipKey = CM.ClientMembershipKey AND (FS.FSRank = 1 OR FS.FSRank IS NULL)
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND CM.ClientMembershipBeginDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND ISNULL(FST.NB_ExtCnt, 0) <> 0

END
ELSE IF (@DrillDown = 1 AND @SaleType = 3)   --XTR
BEGIN
INSERT INTO #NBSales
SELECT  C.CenterKey
	,   C.CenterDescription
	,	CLT.ClientKey
	,   CLT.ClientIdentifier
	,   CLT.ClientFullName
	,	CLT.ExpectedConversionDate
	,   DD.FullDate
	,   SC.SalesCodeDescriptionShort
	,   SC.SalesCodeDescription
	,	M.MembershipDescription
	,   CM.ClientMembershipStatusDescription AS 'MembershipStatus'
	,   CM.ClientMembershipContractPrice AS 'ContractPrice'
	,	CM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
	,   CM.ClientMembershipMonthlyFee AS 'MonthlyFee'
	,   CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
	,   CM.ClientMembershipEndDate AS 'MembershipEndDate'
	,	M.BusinessSegmentSSID
	,	M.RevenueGroupSSID
	,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
						 WHEN m.BusinessSegmentSSID = 3
							  AND SC.Salescodedepartmentssid = 1010 THEN 1
						 ELSE FST.Quantity
					END AS 'qty'
	,   E.EmployeeInitials
	,   SC.SalesCodeDepartmentSSID
	,	CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
				ELSE ''
		END AS 'Voided'
	,	CM.ClientMembershipKey
	,   ISNULL(FST.NB_XTRCnt, 0)  AS 'NB_Cnt'
	,	-1 AS 'IsConverted'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON SO.ClientMembershipKey = cm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON cm.MembershipSSID = m.MembershipSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		--ON FST.CenterKey = c.CenterKey  --Keep Home-Center based to match the summary
		ON CM.CenterKey = C.CenterKey
	INNER JOIN #Centers
		ON C.CenterKey = #Centers.CenterKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND CM.ClientMembershipBeginDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND ISNULL(FST.NB_XTRCnt, 0) <> 0
END


/********* Find those who have converted ***************/

IF (@DrillDown = 2 AND @SaleType = 1)        --Conversion for XTR+
BEGIN
INSERT INTO #Conv
SELECT  CLT.ClientIdentifier
      , CLT.ClientKey
      , C.MainGroupID
	  , C.MainGroup
      , DCM.CenterSSID
	  ,	C.CenterKey
	  , C.CenterDescription
	  , C.CenterDescriptionNumber
      , CLT.ExpectedConversionDate
      , CLT.ClientFullName
	  , DCM.ClientMembershipKey
      , DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
      , DCM.ClientMembershipEndDate AS 'MembershipEndDate'
	  , DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
      , DM.MembershipDescription
      , DM.BusinessSegmentSSID
      , DM.RevenueGroupSSID
      , DCM.ClientMembershipContractPrice AS 'ContractPrice'
      , DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
	  , ISNULL(FST.NB_BIOConvCnt,0) AS 'NB_BIOConvCnt'
	  , ISNULL(FST.NB_EXTConvCnt,0) AS 'NB_EXTConvCnt'
	  , ISNULL(FST.NB_XTRConvCnt,0) AS 'NB_XTRConvCnt'
	  ,	1 AS 'IsConverted'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON FST.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
	INNER JOIN #Centers C
		ON DCM.CenterKey = C.CenterKey

WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND ISNULL(FST.NB_BIOConvCnt,0) <> 0
	AND DM.BusinessSegmentSSID = 1

END
ELSE
IF (@DrillDown = 2 AND @SaleType = 2)        --Conversion for EXT
BEGIN
INSERT INTO #Conv
SELECT  CLT.ClientIdentifier
      , CLT.ClientKey
      , C.MainGroupID
	  , C.MainGroup
      , DCM.CenterSSID
	  ,	C.CenterKey
	  , C.CenterDescription
	  , C.CenterDescriptionNumber
      , CLT.ExpectedConversionDate
      , CLT.ClientFullName
	  , DCM.ClientMembershipKey
      , DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
      , DCM.ClientMembershipEndDate AS 'MembershipEndDate'
	  , DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
      , DM.MembershipDescription
      , DM.BusinessSegmentSSID
      , DM.RevenueGroupSSID
      , DCM.ClientMembershipContractPrice AS 'ContractPrice'
      , DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
	  , ISNULL(FST.NB_BIOConvCnt,0) AS 'NB_BIOConvCnt'
	  , ISNULL(FST.NB_EXTConvCnt,0) AS 'NB_EXTConvCnt'
	  , ISNULL(FST.NB_XTRConvCnt,0) AS 'NB_XTRConvCnt'
	  ,	1 AS 'IsConverted'

FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON FST.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
	INNER JOIN #Centers C
		ON DCM.CenterKey = C.CenterKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND FST.NB_EXTConvCnt = 1
	AND DM.BusinessSegmentSSID = 2

END
ELSE
IF (@DrillDown = 2 AND @SaleType = 3)        --Conversion for XTR
BEGIN
INSERT INTO #Conv
SELECT  CLT.ClientIdentifier
      , CLT.ClientKey
      , C.MainGroupID
	  , C.MainGroup
      , DCM.CenterSSID
	  ,	C.CenterKey
	  , C.CenterDescription
	  , C.CenterDescriptionNumber
      , CLT.ExpectedConversionDate
      , CLT.ClientFullName
	, DCM.ClientMembershipKey
      , DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
      , DCM.ClientMembershipEndDate AS 'MembershipEndDate'
	  , DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
      , DM.MembershipDescription
      , DM.BusinessSegmentSSID
      , DM.RevenueGroupSSID
      , DCM.ClientMembershipContractPrice AS 'ContractPrice'
      , DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
	  , ISNULL(FST.NB_BIOConvCnt,0) AS 'NB_BIOConvCnt'
	  , ISNULL(FST.NB_EXTConvCnt,0) AS 'NB_EXTConvCnt'
	  , ISNULL(FST.NB_XTRConvCnt,0) AS 'NB_XTRConvCnt'
	  ,	1 AS 'IsConverted'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON FST.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
	INNER JOIN #Centers C
		ON DCM.CenterKey = C.CenterKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND FST.NB_XTRConvCnt = 1
	AND DM.BusinessSegmentSSID = 6

END


/**********ALL Not Converted with Expected Conversion Dates within the date range ***************/

IF (@DrillDown = 3 AND @SaleType = 1)										--XTR+
BEGIN

INSERT INTO #newstyle2
SELECT 	FST.ClientKey
,	FST.ClientMembershipKey
,	DD2.FullDate
,	ROW_NUMBER()OVER(PARTITION BY  FST.ClientKey ORDER BY DD2.FullDate DESC) AS 'Ranking'
FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2 ON FST.OrderDateKey = DD2.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON CLT.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
		INNER JOIN #Centers C
		ON DCM.CenterKey = C.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE DD2.FullDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today
	AND CLT.ClientKey = FST.ClientKey
    AND SC.SalesCodeDescriptionShort = 'NB1A'
	AND DM.RevenueGroupSSID = 1
	AND DM.BusinessSegmentSSID = 1
	AND DCM.ClientMembershipStatusDescription = 'Active'
	AND DM.MembershipSSID NOT IN(11,12,49,50,57)
GROUP BY FST.ClientKey,
         FST.ClientMembershipKey,
         DD2.FullDate


INSERT INTO #All
SELECT  C.CenterKey
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFullName
,	DATEADD(MONTH,DM.MembershipDurationMonths,NB1A2.FullDate) AS ExpectedConversionDate
,	DCM.ClientMembershipKey
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipEndDate
,	DCM.ClientMembershipStatusDescription
,	DM.MembershipDescription
,	DM.BusinessSegmentSSID
,	DM.RevenueGroupSSID
,	DCM.ClientMembershipContractPrice
,	DCM.ClientMembershipContractPaidAmount
FROM    #Centers C
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
	LEFT OUTER JOIN #newstyle2 NB1A2
		ON NB1A2.ClientMembershipKey = DCM.ClientMembershipKey AND (NB1A2.Ranking = 1 OR NB1A2.Ranking IS NULL )
WHERE   DATEADD(MONTH,DM.MembershipDurationMonths,NB1A2.FullDate) BETWEEN @StartDate AND @EndDate
AND DCM.ClientMembershipBeginDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today			--This reduces query time
AND DCM.ClientMembershipStatusDescription = 'Active'
AND DM.BusinessSegmentSSID = 1

END

ELSE
IF (@DrillDown = 3 AND @SaleType = 2)									--EXT
BEGIN
INSERT INTO #FirstService2
SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
,		DA.ClientKey
,		FST.ClientMembershipKey
,		DA.AppointmentDate
,		ISNULL(DD3.FullDate,'') AS 'FirstServiceDate'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD3
			ON FST.OrderDateKey = DD3.DateKey
		INNER JOIN #Centers
			ON #Centers.CenterKey = FST.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
			ON FST.ClientKey = DA.ClientKey
			AND DD3.Fulldate = DA.AppointmentDate
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DA.ClientMembershipKey = FST.ClientMembershipKey
		AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
		AND DD3.FullDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today		--This reduces query time

INSERT INTO #All
SELECT  C.CenterKey
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFullName
,	DATEADD(MONTH,DM.MembershipDurationMonths,FS2.FirstServiceDate) AS ExpectedConversionDate
,	DCM.ClientMembershipKey
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipEndDate
,	DCM.ClientMembershipStatusDescription
,	DM.MembershipDescription
,	DM.BusinessSegmentSSID
,	DM.RevenueGroupSSID
,	DCM.ClientMembershipContractPrice
,	DCM.ClientMembershipContractPaidAmount
FROM    #Centers C
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
		LEFT OUTER JOIN #FirstService2 FS2
			ON FS2.ClientMembershipKey = DCM.ClientMembershipKey AND (FS2.FSRank = 1 OR FS2.FSRank IS NULL)
WHERE   DATEADD(MONTH,DM.MembershipDurationMonths,FS2.FirstServiceDate) BETWEEN @StartDate AND @EndDate
	AND DM.BusinessSegmentSSID = 2
	AND DCM.ClientMembershipBeginDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today			--This reduces query time
	AND DCM.ClientMembershipStatusDescription = 'Active'
	AND DM.MembershipDescription LIKE 'EXT%'
GROUP BY DATEADD(MONTH,DM.MembershipDurationMonths,FS2.FirstServiceDate)
 ,   C.CenterKey
 ,   CLT.ClientKey
 ,   CLT.ClientIdentifier
 ,   CLT.ClientFullName
 ,   DCM.ClientMembershipKey
 ,   DCM.ClientMembershipBeginDate
 ,   DCM.ClientMembershipEndDate
 ,   DCM.ClientMembershipStatusDescription
 ,   DM.MembershipDescription
 ,   DM.BusinessSegmentSSID
 ,   DM.RevenueGroupSSID
 ,   DCM.ClientMembershipContractPrice
 ,   DCM.ClientMembershipContractPaidAmount
END



ELSE IF (@DrillDown = 3 AND @SaleType = 3)									--Xtrands
BEGIN
INSERT INTO #All
SELECT  C.CenterKey
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFullName
,	CLT.ExpectedConversionDate
,	DCM.ClientMembershipKey
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipEndDate
,	DCM.ClientMembershipStatusDescription
,	DM.MembershipDescription
,	DM.BusinessSegmentSSID
,	DM.RevenueGroupSSID
,	DCM.ClientMembershipContractPrice
,	DCM.ClientMembershipContractPaidAmount
FROM    #Centers C
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
WHERE   CLT.ExpectedConversionDate BETWEEN @StartDate AND @EndDate
AND DCM.ClientMembershipStatusDescription = 'Active'
AND DCM.ClientMembershipBeginDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today			--This reduces query time
AND DM.BusinessSegmentSSID = 6
END

/********* Those who have not converted ***************/
IF OBJECT_ID('tempdb..#NotConv') IS NOT NULL
BEGIN
	DROP TABLE #NotConv
END

SELECT  A.ClientIdentifier
      , A.ClientKey
	  , A.ClientMembershipKey
      , A.ExpectedConversionDate
	  , 0 AS 'IsConverted'
INTO    #NotConv
FROM    #All A
WHERE   A.ClientIdentifier NOT IN (SELECT   ClientIdentifier
                                   FROM     #Conv)
        AND (RevenueGroupSSID = 1)


/*********************INSERT INTO #Final **********************************************/

IF @DrillDown = 1  --NBSales
BEGIN
INSERT INTO #Final
	SELECT  C.MainGroupID
      , C.MainGroup
	  , C.MainGroupSortOrder
      , C.CenterSSID
      , C.CenterDescription
      , C.CenterDescriptionNumber
	  , NBS.ClientKey
      , NBS.ClientIdentifier
      , NBS.ClientFullName
      , NBS.MembershipDescription
      , NBS.MembershipBeginDate
	  , NBS.MembershipStatus
	  , NBS.ExpectedConversionDate
      , NBS.BusinessSegmentSSID
      , NBS.RevenueGroupSSID
      , NBS.ContractPrice
      , NBS.ContractPaidAmount
      , newstyle3.SalesCodeDescriptionShort
      , newstyle3.FullDate AS 'InitialNewStyleDate'
	  ,	NBS.IsConverted
	  , newstyle3.Ranking
	  , P.EmployeeInitials
	  , FirstService3.FirstServiceDate
	  , LastService.LastServiceDate
	  , NextService.NextServiceDate
	  , Visits.RemainingSalonVisits
	  , Kits.RemainingProductKits
	  ,	NBS.qty
FROM    #NBSales NBS
		INNER JOIN #Centers C
			ON NBS.CenterKey = C.CenterKey
        OUTER APPLY (SELECT SalesCodeDescriptionShort
                        ,	DD2.FullDate
						,	ROW_NUMBER()OVER(PARTITION BY  NBS.ClientKey ORDER BY DD2.FullDate DESC) AS 'Ranking'
                     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2 ON FST.OrderDateKey = DD2.DateKey
                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC ON FST.SalesCodeKey = SC.SalesCodeKey
                     WHERE  NBS.ClientKey = FST.ClientKey
                            AND SalesCodeDescriptionShort = 'NB1A'
                    ) newstyle3

		OUTER APPLY (SELECT TOP 1 E.EmployeeInitials
					   FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
								LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
									ON FST.Employee1Key = E.EmployeeKey
					   WHERE NBS.ClientKey = FST.ClientKey
								AND FST.SalesCodeKey = 467 -- 'INITASG'
					   ORDER BY E.EmployeeInitials
					) AS P (EmployeeInitials)

		OUTER APPLY (SELECT	(CMA_visits.TotalAccumQuantity-CMA_visits.UsedAccumQuantity) AS 'RemainingSalonVisits'
						FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_visits
						WHERE NBS.ClientMembershipKey = CMA_visits.ClientMembershipKey
									AND CMA_visits.AccumulatorSSID = 9 --Salon Visits
					) AS Visits
		OUTER APPLY (SELECT	(CMA_kits.TotalAccumQuantity-CMA_kits.UsedAccumQuantity) AS 'RemainingProductKits'
					FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_kits
					WHERE NBS.ClientMembershipKey = CMA_kits.ClientMembershipKey
									AND CMA_kits.AccumulatorSSID = 11 --Product Kits
					) AS Kits
		OUTER APPLY (SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
					,		ISNULL(DD3.FullDate,'') AS 'FirstServiceDate'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD3
								ON FST.OrderDateKey = DD3.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
								ON FST.ClientKey = DA.ClientKey
								AND DD3.Fulldate = DA.AppointmentDate
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON FST.Employee2Key = DE.EmployeeKey
					WHERE   NBS.ClientMembershipKey = FST.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND DD3.FullDate <= @Today
					) AS FirstService3
		OUTER APPLY (SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate DESC) LSRank
					,		CLT.ClientKey
					,       CLT.ClientIdentifier
					,		CLT.ClientFullName
					,		ISNULL(DD4.FullDate,'') AS 'LastServiceDate'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD4
								ON FST.OrderDateKey = DD4.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
								ON FST.ClientKey = DA.ClientKey
								AND DD4.Fulldate = DA.AppointmentDate
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FST.SalesCodeKey = DSC.SalesCodeKey
					WHERE   NBS.ClientMembershipKey = FST.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND DA.IsDeletedFlag = 0
							AND DA.AppointmentDate <= @Today
					) AS LastService
		OUTER APPLY (SELECT ISNULL(APPT.AppointmentDate,'') AS 'NextServiceDate'
						,	ROW_NUMBER() OVER(PARTITION BY APPT.ClientKey ORDER BY APPT.AppointmentDate ASC) NSRank
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
								ON FAD.AppointmentKey = APPT.AppointmentKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON APPT.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FAD.SalesCodeKey = DSC.SalesCodeKey
					WHERE   NBS.ClientMembershipKey = APPT.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND APPT.AppointmentDate > @Today
					) AS NextService

WHERE  NBS.IsConverted = -1
	AND (newstyle3.Ranking = 1 OR newstyle3.Ranking IS NULL)
	AND (FirstService3.FSRank = 1 OR FirstService3.FSRank IS NULL)
	AND (LastService.LSRank = 1 OR LastService.LSRank IS NULL)
	AND (NextService.NSRank = 1 OR NextService.NSRank IS NULL)
GROUP BY C.MainGroupID
      , C.MainGroup
	  , C.MainGroupSortOrder
      , C.CenterSSID
      , C.CenterDescription
      , C.CenterDescriptionNumber
	  , NBS.ClientKey
      , NBS.ClientIdentifier
      , NBS.ClientFullName
      , NBS.MembershipDescription
      , NBS.MembershipBeginDate
	  , NBS.MembershipStatus
	  , NBS.ExpectedConversionDate
      , NBS.BusinessSegmentSSID
      , NBS.RevenueGroupSSID
      , NBS.ContractPrice
      , NBS.ContractPaidAmount
       , newstyle3.SalesCodeDescriptionShort
       , newstyle3.FullDate
       , NBS.IsConverted
       , newstyle3.Ranking
       , P.EmployeeInitials
       , FirstService3.FirstServiceDate
       , LastService.LastServiceDate
       , NextService.NextServiceDate
	   , Visits.RemainingSalonVisits
	   , Kits.RemainingProductKits
	   ,	NBS.qty

END
ELSE IF @DrillDown = 2  --Converted
BEGIN
INSERT INTO #Final
SELECT  #Conv.MainGroupID
,	#Conv.MainGroup
,  C.MainGroupSortOrder
,	#Conv.CenterSSID
,	#Conv.CenterDescription
,	#Conv.CenterDescriptionNumber
,	#Conv.ClientKey
,	#Conv.ClientIdentifier
,	#Conv.ClientFullName
,	#Conv.MembershipDescription
,	#Conv.MembershipBeginDate
,	#Conv.MembershipStatus
,	#Conv.ExpectedConversionDate
,	#Conv.BusinessSegmentSSID
,	#Conv.RevenueGroupSSID
,	#Conv.ContractPrice
,	#Conv.ContractPaidAmount
,	newstyle4.SalesCodeDescriptionShort
,	newstyle4.FullDate AS 'InitialNewStyleDate'
,	#Conv.IsConverted
,	newstyle4.Ranking
,	P.EmployeeInitials
,	FirstService4.FirstServiceDate
,	LastService.LastServiceDate
,	NextService.NextServiceDate
,	Visits.RemainingSalonVisits
,	Kits.RemainingProductKits
,	1 AS qty
FROM  #Conv
		INNER JOIN #Centers C
			ON #Conv.CenterKey = C.CenterKey
        OUTER APPLY (SELECT SalesCodeDescriptionShort
                        ,	DD2.FullDate
						,	ROW_NUMBER()OVER(PARTITION BY #Conv.ClientKey ORDER BY DD2.FullDate DESC) AS 'Ranking'
                     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2 ON FST.OrderDateKey = DD2.DateKey
                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC ON FST.SalesCodeKey = SC.SalesCodeKey
                     WHERE  #Conv.ClientKey = FST.ClientKey
                            AND SalesCodeDescriptionShort = 'NB1A'
                    ) newstyle4
		OUTER APPLY (SELECT TOP 1 E.EmployeeInitials
				   FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
				   LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						ON FST.Employee1Key = E.EmployeeKey
				   WHERE #Conv.ClientKey = FST.ClientKey
						AND FST.SalesCodeKey = 467 -- 'INITASG'
				   ORDER BY E.EmployeeInitials
				  ) AS P (EmployeeInitials)

		OUTER APPLY (SELECT	(CMA_visits.TotalAccumQuantity-CMA_visits.UsedAccumQuantity) AS 'RemainingSalonVisits'
						FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_visits
						WHERE #Conv.ClientMembershipKey = CMA_visits.ClientMembershipKey
									AND CMA_visits.AccumulatorSSID = 9 --Salon Visits
					) AS Visits
		OUTER APPLY (SELECT	(CMA_kits.TotalAccumQuantity-CMA_kits.UsedAccumQuantity) AS 'RemainingProductKits'
					FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_kits
					WHERE #Conv.ClientMembershipKey = CMA_kits.ClientMembershipKey
									AND CMA_kits.AccumulatorSSID = 11 --Product Kits
					) AS Kits
		OUTER APPLY (SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
					,		ISNULL(DD3.FullDate,'') AS 'FirstServiceDate'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD3
								ON FST.OrderDateKey = DD3.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
								ON FST.ClientKey = DA.ClientKey
								AND DD3.Fulldate = DA.AppointmentDate
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON FST.Employee2Key = DE.EmployeeKey
					WHERE   #Conv.ClientMembershipKey = FST.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND DD3.FullDate <= @Today
					) AS FirstService4
		OUTER APPLY (SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate DESC) LSRank
					,		CLT.ClientKey
					,       CLT.ClientIdentifier
					,		CLT.ClientFullName
					,		ISNULL(DD4.FullDate,'') AS 'LastServiceDate'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD4
								ON FST.OrderDateKey = DD4.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
								ON FST.ClientKey = DA.ClientKey
								AND DD4.Fulldate = DA.AppointmentDate
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON FST.Employee2Key = DE.EmployeeKey
					WHERE   #Conv.ClientMembershipKey = FST.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND DA.IsDeletedFlag = 0
							AND DA.AppointmentDate <= @Today
					) AS LastService
		OUTER APPLY (SELECT  ISNULL(APPT.AppointmentDate,'') AS 'NextServiceDate'
						,	ROW_NUMBER() OVER(PARTITION BY APPT.ClientKey ORDER BY APPT.AppointmentDate ASC) NSRank
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
								ON FAD.AppointmentKey = APPT.AppointmentKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON APPT.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FAD.SalesCodeKey = DSC.SalesCodeKey
					WHERE   #Conv.ClientMembershipKey = APPT.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND APPT.AppointmentDate > @Today
					)AS NextService
WHERE   #Conv.IsConverted = 1
	AND (newstyle4.Ranking = 1 OR newstyle4.Ranking IS NULL)
	AND (FirstService4.FSRank = 1 OR FirstService4.FSRank IS NULL)
	AND (LastService.LSRank = 1 OR LastService.LSRank IS NULL)
	AND (NextService.NSRank = 1 OR NextService.NSRank IS NULL)
GROUP BY #Conv.MainGroupID
,	#Conv.MainGroup
,   C.MainGroupSortOrder
,	#Conv.CenterSSID
,	#Conv.CenterDescription
,	#Conv.CenterDescriptionNumber
,	#Conv.ClientKey
,	#Conv.ClientIdentifier
,	#Conv.ClientFullName
,	#Conv.MembershipDescription
,	#Conv.MembershipBeginDate
,	#Conv.MembershipStatus
,	#Conv.ExpectedConversionDate
,	#Conv.BusinessSegmentSSID
,	#Conv.RevenueGroupSSID
,	#Conv.ContractPrice
,	#Conv.ContractPaidAmount
,	newstyle4.SalesCodeDescriptionShort
,	newstyle4.FullDate
,	#Conv.IsConverted
,	newstyle4.Ranking
,	P.EmployeeInitials
,	FirstService4.FirstServiceDate
,	LastService.LastServiceDate
,	NextService.NextServiceDate
,	Visits.RemainingSalonVisits
,	Kits.RemainingProductKits
END
ELSE  --@DrillDown = 3  --Not Converted (Projected Conversions)
BEGIN
INSERT INTO #Final
SELECT  C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	A.ClientKey
,	A.ClientIdentifier
,	A.ClientFullName
,	A.MembershipDescription
,	A.ClientMembershipBeginDate	AS MembershipBeginDate
,	A.ClientMembershipStatusDescription	AS MembershipStatus
,	A.ExpectedConversionDate
,	A.BusinessSegmentSSID
,	A.RevenueGroupSSID
,	A.ClientMembershipContractPrice	AS ContractPrice
,	A.ClientMembershipContractPaidAmount AS ContractPaidAmount
,	newstyle5.SalesCodeDescriptionShort
,	newstyle5.FullDate AS 'InitialNewStyleDate'
,	#NotConv.IsConverted
,	newstyle5.Ranking
,	P.EmployeeInitials
,	FirstService5.FirstServiceDate
,	LastService.LastServiceDate
,	NextService.NextServiceDate
,	Visits.RemainingSalonVisits
,	Kits.RemainingProductKits
,	1 AS qty
FROM   #All A
INNER JOIN #NotConv ON #NotConv.ClientIdentifier = A.ClientIdentifier
		INNER JOIN #Centers C
			ON A.CenterKey = C.CenterKey
        OUTER APPLY (SELECT SalesCodeDescriptionShort
                        ,	DD2.FullDate
						,	ROW_NUMBER()OVER(PARTITION BY  A.ClientKey ORDER BY DD2.FullDate DESC) AS 'Ranking'
                     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2 ON FST.OrderDateKey = DD2.DateKey
                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC ON FST.SalesCodeKey = SC.SalesCodeKey
                     WHERE  A.ClientKey = FST.ClientKey
                            AND SalesCodeDescriptionShort = 'NB1A'
                    ) newstyle5
		OUTER APPLY (SELECT TOP 1 E.EmployeeInitials
				   FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
				   LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						ON FST.Employee1Key = E.EmployeeKey
				   WHERE A.ClientKey = FST.ClientKey
						AND FST.SalesCodeKey = 467 -- 'INITASG'
				   ORDER BY E.EmployeeInitials
				  ) AS P (EmployeeInitials)
		OUTER APPLY (SELECT	(CMA_visits.TotalAccumQuantity-CMA_visits.UsedAccumQuantity) AS 'RemainingSalonVisits'
						FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_visits
						WHERE A.ClientMembershipKey = CMA_visits.ClientMembershipKey
									AND CMA_visits.AccumulatorSSID = 9 --Salon Visits
					) AS Visits
		OUTER APPLY (SELECT	(CMA_kits.TotalAccumQuantity-CMA_kits.UsedAccumQuantity) AS 'RemainingProductKits'
					FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_kits
					WHERE A.ClientMembershipKey = CMA_kits.ClientMembershipKey
									AND CMA_kits.AccumulatorSSID = 11 --Product Kits
					) AS Kits
		OUTER APPLY (SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
					,		ISNULL(DD3.FullDate,'') AS 'FirstServiceDate'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD3
								ON FST.OrderDateKey = DD3.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
								ON FST.ClientKey = DA.ClientKey
								AND DD3.Fulldate = DA.AppointmentDate
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON FST.Employee2Key = DE.EmployeeKey
					WHERE   A.ClientMembershipKey = FST.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND DD3.FullDate <= @Today
					) AS FirstService5
		OUTER APPLY (SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate DESC) LSRank
					,		CLT.ClientKey
					,       CLT.ClientIdentifier
					,		CLT.ClientFullName
					,		ISNULL(DD4.FullDate,'') AS 'LastServiceDate'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD4
								ON FST.OrderDateKey = DD4.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
								ON FST.ClientKey = DA.ClientKey
								AND DD4.Fulldate = DA.AppointmentDate
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON FST.Employee2Key = DE.EmployeeKey
					WHERE   A.ClientMembershipKey = FST.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND DA.IsDeletedFlag = 0
							AND DA.AppointmentDate <= @Today
					) AS LastService
		OUTER APPLY (SELECT  ISNULL(APPT.AppointmentDate,'') AS 'NextServiceDate'
						,	ROW_NUMBER() OVER(PARTITION BY APPT.ClientKey ORDER BY APPT.AppointmentDate ASC) NSRank
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
								ON FAD.AppointmentKey = APPT.AppointmentKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON APPT.ClientKey = CLT.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
								ON FAD.SalesCodeKey = DSC.SalesCodeKey
					WHERE   A.ClientMembershipKey = APPT.ClientMembershipKey
							AND DSC.SalesCodeDepartmentSSID IN(5030,5031,5035,5036,5037,5038, 5040, 5050)
							AND APPT.AppointmentDate > @Today
					)AS NextService

WHERE  #NotConv.IsConverted = 0
	AND A.RevenueGroupSSID = 1
	AND ((newstyle5.Ranking = 1 OR newstyle5.Ranking IS NULL)
	AND (FirstService5.FSRank = 1 OR FirstService5.FSRank IS NULL)
	AND (LastService.LSRank = 1 OR LastService.LSRank IS NULL)
	AND (NextService.NSRank = 1 OR NextService.NSRank IS NULL))
GROUP BY C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	A.ClientKey
,	A.ClientIdentifier
,	A.ClientFullName
,	A.MembershipDescription
,	A.ClientMembershipBeginDate
,	A.ClientMembershipStatusDescription
,	A.ExpectedConversionDate
,	A.BusinessSegmentSSID
,	A.RevenueGroupSSID
,	A.ClientMembershipContractPrice
,	A.ClientMembershipContractPaidAmount
,	newstyle5.SalesCodeDescriptionShort
,	newstyle5.FullDate
,	#NotConv.IsConverted
,	newstyle5.Ranking
,	P.EmployeeInitials
,	FirstService5.FirstServiceDate
,	LastService.LastServiceDate
,	NextService.NextServiceDate
,	Visits.RemainingSalonVisits
,	Kits.RemainingProductKits


END

/****************** Final select statement *****************************************************************/

SELECT MainGroupID
     , MainGroup
	 , MainGroupSortOrder
     , CenterSSID
     , CenterDescription
     , CenterDescriptionNumber
     , ClientKey
     , ClientIdentifier
     , ClientFullName AS 'ClientName'
     , MembershipDescription AS 'Membership'
     , MembershipBeginDate
	 , MembershipStatus
     , ExpectedConversionDate
     , BusinessSegmentSSID
     , RevenueGroupSSID
     , ContractPrice
     , ContractPaidAmount
     , SalesCodeDescriptionShort
     , InitialNewStyleDate
     , IsConverted
     , Ranking
     , EmployeeInitials
     , FirstServiceDate
     , LastServiceDate
     , NextServiceDate
     , RemainingSalonVisits
     , RemainingProductKits
	 ,	qty
FROM #Final
WHERE BusinessSegmentSSID IN(SELECT CASE WHEN @SaleType = 1 THEN 1
									WHEN @SaleType = 2 THEN 2
									WHEN @SaleType = 3 THEN 6 END )
GROUP BY MainGroupID
       , MainGroup
	   , MainGroupSortOrder
       , CenterSSID
       , CenterDescription
       , CenterDescriptionNumber
       , ClientKey
       , ClientIdentifier
       , ClientFullName
       , MembershipDescription
       , MembershipBeginDate
	   , MembershipStatus
       , ExpectedConversionDate
       , BusinessSegmentSSID
       , RevenueGroupSSID
       , ContractPrice
       , ContractPaidAmount
       , SalesCodeDescriptionShort
       ,  InitialNewStyleDate
       , IsConverted
       , Ranking
       , EmployeeInitials
       , FirstServiceDate
       , LastServiceDate
       , NextServiceDate
       , RemainingSalonVisits
       , RemainingProductKits
	   ,	qty

END
