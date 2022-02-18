/* CreateDate: 08/16/2012 16:16:03.493 , ModifyDate: 05/20/2019 10:44:43.623 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ClientCancellationsByReason
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Cancellations By Reason
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/23/2013
------------------------------------------------------------------------
NOTES:
@CenterType = 'C' Corporate, 'F' Franchise
@Filter = 1 By Franchise Region, 2 By Area Manager,  3 By Center
@CancelType = 'NB' or 'PCP'
------------------------------------------------------------------------
CHANGE HISTORY:

12/23/2013 - DL - Rewrote stored procedure (#95426)
02/10/2014 - DL - Updated procedure to join on DimMembershipOrderReason table (#97253)
11/07/2016 - RH - Changed parameters to include "By Area Managers", "By Centers" and "By NB" or "By PCP" (#126190)
12/07/2016 - RH - Added Current Membership, Current Status and Total Inactive (#132709)
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
01/16/2018 - RH - Removed Regions for Corporate, Added @CenterType and @Filter to be consistent with the other reports (#145957)
05/20/2019 - JL - (Case 4824) Added drill down to report

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC spRpt_ClientCancellationsByReason 'F','12/1/2017', '1/15/2018', 1, 'PCP'
EXEC spRpt_ClientCancellationsByReason 'C','12/1/2017', '1/15/2018', 2, 'NB'
EXEC spRpt_ClientCancellationsByReason 'C','12/1/2017', '1/15/2018', 3, 'NB'
EXEC spRpt_ClientCancellationsByReason 'F','12/1/2017', '1/15/2018', 3, 'NB'

EXEC spRpt_ClientCancellationsByReason 'F','12/1/2017', '1/15/2018', 1, 'PCP'
EXEC spRpt_ClientCancellationsByReason 'C','05/1/2019', '5/10/2019', 2, 'PCP'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClientCancellationsByReason]
(	@CenterType NVARCHAR(1),
	@StartDate DATETIME,
	@EndDate DATETIME,
	@Filter INT,
	@CancelType VARCHAR(20)
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
,	CenterDescriptionNumber VARCHAR(50)
)


CREATE TABLE #Cancel (
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(104)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(150)
,	ClientMembershipKey INT
,   SalesCodeDepartmentSSID INT
,   SalesCodeDescriptionShort  NVARCHAR(50)
,	FullDate DATETIME
,	MembershipKey INT
,	MembershipDescription  NVARCHAR(50)
,	RevenueGroupDescriptionShort NVARCHAR(10)
,	CancelReasonID INT
,	CancelReason NVARCHAR(104)
,	CancelType NVARCHAR(3)
)


/********************************** Get list of centers *************************************/

/* 1 By Franchise Region, 2 By Area Manager, 3 By Center */

IF @Filter = 1 AND @CenterType = 'F'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END
ELSE
IF @Filter = 2 AND @CenterType = 'C'
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE DC.Active = 'Y'
						AND CMA.Active = 'Y'
						AND CT.CenterTypeDescriptionShort = 'C'
	END
ELSE
IF @Filter = 3 AND @CenterType = 'C'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterSSID AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
				WHERE   DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
	END
ELSE
IF @Filter = 3 AND @CenterType = 'F'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterSSID AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
				WHERE   DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('F','JV')
	END


/************ Gather All Cancel Transactions into one table ********************************************/
INSERT INTO #Cancel
SELECT  DISTINCT
		#Centers.MainGroupID
	,	#Centers.MainGroup
	,	DC.CenterSSID
	,	DC.CenterDescription
	,	DC.CenterDescriptionNumber
	,	CLT.ClientKey
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	FST.ClientMembershipKey
	,   DSC.SalesCodeDepartmentSSID
	,   DSC.SalesCodeDescriptionShort
	,	DD.FullDate
	,	DM.MembershipKey
	,	DM.MembershipDescription
	,	DM.RevenueGroupDescriptionShort
	,	ISNULL(DMOR.MembershipOrderReasonID, -1) AS 'CancelReasonID'
	,	ISNULL(DMOR.MembershipOrderReasonDescription, 'Unknown') AS 'CancelReason'
	,	@CancelType AS 'CancelType'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
    	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON FST.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers
            ON DC.CenterSSID = #Centers.CenterSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON DSOD.SalesOrderKey = DSO.SalesOrderKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
            ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND ( DSC.SalesCodeDepartmentSSID IN ( 1099 )
              OR ( DSC.SalesCodeDepartmentSSID IN ( 1010 )
                   AND DSC.SalesCodeDescriptionShort IN ( 'TXFROUT' ) ) )
		AND DM.RevenueGroupDescriptionShort = @CancelType					--KEEP to remove PCP
GROUP BY ISNULL(DMOR.MembershipOrderReasonID ,-1)
       , ISNULL(DMOR.MembershipOrderReasonDescription ,'Unknown')
       , MainGroupID
       , MainGroup
       , DC.CenterSSID
       , DC.CenterDescription
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
       , CLT.ClientIdentifier
       , CLT.ClientFullName
       , FST.ClientMembershipKey
       , DSC.SalesCodeDepartmentSSID
       , DSC.SalesCodeDescriptionShort
       , DD.FullDate
       , DM.MembershipKey
       , DM.MembershipDescription
       , DM.RevenueGroupDescriptionShort


/************ Find Clients with other active memberships/ Converted Clients ************************/

SELECT  DISTINCT
		#Cancel.CenterSSID
	,	#Cancel.ClientKey
	,	#Cancel.ClientIdentifier
	,	#Cancel.ClientFullName
	,	DCM.MembershipDescriptionShort AS 'CurrentMembership'
	,	DCM.MembershipStatus AS 'CurrentMembershipStatus'
	,	DCM.RevenueGroupSSID
INTO    #Converted
FROM    #Cancel
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(#Cancel.ClientIdentifier) DCM

/************ Combine the data from the two tables *******************************************/

SELECT DISTINCT
	   #Cancel.MainGroupID
     , #Cancel.MainGroup
     , #Cancel.CenterSSID
     , #Cancel.CenterDescription
     , #Cancel.CenterDescriptionNumber
     , #Cancel.CancelReasonID
     , #Cancel.CancelReason
     , #Cancel.CancelType
	, SUM(CASE WHEN #Converted.CurrentMembershipStatus <> 'Cancel' THEN 1 ELSE 0 END) AS 'ActiveClients'
	, SUM(CASE WHEN #Converted.CurrentMembershipStatus = 'Cancel' THEN 1 ELSE 0 END) AS 'InactiveClients'
	, COUNT(#Cancel.ClientIdentifier) AS 'Total'
FROM #Cancel
LEFT JOIN #Converted
ON #Cancel.ClientKey = #Converted.ClientKey
WHERE CancelType = @CancelType
GROUP BY MainGroupID
       , MainGroup
       , #Cancel.CenterSSID
       , CenterDescription
       , CenterDescriptionNumber
       , CancelReasonID
       , CancelReason
       , CancelType


 END
GO
