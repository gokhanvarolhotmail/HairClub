/* CreateDate: 12/26/2013 10:24:14.377 , ModifyDate: 01/16/2018 16:49:39.637 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ClientCancellationsByType
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Cancellations
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/23/2013
------------------------------------------------------------------------
NOTES:
@CenterType = 1 By Corporate Region, 2 By Area Manager, 3 By Franchise Region, 4 By Center
@CancelType = 'NB' or 'PCP'
------------------------------------------------------------------------
CHANGE HISTORY:
12/23/2013 - DL - Converted Stored Procedure (#95426)
11/07/2016 - RH - Changed parameters to include "By Area Managers", "By Centers" and "By NB" or "By PCP" (#126190)
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
03/06/2017 - RH - Added AND DSC.SalesCodeDescription = 'Cancel Membership' to the #Cancels query
01/16/2018 - RH - Removed Regions for Corporate, Added @CenterType and @Filter to be consistent with the other reports (#145957)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClientCancellationsByType 'C','12/1/2017', '1/15/2018', 2, 'NB'
EXEC spRpt_ClientCancellationsByType 'C','12/1/2017', '1/15/2018', 3, 'PCP'

EXEC spRpt_ClientCancellationsByType 'F','12/1/2017', '1/15/2018', 1, 'NB'
EXEC spRpt_ClientCancellationsByType 'F','12/1/2017', '1/15/2018', 3, 'PCP'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClientCancellationsByType]
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

CREATE TABLE #CancelTransactions (
	MainGroupID INT
,   MainGroup NVARCHAR(50)
,	CenterSSID INT
,   CenterDescription NVARCHAR(50)
,   CenterDescriptionNumber NVARCHAR(50)
,   SalesCodeDepartmentSSID INT
,   SalesCodeDescriptionShort NVARCHAR(50)
,   RevenueGroupDescriptionShort NVARCHAR(50)
,	NBCancels INT
,	PCPCancels INT
,	TXFROUTCancels INT
,	ActiveClients INT
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


/******************** Gather All Cancel Transactions into one table *****************************************/

SELECT	DC.CenterSSID
	,	DC.CenterDescriptionNumber
	,	CLT.ClientKey
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	FST.ClientMembershipKey
	,	DR.RegionSSID
	,	DR.RegionDescription
	,   DSC.SalesCodeDepartmentSSID
	,   DSC.SalesCodeDescriptionShort
	,	DD.FullDate
	,	DM.MembershipKey
	,	DM.MembershipDescription
	,	DM.RevenueGroupDescriptionShort
INTO #Cancel
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
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionKey = DR.RegionKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND ( DSC.SalesCodeDepartmentSSID IN ( 1099 )
              OR ( DSC.SalesCodeDepartmentSSID IN ( 1010 )
                   AND DSC.SalesCodeDescriptionShort IN ( 'TXFROUT' ) ) )
		AND DSC.SalesCodeDescription = 'Cancel Membership'

/************ Find Clients with other active memberships/ Converted Clients ************************/


SELECT  #Cancel.CenterSSID
,		#Cancel.ClientKey
,		#Cancel.ClientIdentifier
,		#Cancel.ClientFullName
,		DCM.MembershipDescriptionShort
,		DCM.MembershipStatus
,		DCM.RevenueGroupSSID
INTO    #Converted
FROM    #Cancel
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(#Cancel.ClientIdentifier) DCM



/************* Combine the data into #CancelTransactions *********************************************/

INSERT  INTO #CancelTransactions
        SELECT  #Centers.MainGroupID
    ,   #Centers.MainGroup
	,	#Centers.CenterSSID
    ,   #Centers.CenterDescription
	,   #Centers.CenterDescriptionNumber
    ,   #Cancel.SalesCodeDepartmentSSID
    ,   #Cancel.SalesCodeDescriptionShort
    ,   #Cancel.RevenueGroupDescriptionShort
	,	SUM(CASE WHEN #Cancel.SalesCodeDepartmentSSID = 1099 AND #Cancel.RevenueGroupDescriptionShort = 'NB' AND #Cancel.SalesCodeDescriptionShort <> 'TXFROUT' THEN 1 ELSE 0 END) AS 'NBCancels'
	,	SUM(CASE WHEN #Cancel.SalesCodeDepartmentSSID = 1099 AND #Cancel.RevenueGroupDescriptionShort = 'PCP' AND #Cancel.SalesCodeDescriptionShort <> 'TXFROUT' THEN 1 ELSE 0 END) AS 'PCPCancels'
	,	SUM(CASE WHEN #Cancel.SalesCodeDepartmentSSID = 1010 AND #Cancel.SalesCodeDescriptionShort = 'TXFROUT' THEN 1 ELSE 0 END) AS 'TXFROUTCancels'
	,	SUM(CASE WHEN #Converted.MembershipStatus NOT IN('Cancel') THEN 1 ELSE 0 END) AS 'ActiveClients'
FROM    #Cancel
INNER JOIN #Centers ON #Cancel.CenterSSID = #Centers.CenterSSID
LEFT JOIN #Converted ON #Cancel.ClientIdentifier = #Converted.ClientIdentifier
GROUP BY MainGroupID
   ,	MainGroup
   ,	#Centers.CenterSSID
   ,	CenterDescription
   ,	#Centers.CenterDescriptionNumber
   ,	SalesCodeDepartmentSSID
   ,	SalesCodeDescriptionShort
   ,	RevenueGroupDescriptionShort



/************* Select according to the @CancelType for the report ************************************/

SELECT  CT.MainGroupID
,       CT.MainGroup
,		CT.CenterSSID
,       CT.CenterDescription
,		CT.CenterDescriptionNumber
,		CT.ActiveClients
,       CASE WHEN @CancelType = 'NB' THEN SUM(ISNULL(CT.NBCancels, 0)) ELSE SUM(ISNULL(CT.PCPCancels, 0)) END AS 'Cancels'
,		CASE WHEN @CancelType = 'NB' THEN SUM(ISNULL(CT.NBCancels, 0)-ISNULL(CT.ActiveClients, 0)) ELSE SUM(ISNULL(CT.PCPCancels, 0)-ISNULL(CT.ActiveClients, 0)) END AS 'Inactive'
,		@CancelType AS CancelType
FROM    #CancelTransactions CT
WHERE RevenueGroupDescriptionShort = @CancelType   --This is where NB or PCP is used
GROUP BY CT.MainGroupID
,       CT.MainGroup
,		CT.CenterSSID
,       CT.CenterDescription
,		CT.CenterDescriptionNumber
,		CT.ActiveClients






END
GO
