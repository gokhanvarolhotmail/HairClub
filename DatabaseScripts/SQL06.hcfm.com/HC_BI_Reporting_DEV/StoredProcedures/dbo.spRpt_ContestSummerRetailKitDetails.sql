/***********************************************************************
PROCEDURE:				[spRpt_ContestSummerRetailKitDetails]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HolidayPromo2014.rdl
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/24/2015
------------------------------------------------------------------------
NOTES:
@Filter = 1  By Region
@Filter = 2  By RTM
@Filter = 3  By Contest Group
------------------------------------------------------------------------
CHANGE HISTORY:
07/08/2015 - RH - Added a Detail report; Changed to Transaction Center
07/13/2015 - RH - Changed count of 1 to FST.Quantity to show when a client purchased more than 1 kit
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ContestSummerRetailKitDetails] 1, 14811
EXEC [spRpt_ContestSummerRetailKitDetails] 2, 3582
EXEC [spRpt_ContestSummerRetailKitDetails] 3, 14811

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestSummerRetailKitDetails] (
	@Filter INT
	,	@EmployeeKey INT
)

AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @ContestSSID INT


SET @StartDate = '7/1/2015' --Contest dates
SET @EndDate = '8/29/2015'


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'SummerRetailKit')


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
	,	Employee2Initials NVARCHAR(2)
	,	Employee2Key INT
	,	Employee2FullName NVARCHAR(150)
	,	SalesCodeSSID INT
	,	SalesCodeDescription NVARCHAR(150)
	,	PriceDefault MONEY
	,	RechargeKitCnt INT
	,	FunInSunKitCnt INT
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
ELSE IF @Filter = 2  --RegionalTechnicalManager
	 BEGIN
        INSERT  INTO #Centers
                SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
                      , ISNULL(DC.RegionTM, 'Unknown, Unknown') AS 'MainGroup'
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
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
                        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
                WHERE   CONVERT(VARCHAR ,DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
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


/********************************** Get Kit Sales Data *************************************/
INSERT INTO #Kits
SELECT  C.CenterSSID
,	DD.FullDate
,	CLT.ClientIdentifier
,   CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,	ISNULL(E2.EmployeeInitials,E.EmployeeInitials) AS 'Employee2Initials'
,	ISNULL(E2.EmployeeKey,E.EmployeeKey) AS 'Employee2Key'
,   ISNULL(E2.EmployeeFullName,E.EmployeeFullName) AS 'Employee2FullName'
,	DSC.SalesCodeSSID
,	CASE WHEN DSC.SalesCodeSSID = 841 THEN 'Recharge and Replenish Retail Kit' ELSE 'Fun in the Sun Retail Kit' END AS 'SalesCodeDescription'
,	FST.ExtendedPrice AS 'PriceDefault'
,	CASE WHEN DSC.SalesCodeSSID = 841 THEN FST.Quantity ELSE 0 END AS 'RechargeKitCnt'
,	CASE WHEN DSC.SalesCodeSSID = 842 THEN FST.Quantity ELSE 0 END AS 'FunInSunKitCnt'

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
        AND DSC.SalesCodeSSID IN (841, 842)
					/*	841 - Recharge and Replenish Retail Kit (Enter Items)
						842 - Fun in the Sun Retail Kit (Enter Items)*/
        AND SOD.IsVoidedFlag = 0
		AND DSC.SalesCodeSSID <> 0


SELECT * FROM #Kits
WHERE Employee2Key = @EmployeeKey




END
