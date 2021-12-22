/* CreateDate: 12/23/2013 14:21:37.110 , ModifyDate: 01/06/2017 09:29:40.040 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ClientCancellationsByMembership
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Cancellations Drill Down
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/23/2013
------------------------------------------------------------------------
NOTES:

12/23/2013 - DL - Rewrote stored procedure (#95426)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClientCancellationsByMembership '1/1/2014', '2/3/2014', 'C'
EXEC spRpt_ClientCancellationsByMembership '1/1/2014', '2/3/2014', 'F'
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_ClientCancellationsByMembership]
(
	@StartDate DATETIME,
	@EndDate DATETIME,
	@CenterType VARCHAR(50)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #CancelTransactions (
	Center INT
,	CenterName VARCHAR(255)
,	RegionID INT
,	Region VARCHAR(50)
,	Department INT
,	Code VARCHAR(50)
,	Membership VARCHAR(255)
,	TransactionNumber INT
,	MemberSortOrder INT
,	RevenueGroupDescriptionShort VARCHAR(50)
)


/********************************** Get list of centers *************************************/
IF @CenterType = 'C'
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


IF @CenterType LIKE '[2]%'
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
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) = @CenterType
						AND DC.Active = 'Y'
	END


IF @CenterType = 'F'
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


IF @CenterType LIKE '[78]%'
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
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) = @CenterType
						AND DC.Active = 'Y'
	END


-- Gather All Cancel Transactions into one table
INSERT  INTO #CancelTransactions
        SELECT  #Centers.CenterSSID AS 'Center'
        ,       #Centers.CenterDescription AS 'CenterName'
        ,       #Centers.MainGroupID AS 'RegionID'
        ,       #Centers.MainGroup AS 'Region'
        ,       DSC.SalesCodeDepartmentSSID AS 'Department'
        ,       DSC.SalesCodeDescriptionShort AS 'Code'
		,		DM.MembershipDescriptionShort AS 'Membership'
		,		CASE WHEN DSOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, DSOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, DSOD.TransactionNumber_Temp) END AS 'TransactionNumber'
        ,		DM.MembershipSortOrder AS 'MembershipSortOrder'
		,       DM.RevenueGroupDescriptionShort
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                    ON FST.SalesCodeKey = DSC.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                    ON FST.ClientMembershipKey = DCM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                    ON DCM.MembershipSSID = DM.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON DCM.CenterKey = DC.CenterKey
				INNER JOIN #Centers
                    ON DC.ReportingCenterSSID = #Centers.CenterSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
					ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
					ON DSOD.SalesOrderKey = DSO.SalesOrderKey
        WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND DSC.SalesCodeDepartmentSSID IN ( 1010, 1099 )


-- Seperate NB1Cancel's From CancelTransactions into its' own table
SELECT  CT.Center
,       CT.CenterName
,       COUNT(*) AS 'Cancel'
,       CT.Membership
,       CT.Region AS 'Region'
,       'NB1X' AS 'Action'
,       CT.TransactionNumber AS 'TransactNo'
,       CT.MemberSortOrder
FROM    #CancelTransactions CT
WHERE   CT.Department = 1099
        AND CT.RevenueGroupDescriptionShort = 'NB'
		AND CT.Code <> 'TXFROUT'
GROUP BY CT.Center
,       CT.Membership
,       CT.Region
,       CT.CenterName
,       CT.TransactionNumber
,       CT.MemberSortOrder
UNION
-- Seperate PCPCancel's From CancelTransactions into its' own table
SELECT  CT.Center
,       CT.CenterName
,       COUNT(*) AS 'Cancel'
,       CT.Membership
,       CT.Region AS 'Region'
,       'PCPX' AS 'Action'
,       CT.TransactionNumber AS 'TransactNo'
,       CT.MemberSortOrder
FROM    #CancelTransactions CT
WHERE   CT.Department = 1099
        AND CT.RevenueGroupDescriptionShort = 'PCP'
GROUP BY CT.Center
,       CT.Membership
,       CT.Region
,       CT.CenterName
,       CT.TransactionNumber
,       CT.MemberSortOrder
UNION
-- Seperate TXFROUT's From CancelTransactions into its' own table
SELECT  CT.Center
,       CT.CenterName
,       COUNT(*) AS 'Cancel'
,       CT.Membership
,       CT.Region AS 'Region'
,       'Transfer Out' AS 'Action'
,       CT.TransactionNumber AS 'TransactNo'
,       CT.MemberSortOrder
FROM    #CancelTransactions CT
WHERE   CT.Department = 1010
        AND CT.Code = 'TXFROUT'
GROUP BY CT.Center
,       CT.Membership
,       CT.Region
,       CT.CenterName
,       CT.TransactionNumber
,       CT.MemberSortOrder
ORDER BY CT.Region
,       CT.Center

END
GO
