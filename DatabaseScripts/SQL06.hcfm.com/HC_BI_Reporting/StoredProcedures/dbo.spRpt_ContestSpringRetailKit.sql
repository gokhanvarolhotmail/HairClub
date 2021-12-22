/* CreateDate: 03/28/2016 12:05:39.963 , ModifyDate: 04/01/2016 13:06:58.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_ContestSpringRetailKit]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HolidayPromo2014.rdl
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		03/28/2016
------------------------------------------------------------------------
NOTES:
@Filter = 3  By Region
@Filter = 2  By RTM
@Filter = 1  By Contest Group
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ContestSpringRetailKit] 1
EXEC [spRpt_ContestSpringRetailKit] 2
EXEC [spRpt_ContestSpringRetailKit] 3

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestSpringRetailKit] (
	@Filter INT
)

AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @ContestSSID INT


SET @StartDate = '4/12/2016' --Contest dates
SET @EndDate = '6/30/2016'


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'SpringRetailKit')


SET FMTONLY OFF;
SET NOCOUNT OFF;

CREATE TABLE #Centers (MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	ContestReportGroupSSID INT
	,	GroupDescription NVARCHAR(150)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	TargetSales MONEY
	,	CenterSortOrder INT
	)

CREATE TABLE #Kits (CenterSSID INT
	,	FullDate DATETIME
	,	ClientIdentifier INT
	,   Client NVARCHAR(200)
	,   Employee1Initials NVARCHAR(2)
	,	Employee2Initials NVARCHAR(2)
	,	Employee1Key INT
	,	Employee2Key INT
	,	Employee1FullName NVARCHAR(150)
	,	Employee2FullName NVARCHAR(150)
	,	SalesCodeSSID INT
	,	SalesCodeDescription NVARCHAR(150)
	,	PriceDefault MONEY
	,	SpringVolumizingKit INT
	,	SpringCleanseAndRebuildKit INT
	,	SpringStylingKit INT
	)


/********************************** Get List of Centers and Target Data *************************************/

IF @Filter = 3
    BEGIN
        INSERT  INTO #Centers
                SELECT  DR.RegionSSID AS 'MainGroupID'
                      , DR.RegionDescription AS 'MainGroup'
                      , CRG.ContestReportGroupSSID
                      , CRG.GroupDescription
                      , DC.CenterSSID
                      , DC.CenterDescriptionNumber
                      , CCT.TargetSales AS 'TargetSales'
                      , CCRG.CenterSortOrder
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN ContestCenterReportGroup CCRG ON DC.CenterSSID = CCRG.CenterSSID
                                                              AND CCRG.ContestSSID = @ContestSSID
                        INNER JOIN ContestReportGroup CRG ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
                                                             AND CRG.ContestSSID = @ContestSSID
                        INNER JOIN ContestCenterTarget CCT ON DC.CenterSSID = CCT.CenterSSID
                                                              AND CCT.ContestSSID = @ContestSSID
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR ON DC.RegionSSID = DR.RegionKey
                WHERE   CONVERT(VARCHAR ,DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
    END
ELSE IF @Filter = 2  --AreaManagers
	 BEGIN
        INSERT  INTO #Centers
                SELECT  ISNULL(AM.EmployeeKey, '-1') AS 'MainGroupID'
                      , ISNULL(AM.EmployeeFullName, 'Unknown, Unknown') AS 'MainGroup'
                      , CRG.ContestReportGroupSSID
                      , CRG.GroupDescription
                      , DC.CenterSSID
                      , DC.CenterDescriptionNumber
                      , FORMAT(CCT.TargetSales,'#,#') AS 'TargetSales'
                      , CCRG.CenterSortOrder
                FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
                        INNER JOIN ContestCenterReportGroup CCRG
							ON DC.CenterSSID = CCRG.CenterSSID
								AND CCRG.ContestSSID = @ContestSSID
                        INNER JOIN ContestReportGroup CRG
							ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
                                AND CRG.ContestSSID = @ContestSSID
                        INNER JOIN ContestCenterTarget CCT
							ON DC.CenterSSID = CCT.CenterSSID
                                AND CCT.ContestSSID = @ContestSSID
						INNER JOIN dbo.vw_AreaManager AM
							ON DC.CenterKey = AM.CenterKey
                WHERE   CONVERT(VARCHAR ,DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
    END
ELSE IF @Filter = 1  --Contest Groups
	 BEGIN
        INSERT  INTO #Centers
                SELECT  CRG.ContestReportGroupSSID AS 'MainGroupID'
                      , CRG.GroupDescription AS 'MainGroup'
                      , CRG.ContestReportGroupSSID
                      , CRG.GroupDescription
                      , DC.CenterSSID
                      , DC.CenterDescriptionNumber
                      , FORMAT(CCT.TargetSales,'#,#') AS 'TargetSales'
                      , CCRG.CenterSortOrder
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN ContestCenterReportGroup CCRG ON DC.CenterSSID = CCRG.CenterSSID
                                                              AND CCRG.ContestSSID = @ContestSSID
                        INNER JOIN ContestReportGroup CRG ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
                                                             AND CRG.ContestSSID = @ContestSSID
                        INNER JOIN ContestCenterTarget CCT ON DC.CenterSSID = CCT.CenterSSID
                                                              AND CCT.ContestSSID = @ContestSSID
                        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
                WHERE   CONVERT(VARCHAR ,DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
    END

--SELECT * FROM #Centers

/********************************** Get Kit Sales Data *************************************/
INSERT INTO #Kits
SELECT  C.CenterSSID
,	DD.FullDate
,	CLT.ClientIdentifier
,   CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,   E.EmployeeInitials AS 'Employee1Initials'
,	E2.EmployeeInitials AS 'Employee2Initials'
,	E.EmployeeKey AS 'Employee1Key'
,	E2.EmployeeKey AS 'Employee2Key'
,   E.EmployeeFullName AS 'Employee1FullName'
,   E2.EmployeeFullName AS 'Employee2FullName'
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
,	FST.ExtendedPrice AS 'PriceDefault'
,	CASE WHEN DSC.SalesCodeSSID = 866 THEN FST.Quantity ELSE 0 END AS 'SpringVolumizingKit'
,	CASE WHEN DSC.SalesCodeSSID = 867 THEN FST.Quantity ELSE 0 END AS 'SpringCleanseAndRebuildKit'
,	CASE WHEN DSC.SalesCodeSSID = 868 THEN FST.Quantity ELSE 0 END AS 'SpringStylingKit'

FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
			ON FST.Employee2Key = E2.EmployeeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            --ON CLT.CenterSSID= C.CenterSSID
			ON FST.CenterKey = C.CenterKey  --Transaction Center
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND C.CenterSSID IN(SELECT CenterSSID FROM #Centers)
        AND DSC.SalesCodeSSID IN (866, 867, 868)
        AND SOD.IsVoidedFlag = 0
		AND DSC.SalesCodeSSID <> 0

--SELECT * FROM #Kits

/********************************** Display By Main Group/Center *************************************/
SELECT  C.MainGroupID
	,	C.MainGroup
	,	C.ContestReportGroupSSID
	,	C.GroupDescription
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.CenterSortOrder
	,	ISNULL(K.Employee2Initials,K.Employee1Initials) AS 'Employee2Initials'
	,	ISNULL(K.Employee2Key,K.Employee1Key) AS 'Employee2Key'
	,	ISNULL(K.Employee2FullName,K.Employee1FullName) AS 'Employee2FullName'
	,	C.TargetSales
	,	SUM(ISNULL(K.PriceDefault,0)) AS 'PriceDefault'
	,	SUM(ISNULL(K.SpringVolumizingKit,0)) AS 'SpringVolumizingKit'
	,	SUM(ISNULL(K.SpringCleanseAndRebuildKit,0)) AS 'SpringCleanseAndRebuildKit'
	,	SUM(ISNULL(K.SpringStylingKit,0)) AS 'SpringStylingKit'
	FROM    #Centers C
			LEFT JOIN #Kits K
				ON C.CenterSSID = K.CenterSSID
	GROUP BY C.MainGroupID
	,	C.MainGroup
	,	C.ContestReportGroupSSID
	,	C.GroupDescription
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.CenterSortOrder
	,	ISNULL(K.Employee2Initials,K.Employee1Initials)
	,	ISNULL(K.Employee2Key,K.Employee1Key)
	,	ISNULL(K.Employee2FullName,K.Employee1FullName)
	,	C.TargetSales


END
GO
