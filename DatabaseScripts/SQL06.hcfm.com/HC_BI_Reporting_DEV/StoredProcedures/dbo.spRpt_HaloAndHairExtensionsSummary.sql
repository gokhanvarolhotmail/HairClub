/* CreateDate: 07/20/2017 11:45:38.067 , ModifyDate: 01/22/2018 17:34:49.690 */
GO
/***********************************************************************
PROCEDURE:				spRpt_HaloAndHairExtensionsSummary
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HaloAndHairExtensionsSummary.rdl
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/20/2017
------------------------------------------------------------------------
NOTES: @Filter = 1 By Regions, 2 By Areas, 3 By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
01/22/2018 - RH - (#146611) Add Goals of 3 for Halo Sales and 3 for Hair Extensions
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_HaloAndHairExtensionsSummary] 'C', 2, '12/1/2017','1/31/2018'

EXEC [spRpt_HaloAndHairExtensionsSummary] 'C', 3, '12/1/2017','1/31/2018'

EXEC [spRpt_HaloAndHairExtensionsSummary] 'F', 1, '12/1/2017','1/31/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_HaloAndHairExtensionsSummary]
(
	@CenterType NVARCHAR(1)
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupSSID INT
,	MainGroup NVARCHAR(50)
,	MainGroupSortOrder INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(102)
,	CenterManagementAreaSortOrder INT
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(255)
)

CREATE TABLE #HaloAndExt(
	MainGroupSSID INT
,	MainGroupDescription NVARCHAR(255)
,	MainGroupSortOrder INT
,	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(255)
,	ClientKey INT
,   ClientIdentifier INT
,	Client NVARCHAR(255)
,   SalesOrderDetailKey INT
,   InvoiceNumber NVARCHAR(50)
,   FullDate DATETIME
,	SalesCodeSSID INT
,   SalesCodeDescriptionShort NVARCHAR(10)
,   SalesCodeDescription NVARCHAR(50)
,   Quantity INT
,   ExtendedPrice MONEY
,   Tax1 MONEY
,   Tax2 MONEY
,   Consultant NVARCHAR(2)
,   Stylist NVARCHAR(2)
,   MembershipDescription NVARCHAR(50)
,	ClientMembershipKey INT
,	ServiceDuration INT
,	HALO2LINES INT
,	HALO5LINES INT
,	HALOSVC INT
,	TAPEPACK INT
,	TAPESVC INT
)
/************ Set Sales Goals ***********************************************************/

DECLARE @HaloGoal INT
DECLARE @ExtensionsGoal INT

SET @HaloGoal = 3
SET @ExtensionsGoal = 3

/************ Get list of centers *******************************************************/

IF @CenterType = 'C' AND @Filter = 2  -- "By Areas"
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupSSID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroup'
		,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		CMA.CenterManagementAreaSSID
		,		CMA.CenterManagementAreaDescription
		,		CMA.CenterManagementAreaSortOrder
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON	DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE	CT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
				AND CMA.Active = 'Y'
END
ELSE
IF @CenterType = 'C' AND @Filter = 3  -- "By Centers"
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS 'MainGroupSSID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterSSID AS 'MainGroupSortOrder'
		,		CMA.CenterManagementAreaSSID
		,		CMA.CenterManagementAreaDescription
		,		CMA.CenterManagementAreaSortOrder
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON	DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE	CT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
				AND CMA.Active = 'Y'
END
ELSE
IF @CenterType = 'F'  --Always "By Regions" for Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupSSID'
		,		DR.RegionDescription AS 'MainGroup'
		,		DR.RegionSortOrder AS 'MainGroupSortOrder'
		,		NULL AS CenterManagementAreaSSID
		,		NULL AS CenterManagementAreaDescription
		,		NULL AS CenterManagementAreaSortOrder
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN ('F','JV')
				AND DC.Active = 'Y'
END



/************** Select statement ************************************************/

INSERT INTO #HaloAndExt
SELECT CTR.MainGroupSSID
,	CTR.MainGroup
,	CTR.MainGroupSortOrder
,	CTR.CenterSSID
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,	CLT.ClientKey
,   CLT.ClientIdentifier
,	CLT.ClientFullName + ' (' + CAST(CLT.ClientIdentifier AS NVARCHAR(10)) + ')' AS 'Client'
,   CASE WHEN SOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, sod.SalesOrderDetailKey)
		 ELSE CONVERT(VARCHAR, sod.TransactionNumber_Temp)
	END AS 'SalesOrderDetailKey'
,   CASE WHEN so.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
		 ELSE CONVERT(VARCHAR, so.TicketNumber_Temp)
	END AS 'InvoiceNumber'
,   DD.FullDate
,	SC.SalesCodeSSID
,   SC.SalesCodeDescriptionShort
,   SC.SalesCodeDescription
,   CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1 ELSE FST.Quantity END AS 'Quantity'
,   FST.ExtendedPrice
,   FST.Tax1
,   FST.Tax2
,   E.EmployeeInitials AS 'Consultant'
,   E2.EmployeeInitials AS 'Stylist'
,   M.MembershipDescription
,	DCM.ClientMembershipKey
,	SC.ServiceDuration
,	CASE WHEN SC.SalesCodeDescriptionShort = 'HALO2LINES' THEN 1 ELSE 0 END AS 'HALO2LINES'
,	CASE WHEN SC.SalesCodeDescriptionShort = 'HALO5LINES' THEN 1 ELSE 0 END AS 'HALO5LINES'
,	CASE WHEN SC.SalesCodeDescriptionShort = 'HALOSVC' THEN 1 ELSE 0 END AS 'HALOSVC'
,	CASE WHEN SC.SalesCodeDescriptionShort = 'TAPEPACK' THEN 1 ELSE 0 END AS 'TAPEPACK'
,	CASE WHEN SC.SalesCodeDescriptionShort = 'TAPESVC' THEN 1 ELSE 0 END AS 'TAPESVC'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
		ON FST.Employee2Key = E2.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON SO.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON DCM.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON DCM.CenterKey = C.CenterKey
	INNER JOIN #Centers CTR
		ON C.CenterSSID = CTR.CenterSSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	and (SC.SalesCodeDescriptionShort IN('HALO2LINES','HALO5LINES','TAPEPACK','TAPESVC','HALOSVC'))



/*********** Select SUM's for Summary **********************************************************/

SELECT MainGroupSSID
,	MainGroupDescription
,	MainGroupSortOrder
,	CenterSSID
,	CenterDescription
,	CenterDescriptionNumber
,	SUM(ISNULL(HALO2LINES,0)) as 'HALO2LINES'
,	SUM(ISNULL(HALO5LINES,0)) as 'HALO5LINES'
,	SUM(ISNULL(HALO2LINES,0)) + SUM(ISNULL(HALO5LINES,0)) AS 'HALOTOTAL'
,	@HaloGoal AS 'HaloGoal'
,	SUM(ISNULL(TAPEPACK,0)) as 'TAPEPACK'
,	@ExtensionsGoal AS 'ExtensionsGoal'
,	SUM(ISNULL(TAPESVC,0)) as 'TAPESVC'
,	SUM(ISNULL(HALOSVC,0)) as 'HALOSVC'
FROM #HaloAndExt
GROUP BY MainGroupSSID
,	MainGroupDescription
,	MainGroupSortOrder
,	CenterSSID
,	CenterDescription
,	CenterDescriptionNumber


END
GO
