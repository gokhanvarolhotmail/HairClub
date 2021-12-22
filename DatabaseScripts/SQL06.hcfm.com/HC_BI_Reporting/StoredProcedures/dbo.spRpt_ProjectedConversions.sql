/* CreateDate: 08/12/2016 13:58:12.030 , ModifyDate: 03/26/2020 17:21:42.200 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ProjectedConversions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			ProjectedConversions.rdl
AUTHOR:	Rachelen Hut
DATE IMPLEMENTED:		08/12/2016
------------------------------------------------------------------------
NOTES: @ReportType is 1 for "By Franchise Regions" and 2 for "By Area Managers" and 3 for "By Centers"
	   @SaleType is 1 for "Xtrands Plus", 2 for "EXT" and 3 for "Xtrands"
------------------------------------------------------------------------
CHANGE HISTORY:
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
07/25/2018 - RH - (#150571) Add CenterNumber and MainGroupSortOrder
03/24/2020 - RH - (TrackIT 4831) Changed ExpectedConversionDate for XTR+ to 365 days passed NB1A and for EXT 365 days passed First Service

------------------------------------------------------------------------
EXEC spRpt_ProjectedConversions 3, 2, 2020, 1
EXEC spRpt_ProjectedConversions 3, 2, 2020, 2
EXEC spRpt_ProjectedConversions 3, 2, 2020, 3

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ProjectedConversions](
	@ReportType INT
,	@Month INT
,	@Year INT
,	@SaleType INT
)

AS
BEGIN

--Find the first day of the month and the last day based on @Month and @Year

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
DECLARE @Today DATETIME;

SELECT  @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/'+ CAST(@Year AS VARCHAR(4)) AS DATETIME);		--Beginning of the month
SELECT  @EndDate = DATEADD(DAY ,-1 ,DATEADD(MONTH ,1 ,@StartDate)) + '23:59:000';  							--End of the same month
SELECT @Today = GETDATE()

PRINT @StartDate;
PRINT @EndDate;
PRINT @Today;


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder NVARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
)


CREATE TABLE #ActualSales(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
,	FirstDateOfMonth DATETIME
,	NB_BIOCnt INT
,	NB_ExtCnt INT
,	NB_XtrCnt INT
)


CREATE TABLE #ActualConv(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
,	FirstDateOfMonth DATETIME
,	NB_BIOConvCnt INT
,	NB_ExtConvCnt INT
,	NB_XtrConvCnt INT
)


CREATE TABLE #Budget(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
,	FirstDateOfMonth DATETIME
,	NB_BIOCnt_Budget INT
,	NB_ExtCnt_Budget INT
,	NB_XtrCnt_Budget INT
,	NB_BIOConvCnt_Budget INT
,	NB_EXTConvCnt_Budget INT
,	NB_XTRConvCnt_Budget INT
)

CREATE TABLE #newstyle(
	ClientKey INT
,	ClientMembershipKey INT
,	Fulldate DATETIME
,	Ranking INT
)

CREATE TABLE #All (MainGroupID INT
	,	CenterKey INT
    ,	ClientIdentifier INT
	,	FullDate DATETIME
	)


CREATE TABLE #Final(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	MainGroupSortOrder  NVARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber VARCHAR(103)
,	FirstDateOfMonth DATETIME
,	NB_BIOCnt INT
,	NB_ExtCnt INT
,	NB_XtrCnt INT
,	NB_BIOConvCnt INT
,	NB_EXTConvCnt INT
,	NB_XTRConvCnt INT
,	NB_BIOCnt_Budget INT
,	NB_ExtCnt_Budget INT
,	NB_XtrCnt_Budget INT
,	NB_BIOConvCnt_Budget INT
,	NB_EXTConvCnt_Budget INT
,	NB_XTRConvCnt_Budget INT
,	Projected INT
)

/********************************** Get list of centers *************************************/
IF @ReportType = 1								--By Franchise Regions
BEGIN
		INSERT INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,	DR.RegionDescription AS 'MainGroup'
		,	CAST(DR.RegionSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
		,	DC.CenterKey
		,	DC.CenterNumber
		,	DC.CenterSSID
		,	DC.CenterDescription
		,	DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionKey = DR.RegionKey
		WHERE   DC.CenterSSID LIKE '[78]%'
				AND DC.Active = 'Y'
END
ELSE IF @ReportType = 2							--By Area Managers
BEGIN

		INSERT INTO #Centers
		SELECT DISTINCT
			CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,	CMA.CenterManagementAreaDescription AS 'MainGroup'
		,	CAST(CMA.CenterManagementAreaSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
		,	DC.CenterKey
		,	DC.CenterNumber
		,	DC.CenterSSID
		,	DC.CenterDescription
		,	DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
		WHERE DC.Active = 'Y'
		AND CMA.Active = 'Y'
		AND CenterDescription <> 'Hans Wiemann'
		AND CenterDescription <> 'IHI'
		AND CenterDescription <> 'London Hair Clinic'
		AND CenterDescription <> 'Virtual'

END
ELSE  --IF @ReportType = 3
BEGIN											--By Center
	INSERT INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupID'
		,	DC.CenterDescriptionNumber AS 'MainGroup'
		,	DC.CenterDescription AS 'MainGroupSortOrder'
		,	DC.CenterKey
		,	DC.CenterNumber
		,	DC.CenterSSID
		,	DC.CenterDescription
		,	DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   CT.CenterTypeDescriptionShort IN ('C','F','JV')
				AND DC.Active = 'Y'
				AND DC.CenterDescription <> 'Corporate'
				AND CenterDescription <> 'Hans Wiemann'
				AND CenterDescription <> 'IHI'
				AND CenterDescription <> 'London Hair Clinic'
				AND CenterDescription <> 'Virtual'
END

/********************* Select statement for Actual values - NB Sales ******************************************/

INSERT  INTO #ActualSales
SELECT  C.MainGroupID
	,	C.MainGroup
	,	C.CenterKey
	,	C.CenterNumber
	,	C.CenterSSID
	,   C.CenterDescription
	,	C.CenterDescriptionNumber
	,   DD.FirstDateOfMonth
	,   SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NB_BIOCnt'
	,   SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NB_ExtCnt'
	,   SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NB_XtrCnt'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON FST.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN #Centers C
		ON CM.CenterKey = C.CenterKey   --KEEP Home Center based
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND CM.ClientMembershipBeginDate BETWEEN @StartDate AND @EndDate
	AND SOD.IsVoidedFlag = 0
	AND (ISNULL(FST.NB_TradCnt,0) <> 0
		OR ISNULL(FST.NB_GradCnt,0) <> 0
		OR ISNULL(FST.NB_ExtCnt,0) <> 0
		OR ISNULL(FST.NB_XtrCnt,0) <> 0)
GROUP BY C.MainGroupID
    ,	C.MainGroup
    ,	C.CenterKey
	,	C.CenterNumber
    ,	C.CenterSSID
    ,	C.CenterDescription
	,	C.CenterDescriptionNumber
    ,	DD.FirstDateOfMonth


/********************* Select statement for Actual Conversions values  ******************************************/

INSERT  INTO #ActualConv
SELECT  C.MainGroupID
	,	C.MainGroup
	,	C.CenterKey
	,	C.CenterNumber
	,	C.CenterSSID
	,   C.CenterDescription
	,	C.CenterDescriptionNumber
	,   DD.FirstDateOfMonth
	,   SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'NB_BIOConvCnt'
	,   SUM(ISNULL(FST.NB_EXTConvCnt, 0)) AS 'NB_EXTConvCnt'
	,   SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'NB_XTRConvCnt'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN #Centers C
		ON FST.CenterKey = C.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND (ISNULL(FST.NB_BIOConvCnt,0) > 0
		OR ISNULL(FST.NB_EXTConvCnt,0) > 0
		OR ISNULL(FST.NB_XTRConvCnt,0) > 0)
GROUP BY C.MainGroupID
    ,	C.MainGroup
    ,	C.CenterKey
	,	C.CenterNumber
    ,	C.CenterSSID
    ,	C.CenterDescription
	,	C.CenterDescriptionNumber
    ,	DD.FirstDateOfMonth


/********************* Select statement for Budget values ******************************************/
INSERT INTO #Budget

SELECT C.MainGroupID
,	C.MainGroup
,	C.CenterKey
,	C.CenterNumber
,	C.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	DD.FirstDateOfMonth
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10230) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10230) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NB_BIOCnt_Budget'			--10230 - NB - Traditional & Gradual Sales #
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10215) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10215) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NB_ExtCnt_Budget'			--10215 - NB - Extreme Sales #
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10206) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10206) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NB_XtrCnt_Budget'			--10206 - NB - Xtrands Sales #
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NB_BIOConvCnt_Budget'		--10430 - PCP - BIO Conversion #
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NB_EXTConvCnt_Budget'		--10435 - PCP - EXTMEM Conversion #
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Budget ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NB_XTRConvCnt_Budget'		--10433 - PCP - Xtrands Conversion #
FROM HC_Accounting.dbo.FactAccounting FA
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FA.DateKey = DD.DateKey
INNER JOIN #Centers C
	ON FA.CenterID = C.CenterNumber  --Colorado Springs(238) is listed under CenterNumber in FactAccounting
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
GROUP BY C.MainGroupID
    ,	C.MainGroup
    ,	C.CenterKey
	,	C.CenterNumber
    ,	C.CenterSSID
    ,	C.CenterDescription
	,	C.CenterDescriptionNumber
    ,	DD.FirstDateOfMonth


/**********ALL Not Converted with Expected Conversion Dates within the date range ***************/


IF @SaleType = 1			--@SaleType is 1 for "Xtrands Plus"
BEGIN

INSERT INTO #newstyle
SELECT 	FST.ClientKey
,	FST.ClientMembershipKey
,	DD2.FullDate
,	ROW_NUMBER()OVER(PARTITION BY  FST.ClientKey ORDER BY DD2.FullDate DESC) AS 'Ranking'
FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2 ON FST.OrderDateKey = DD2.DateKey
	INNER JOIN #Centers ON #Centers.CenterKey = FST.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON CLT.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
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
SELECT  C.MainGroupID
	,	C.CenterKey
    ,	CLT.ClientIdentifier
	,	NB1A.FullDate
FROM    #Centers C
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
		INNER JOIN #newstyle NB1A
			ON NB1A.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
WHERE   DATEADD(MONTH,DM.MembershipDurationMonths,NB1A.FullDate) BETWEEN @StartDate AND @EndDate
AND DCM.ClientMembershipBeginDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today			--This reduces query time
AND DCM.ClientMembershipStatusDescription = 'Active'
AND DM.BusinessSegmentSSID = 1
AND (NB1A.Ranking = 1 OR NB1A.Ranking IS NULL )
END

ELSE
IF @SaleType = 2  --EXT
BEGIN
SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
,		DA.ClientKey
,		FST.ClientMembershipKey
,		DA.AppointmentDate
,		ISNULL(DD3.FullDate,'') AS 'FirstServiceDate'
INTO #FirstService
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
SELECT  C.MainGroupID
	,	C.CenterKey
    ,	CLT.ClientIdentifier
	,	NULL AS FullDate
FROM    #Centers C
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
		INNER JOIN #FirstService FS
			ON FS.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
WHERE   DATEADD(MONTH,DM.MembershipDurationMonths,FS.FirstServiceDate) BETWEEN @StartDate AND @EndDate
	AND DM.BusinessSegmentSSID = 2
	AND (FS.FSRank = 1 OR FS.FSRank IS NULL)
	AND DCM.ClientMembershipBeginDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today			--This reduces query time
	AND DCM.ClientMembershipStatusDescription = 'Active'
	AND DM.MembershipDescription LIKE 'EXT%'

END
ELSE										--Xtrands
BEGIN
INSERT INTO #All
SELECT  C.MainGroupID
	,	C.CenterKey
    ,	CLT.ClientIdentifier
	,	NULL AS FullDate
FROM    #Centers C
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON C.CenterSSID = CLT.CenterSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
WHERE  CLT.ExpectedConversionDate BETWEEN @StartDate AND @EndDate
	AND DCM.ClientMembershipStatusDescription = 'Active'
	AND DCM.ClientMembershipBeginDate BETWEEN DATEADD(YEAR,-2,@Today) AND @Today			--This reduces query time
	AND DM.RevenueGroupSSID = 1
	AND DM.BusinessSegmentSSID = 6
END


/********* Find those who have not converted *************************************************************/


SELECT A.MainGroupID
      , A.CenterKey
	  , COUNT(ClientIdentifier) AS 'Projected'
INTO    #NotConv
FROM    #All A
GROUP BY A.MainGroupID
       , A.CenterKey


/**************** Put values together ***************************************************************/
INSERT INTO #Final
SELECT C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterKey
,	C.CenterNumber
,	C.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	A.FirstDateOfMonth
,	A.NB_BIOCnt
,	A.NB_ExtCnt
,	A.NB_XtrCnt
,	Conv.NB_BIOConvCnt
,	Conv.NB_EXTConvCnt
,	Conv.NB_XTRConvCnt
,	B.NB_BIOCnt_Budget
,	B.NB_ExtCnt_Budget
,	B.NB_XtrCnt_Budget
,	B.NB_BIOConvCnt_Budget
,	B.NB_EXTConvCnt_Budget
,	B.NB_XTRConvCnt_Budget
,	NC.Projected
FROM #Centers C
LEFT OUTER JOIN #Budget B
	ON C.CenterKey = B.CenterKey
LEFT OUTER JOIN #ActualSales A
	ON C.CenterKey = A.CenterKey
LEFT OUTER JOIN #ActualConv Conv
	ON C.CenterKey = Conv.CenterKey
LEFT OUTER JOIN #NotConv NC
	ON C.CenterKey = NC.CenterKey
GROUP BY C.MainGroupID
,	C.MainGroup
,	C.MainGroupSortOrder
,	C.CenterKey
,	C.CenterNumber
,	C.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	A.FirstDateOfMonth
,	A.NB_BIOCnt
,	A.NB_ExtCnt
,	A.NB_XtrCnt
,	Conv.NB_BIOConvCnt
,	Conv.NB_ExtConvCnt
,	Conv.NB_XtrConvCnt
,	B.NB_BIOCnt_Budget
,	B.NB_ExtCnt_Budget
,	B.NB_XtrCnt_Budget
,	B.NB_BIOConvCnt_Budget
,	B.NB_EXTConvCnt_Budget
,	B.NB_XTRConvCnt_Budget
,	NC.Projected

/***************** Final select **************************************************/

SELECT MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CenterKey
,	CenterNumber
,	CenterSSID
,	CenterDescription
,	CenterDescriptionNumber
,	FirstDateOfMonth
,	SUM(ISNULL(NB_BIOCnt,0)) AS 'NB_BIOCnt'
,	SUM(ISNULL(NB_ExtCnt,0)) AS 'NB_ExtCnt'
,	SUM(ISNULL(NB_XtrCnt,0))  AS 'NB_XtrCnt'
,	SUM(ISNULL(NB_BIOConvCnt,0))  AS 'NB_BIOConvCnt'
,	SUM(ISNULL(NB_EXTConvCnt,0))  AS 'NB_EXTConvCnt'
,	SUM(ISNULL(NB_XTRConvCnt,0))  AS 'NB_XTRConvCnt'
,	SUM(ISNULL(NB_BIOCnt_Budget,0))  AS 'NB_BIOCnt_Budget'
,	SUM(ISNULL(NB_ExtCnt_Budget,0))  AS 'NB_ExtCnt_Budget'
,	SUM(ISNULL(NB_XtrCnt_Budget,0))  AS 'NB_XtrCnt_Budget'
,	SUM(ISNULL(NB_BIOConvCnt_Budget,0))  AS 'NB_BIOConvCnt_Budget'
,	SUM(ISNULL(NB_EXTConvCnt_Budget,0))  AS 'NB_EXTConvCnt_Budget'
,	SUM(ISNULL(NB_XTRConvCnt_Budget,0))  AS 'NB_XTRConvCnt_Budget'
,	SUM(ISNULL(Projected,0)) AS 'Projected'
FROM #Final
GROUP BY MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CenterKey
,	CenterNumber
,	CenterSSID
,	CenterDescription
,	CenterDescriptionNumber
,	FirstDateOfMonth

END
GO
