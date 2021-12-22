/* CreateDate: 05/28/2013 13:59:40.860 , ModifyDate: 03/16/2020 17:18:12.633 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ClosingByConsultantDetailsNetSales
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Closing By Consultant Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		05/28/2013
------------------------------------------------------------------------
NOTES:
@CenterType = 1 for Corporate, 2 for Franchise

------------------------------------------------------------------------
CHANGE HISTORY:

12/13/2013 - DL - Excluded Chargeback Transactions from Sales Data
06/03/2014 - RH - Added ISNULL(NB_XtrCnt, 0) for Xtrands.
06/16/2015 - DL - Rewrote the query to match the NB Flash (#114151)
07/30/2015 - RH - Added ability to select a single center as @CenterType (#115654)
04/19/2016 - RH - Added Sales Mix per consultant (#122379); created a case statement for SalesCodeDescription to remove the (Trad) after 'Payment - Membership (Trad)'  because the report concatenates the membership to this description
04/24/2018 - RH - (#125957) Replaced Corporate Regions with Areas, changed CenterSSID to CenterNumber
07/05/2018 - RH - (#148614) Added Sort Order for Regions or Areas, changed CenterDescription to CenterDescriptionNumber
04/08/2019 - RH - (Case 8340) Added NB_MDPCnt and NB_MDPAmt; added back S_SurCnt; Removed EmployeeKey from Display Results
01/06/2020 - RH - Track IT #4257 Added ISNULL(FST.S_SurAmt, 0) back into NetNB1Sales
03/13/2020 - RH - TrackIT 7697 Added S_PRPCnt and S_PRPAmt to Surgery, NetNB1Count, NetNB1Sales
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClosingByConsultantDetailsNetSales 1, 0, 0,		'02/01/2020', '02/29/2020'
EXEC spRpt_ClosingByConsultantDetailsNetSales 1, 234, 0,	'02/01/2020', '02/29/2020'

EXEC spRpt_ClosingByConsultantDetailsNetSales 1, 22, 0,		'02/01/2020', '02/29/2020'
EXEC spRpt_ClosingByConsultantDetailsNetSales 2, 6, 0,		'02/01/2020', '02/29/2020'
EXEC spRpt_ClosingByConsultantDetailsNetSales 256, 256, 2822,	'02/01/2020', '02/29/2020'
EXEC spRpt_ClosingByConsultantDetailsNetSales 234, 234, 0,		'03/01/2020', '03/15/2020'
EXEC spRpt_ClosingByConsultantDetailsNetSales 1, 235, 16473,	'02/01/2020', '02/29/2020'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClosingByConsultantDetailsNetSales]
(
	@CenterType INT
,	@Center INT
,	@EmployeeID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #CenterEmployees (
	CenterNumber INT
,	EmployeeKey INT
,	EmployeeFullName VARCHAR(102)
)


/********************************** Get list of centers *************************************/
IF (@CenterType = 1 AND LEN(@Center) > 2)
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID
				,		CMA.CenterManagementAreaDescription
				,		CMA.CenterManagementAreaSortOrder
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				WHERE   DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
						AND (DC.CenterNumber = @Center OR @Center = 0)
	END
ELSE
IF (@CenterType = 2 AND LEN(@Center) > 2)
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DR.RegionSortOrder
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE   DCT.CenterTypeDescriptionShort IN ('F','JV')
						AND DC.Active = 'Y'
						AND (DC.CenterNumber = @Center OR @Center = 0)
	END

ELSE
IF (@CenterType = 1 AND @Center BETWEEN (-2) AND 25) -- An Area has been selected.
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID
				,		CMA.CenterManagementAreaDescription
				,		CMA.CenterManagementAreaSortOrder
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				WHERE   DCT.CenterTypeDescriptionShort IN ('C')
						AND DC.Active = 'Y'
						AND (CMA.CenterManagementAreaSSID = @Center OR @Center = 0)
	END
ELSE
IF (@CenterType = 2 AND @Center BETWEEN (-2) AND 15) -- A Region has been selected.
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DR.RegionSortOrder
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE   DCT.CenterTypeDescriptionShort IN ('F','JV')
						AND DC.Active = 'Y'
						AND (DR.RegionSSID = @Center OR @Center = 0)

	END
ELSE
IF (LEN(@CenterType) > 2)  --A center has been selected
BEGIN
	INSERT  INTO #Centers
			SELECT DC.CenterSSID AS 'MainGroupID'
			,		DC.CenterDescriptionNumber AS 'MainGroup'
			,		DC.CenterNumber AS 'MainGroupSortOrder'
			,		DC.CenterNumber
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
			WHERE DC.CenterNumber = @CenterType
					AND DCT.CenterTypeDescriptionShort IN ('C','F','JV')
						AND DC.Active = 'Y'
END

/********************************** Get list of employees *************************************/
INSERT  INTO #CenterEmployees
		SELECT  C.CenterNumber
		,       -1 AS 'EmployeeKey'
		,       'Unknown, Unknown' AS 'EmployeeFullName'
		FROM    #Centers C
		UNION
		SELECT  DEC.CenterID AS 'CenterNumber'
		,       E.EmployeeKey
		,       E.EmployeeFullName
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
				INNER JOIN SQL05.HairClubCMS.dbo.datEmployee DE
					ON DE.EmployeeGUID = E.EmployeeSSID
				INNER JOIN SQL05.HairClubCMS.dbo.datEmployeeCenter DEC  --Colorado Springs is 1020 as the CenterID in this table
					ON DEC.EmployeeGUID = DE.EmployeeGUID
				INNER JOIN #Centers C
					ON C.CenterSSID = DEC.CenterID


IF @EmployeeID <> 0
   BEGIN
         DELETE CE
         FROM   #CenterEmployees CE
         WHERE  CE.EmployeeKey <> @EmployeeID
   END


/********************************** Get sales data *************************************/
SELECT	DISTINCT
		CTR.MainGroupID AS 'RegionID'
,		CTR.MainGroup AS 'Region'
,		CTR.MainGroupSortOrder AS 'RegionSortOrder'
,		C.CenterNumber AS 'CenterID'
,		C.CenterDescriptionNumber AS 'Center'
,		ISNULL(DE.EmployeeKey, -1) AS 'EmployeeKey'
,		ISNULL(DE.EmployeeFullName, 'Unknown, Unknown') AS 'PerformerName'
,		DD.FullDate AS 'Date'
,		CLT.ClientIdentifier
,		CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientFullName'
,		M.MembershipDescription
,		SO.InvoiceNumber
,		SC.SalesCodeDescriptionShort
,		CASE WHEN SC.SalesCodeDescriptionShort IN ('MEMPMTTRD','MEMPMTGRD','MEMPMTEXT','MEMPMTXTRD')
			 THEN LEFT(SC.SalesCodeDescription,CHARINDEX('(',SC.SalesCodeDescription)-1)
			 ELSE SC.SalesCodeDescription END AS 'SalesCodeDescription'
,		CASE WHEN FST.S_SurCnt <> 0 THEN FST.S_SurCnt
			WHEN FST.S_PRPCnt <> 0 THEN FST.S_PRPCnt
		ELSE FST.Quantity END AS Quantity
,		CM.ClientMembershipContractPrice
,		ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XtrCnt, 0) + ISNULL(FST.NB_GradCnt, 0) + ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PostExtCnt, 0) + ISNULL(FST.NB_MDPCnt, 0) + ISNULL(FST.S_PRPCnt, 0) AS 'NetNB1Count'
,       ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_ExtAmt, 0) + ISNULL(FST.NB_XtrAmt, 0) + ISNULL(FST.NB_GradAmt, 0) + ISNULL(FST.S_PostExtAmt, 0) + ISNULL(FST.NB_MDPAmt, 0) + ISNULL(FST.NB_LaserAmt, 0) + ISNULL(FST.S_SurAmt, 0) + ISNULL(FST.S_PRPAmt, 0) AS 'NetNB1Sales'
,		ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0)  AS 'XTRPlus'
,		ISNULL(FST.NB_EXTCnt, 0)  AS 'EXT'
,		ISNULL(FST.NB_XTRCnt, 0)  AS 'Xtrands'
,		ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PRPCnt, 0)  AS 'Surgery'
,		ISNULL(FST.NB_MDPCnt, 0)  AS 'MDP'
INTO	#NetSales
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST    WITH (NOLOCK)
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD         WITH (NOLOCK)
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC  WITH (NOLOCK)
            ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO WITH (NOLOCK)
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD  WITH (NOLOCK)
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM   WITH (NOLOCK)
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m          WITH (NOLOCK)
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C              WITH (NOLOCK)
            ON cm.CenterKey = c.CenterKey
        INNER JOIN #Centers CTR                                      WITH (NOLOCK)
            --ON C.CenterNumber = #Centers.CenterNumber
			ON C.CenterSSID = CTR.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT            WITH (NOLOCK)
			ON FST.ClientKey = CLT.ClientKey
		LEFT JOIN #CenterEmployees DE                                WITH (NOLOCK)
			ON DE.EmployeeKey = FST.Employee1Key

WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 , 660, 661, 1703, 1704, 1705, 1706, 1707, 1708, 1709, 1710, 1711 )
		AND SOD.IsVoidedFlag = 0
		AND (de.employeekey = @EmployeeID OR @EmployeeID = 0 OR ISNULL(@EmployeeID, '')  = '' OR @EmployeeID = -1 )  --accomodate unknown employee

/********************************** Display Results *************************************/
SELECT  DISTINCT NS.RegionID
,       NS.Region
,		NS.RegionSortOrder
,       NS.CenterID
,       NS.Center
,       NS.PerformerName
,       NS.[Date]
,       NS.ClientIdentifier
,       NS.ClientFullName
,       NS.MembershipDescription
,       NS.InvoiceNumber
,       NS.SalesCodeDescriptionShort
,       NS.SalesCodeDescription
,       CASE WHEN NS.Quantity = 1 THEN 1 WHEN NS.Quantity = -1 THEN -1 ELSE 1 END Quantity1  --NS.Quantity
,       NS.Quantity
,       NS.ClientMembershipContractPrice
,       NS.NetNB1Count
,       NS.NetNB1Sales
,		NS.XTRPlus
,		NS.EXT
,		NS.Xtrands
,		NS.Surgery
,		NS.MDP
FROM    #NetSales NS
WHERE	( NS.NetNB1Count <> 0 OR NS.NetNB1Sales <> 0 )
GROUP BY NS.RegionID
       , NS.Region
	   , NS.RegionSortOrder
       , NS.CenterID
       , NS.Center
       , NS.PerformerName
       , NS.[Date]
       , NS.ClientIdentifier
       , NS.ClientFullName
       , NS.MembershipDescription
       , NS.InvoiceNumber
       , NS.SalesCodeDescriptionShort
       , NS.SalesCodeDescription
       , NS.Quantity
       , NS.ClientMembershipContractPrice
       , NS.NetNB1Count
       , NS.NetNB1Sales
       , NS.XTRPlus
       , NS.EXT
       , NS.Xtrands
       , NS.Surgery
	   , NS.MDP

END
GO
