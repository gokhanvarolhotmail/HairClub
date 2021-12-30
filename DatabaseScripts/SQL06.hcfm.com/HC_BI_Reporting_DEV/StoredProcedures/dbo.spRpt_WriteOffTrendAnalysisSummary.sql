/* CreateDate: 12/05/2013 13:43:41.680 , ModifyDate: 12/05/2013 13:43:41.680 */
GO
/***********************************************************************
PROCEDURE:				spRpt_WriteOffTrendAnalysisSummary
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			WriteOff Trend Analysis Summary
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/05/2013
------------------------------------------------------------------------
NOTES:

12/05/2013 - DL - (#94709) Converted Stored Procedure
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_WriteOffTrendAnalysisSummary 2, '11/30/2013'
EXEC spRpt_WriteOffTrendAnalysisSummary 8, '11/30/2013'
***********************************************************************/
CREATE PROCEDURE spRpt_WriteOffTrendAnalysisSummary
(
	@Type INT,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @StartDate DATETIME


SET @StartDate = CONVERT(VARCHAR, MONTH(DATEADD(MONTH, -6, @EndDate))) + '/1/' + CONVERT(VARCHAR, YEAR(DATEADD(MONTH, -6, @EndDate)))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
  MainGroupID INT
, MainGroup VARCHAR(50)
, CenterSSID INT
, CenterDescription VARCHAR(255)
, CenterType VARCHAR(50)
)

CREATE TABLE #Transactions (
  RowID INT IDENTITY(1, 1)
, RegionID INT
, Region VARCHAR(50)
, CenterNumber INT
, Center VARCHAR(50)
, Month INT
, Amount MONEY
)

CREATE TABLE #WriteOffs (
  RowID INT IDENTITY(1, 1)
, Region VARCHAR(50)
, RegionID INT
, Center VARCHAR(50)
, CenterNumber INT
, Period1 MONEY
, Period2 MONEY
, Period3 MONEY
, Period4 MONEY
, Period5 MONEY
, Period6 MONEY
, Period7 MONEY
)


/********************************** Get list of centers *************************************/
IF @Type = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


IF @Type = 8
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


/********************************** Get Sales Data *************************************/
INSERT  INTO #Transactions
		SELECT	C.MainGroupID AS 'RegionID'
		,		C.MainGroup AS 'Region'
		,		C.CenterSSID AS 'CenterNumber'
		,		C.CenterDescription AS 'Center'
		,		MONTH(DD.FullDate) AS 'Month'
		,		SUM(FST.ExtendedPrice) AS 'Amount'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = DD.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
					ON FST.SalesCodeKey = DSC.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
					ON FST.ClientMembershipKey = DCM.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON DCM.CenterKey = DC.CenterKey
				INNER JOIN #Centers C
					ON DC.ReportingCenterSSID = C.CenterSSID
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND ( DSC.SalesCodeSSID IN ( 646, 694, 675, 685, 715, 708 )
						OR FST.SalesOrderTypeKey = 5 )
		GROUP BY C.MainGroupID
		,		C.MainGroup
		,		C.CenterSSID
		,		C.CenterDescription
		,		MONTH(DD.FullDate)


/********************************** Use a PIVOT table to format the data *************************************/
INSERT  INTO #WriteOffs
        SELECT  Region
        ,       RegionID
        ,       Center
        ,       CenterNumber
        ,       CASE MONTH(DATEADD(m, -6, @EndDate))
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period1'
        ,       CASE MONTH(DATEADD(m, -5, @EndDate))
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period2'
        ,       CASE MONTH(DATEADD(m, -4, @EndDate))
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period3'
        ,       CASE MONTH(DATEADD(m, -3, @EndDate))
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period4'
        ,       CASE MONTH(DATEADD(m, -2, @EndDate))
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period5'
        ,       CASE MONTH(DATEADD(m, -1, @EndDate))
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period6'
        ,       CASE MONTH(@EndDate)
                  WHEN 1 THEN [1]
                  WHEN 2 THEN [2]
                  WHEN 3 THEN [3]
                  WHEN 4 THEN [4]
                  WHEN 5 THEN [5]
                  WHEN 6 THEN [6]
                  WHEN 7 THEN [7]
                  WHEN 8 THEN [8]
                  WHEN 9 THEN [9]
                  WHEN 10 THEN [10]
                  WHEN 11 THEN [11]
                  WHEN 12 THEN [12]
                END AS 'Period7'
        FROM    ( SELECT	T.Region
                  ,         T.RegionID
                  ,         T.Center
                  ,         T.CenterNumber
                  ,         T.[Month]
                  ,         T.Amount
                  FROM      #Transactions T
                ) ps PIVOT ( SUM(Amount) FOR [Month] IN ( [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12] ) ) AS pvt


/********************************** Display Data *************************************/
	SELECT  W.Region
	,		W.RegionID
	,		W.Center
	,		W.CenterNumber
	,       ISNULL(W.Period1, 0) AS 'Period1'
	,       ISNULL(W.Period2, 0) AS 'Period2'
	,       ISNULL(W.Period3, 0) AS 'Period3'
	,       ISNULL(W.Period4, 0) AS 'Period4'
	,       ISNULL(W.Period5, 0) AS 'Period5'
	,       ISNULL(W.Period6, 0) AS 'Period6'
	,       ISNULL(W.Period7, 0) AS 'Period7'
	FROM    #WriteOffs W
	ORDER BY W.Region
	,		W.Center

END
GO
