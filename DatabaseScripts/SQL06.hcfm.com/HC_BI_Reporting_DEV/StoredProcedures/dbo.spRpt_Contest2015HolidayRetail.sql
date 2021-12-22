/* CreateDate: 10/15/2015 12:52:49.577 , ModifyDate: 11/13/2015 13:29:37.057 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_Contest2015HolidayRetail]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Contest2015HolidayRetail.rdl
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		10/15/2015
------------------------------------------------------------------------
NOTES:
@Filter = 1  By Region
@Filter = 2  By RTM
@Filter = 3  By Contest Group
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_Contest2015HolidayRetail] 1
EXEC [spRpt_Contest2015HolidayRetail] 2
EXEC [spRpt_Contest2015HolidayRetail] 3

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_Contest2015HolidayRetail] (
	@Filter INT
)

AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @ContestSSID INT

----For testing --SalesCodeSSID	SalesCodeDescription
----843	Trima Hair Care Kit
--SET @StartDate = '10/1/2015'


SET @StartDate = '11/1/2015' --Contest dates
SET @EndDate = '12/31/2015'


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = '2015HolidayRetail')


SET FMTONLY OFF;
SET NOCOUNT OFF;

CREATE TABLE #Centers (MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	ContestReportGroupSSID INT
	,	GroupDescription NVARCHAR(150)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	TargetSales INT
	,	CenterSortOrder INT
	)

CREATE TABLE #Kits (CenterSSID INT
	,	FullDate DATETIME
	,	ClientIdentifier INT
	,   Client NVARCHAR(200)
	--,   Employee1Initials NVARCHAR(2)
	--,	Employee2Initials NVARCHAR(2)
	--,	Employee1Key INT
	--,	Employee2Key INT
	--,	Employee1FullName NVARCHAR(150)
	--,	Employee2FullName NVARCHAR(150)
	,	SalesCodeSSID INT
	,	SalesCodeDescription NVARCHAR(150)
	,	KitCnt INT
	)


/********************************** Get List of Centers and Target Data *************************************/

IF @Filter = 1
    BEGIN
        INSERT  INTO #Centers
                SELECT  DR.RegionSSID AS 'MainGroupID'
                      , DR.RegionDescription AS 'MainGroup'
                      , CRG.ContestReportGroupSSID
                      , CRG.GroupDescription
                      , DC.CenterSSID
                      , DC.CenterDescriptionNumber
                      , CCT.TargetSales
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
						AND DC.CenterSSID <> 262  --Baton Rouge
    END
ELSE IF @Filter = 2  --RegionalTechnicalManager
	 BEGIN
        INSERT  INTO #Centers
                SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
                      , ISNULL(DC.RegionTM, 'Unknown, Unknown') AS 'MainGroup'
                      , CRG.ContestReportGroupSSID
                      , CRG.GroupDescription
                      , DC.CenterSSID
                      , DC.CenterDescriptionNumber
                      , CCT.TargetSales
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
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
                        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
                WHERE   CONVERT(VARCHAR ,DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
						AND DC.CenterSSID <> 262  --Baton Rouge
    END
ELSE IF @Filter = 3  --Contest Groups
	 BEGIN
        INSERT  INTO #Centers
                SELECT  CRG.ContestReportGroupSSID AS 'MainGroupID'
                      , CRG.GroupDescription AS 'MainGroup'
                      , CRG.ContestReportGroupSSID
                      , CRG.GroupDescription
                      , DC.CenterSSID
                      , DC.CenterDescriptionNumber
                      , CCT.TargetSales
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
						AND DC.CenterSSID <> 262  --Baton Rouge
    END


/********************************** Get Kit Sales Data *************************************/
INSERT INTO #Kits
SELECT  C.CenterSSID
,	DD.FullDate
,	CLT.ClientIdentifier
,   CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
--,   E.EmployeeInitials AS 'Employee1Initials'
--,	E2.EmployeeInitials AS 'Employee2Initials'
--,	E.EmployeeKey AS 'Employee1Key'
--,	E2.EmployeeKey AS 'Employee2Key'
--,   E.EmployeeFullName AS 'Employee1FullName'
--,   E2.EmployeeFullName AS 'Employee2FullName'
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
,	CASE WHEN DSC.SalesCodeSSID = 851 THEN FST.Quantity ELSE 0 END AS 'KitCnt'
--,	CASE WHEN DSC.SalesCodeSSID = 843 THEN FST.Quantity ELSE 0 END AS 'KitCnt'  --For testing

FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		--LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		--	ON FST.Employee1Key = E.EmployeeKey
		--LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
		--	ON FST.Employee2Key = E2.EmployeeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            --ON CLT.CenterSSID= C.CenterSSID
			ON FST.CenterKey = C.CenterKey  --Transaction Center
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND C.CenterSSID IN(SELECT CenterSSID FROM #Centers)
        AND DSC.SalesCodeSSID IN (851)
		--AND DSC.SalesCodeSSID IN (843) --For testing
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
	--,	ISNULL(K.Employee2Initials,K.Employee1Initials) AS 'Employee2Initials'
	--,	ISNULL(K.Employee2Key,K.Employee1Key) AS 'Employee2Key'
	--,	ISNULL(K.Employee2FullName,K.Employee1FullName) AS 'Employee2FullName'
	,	K.SalesCodeSSID
	,	K.SalesCodeDescription
	,	C.TargetSales
	,	SUM(ISNULL(KitCnt,0)) AS 'KitCnt'
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
	--,	ISNULL(K.Employee2Initials,K.Employee1Initials)
	--,	ISNULL(K.Employee2Key,K.Employee1Key)
	--,	ISNULL(K.Employee2FullName,K.Employee1FullName)
	,	K.SalesCodeSSID
	,	K.SalesCodeDescription
	,	C.TargetSales


END
GO
