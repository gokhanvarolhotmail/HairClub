/* CreateDate: 03/28/2016 12:11:40.640 , ModifyDate: 04/01/2016 13:05:38.183 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_ContestSpringRetailKitDetails]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/24/2015
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ContestSpringRetailKitDetails] 2711, 295
EXEC [spRpt_ContestSpringRetailKitDetails] 3582, 204
EXEC [spRpt_ContestSpringRetailKitDetails] 14811, 212

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestSpringRetailKitDetails] (
	@EmployeeKey INT
	,	@CenterSSID INT
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

--CREATE TABLE #Centers (MainGroupID INT
--	,	MainGroup VARCHAR(50)
--	,	ContestReportGroupSSID INT
--	,	GroupDescription NVARCHAR(150)
--	,	CenterSSID INT
--	,	CenterDescriptionNumber VARCHAR(255)
--	,	TargetSales MONEY
--	,	CenterSortOrder INT
--	)

CREATE TABLE #Kits (CenterSSID INT
	,	FullDate DATETIME
	,	ClientIdentifier INT
	,   Client NVARCHAR(200)
	,	Employee2Initials NVARCHAR(2)
	,	Employee2Key INT
	,	Employee2FullName NVARCHAR(150)
	,	SalesOrderKey INT
	,	SalesCodeSSID INT
	,	SalesCodeDescription NVARCHAR(150)
	,	PriceDefault MONEY
	,	SpringVolumizingKit INT
	,	SpringCleanseAndRebuildKit INT
	,	SpringStylingKit INT
	)

/*SalesCodeSSID		SalesCodeDescription
	866				Spring Volumizing Kit
	867				Spring Cleanse & Rebuild Kit
	868				Spring Styling Kit
*/
/********************************** Get List of Centers and Target Data *************************************/
/*
IF @Filter = 3  --By Region
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
ELSE IF @Filter = 2  --Area Managers
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

                WHERE   CONVERT(VARCHAR ,DC.CenterSSID) LIKE '[2]%'
                        AND DC.Active = 'Y'
    END
*/

/********************************** Get Kit Sales Data *************************************/

/*SalesCodeSSID		SalesCodeDescription
	866				Spring Volumizing Kit
	867				Spring Cleanse & Rebuild Kit
	868				Spring Styling Kit
*/
INSERT INTO #Kits
SELECT  C.CenterSSID
,	DD.FullDate
,	CLT.ClientIdentifier
,   CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,	ISNULL(E2.EmployeeInitials,E.EmployeeInitials) AS 'Employee2Initials'
,	ISNULL(E2.EmployeeKey,E.EmployeeKey) AS 'Employee2Key'
,   ISNULL(E2.EmployeeFullName,E.EmployeeFullName) AS 'Employee2FullName'
,	SOD.SalesOrderKey
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
		AND C.CenterSSID = @CenterSSID
        AND DSC.SalesCodeSSID IN (866, 867, 868)
        AND SOD.IsVoidedFlag = 0
		AND DSC.SalesCodeSSID <> 0


SELECT * FROM #Kits
WHERE Employee2Key = @EmployeeKey




END
GO
