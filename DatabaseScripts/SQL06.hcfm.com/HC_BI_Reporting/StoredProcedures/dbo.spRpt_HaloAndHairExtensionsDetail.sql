/* CreateDate: 07/20/2017 12:10:40.437 , ModifyDate: 03/12/2018 14:30:09.530 */
GO
/***********************************************************************
PROCEDURE:				spRpt_HaloAndHairExtensionsDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HaloAndHairExtensionsDetail.rdl
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/20/2017
------------------------------------------------------------------------
NOTES:
@Filter = 0 for All, 1 By Regions, 2 By Areas, 3 By Centers
@SalesCode = 1 For Halo Products
	2 For Extension Pack Qty
	3 For Extension Service
	4 For Halo Service
------------------------------------------------------------------------
CHANGE HISTORY:
01/02/2018 - RH - (#144243) Added @Filter = 0 for All to show totals
01/25/2018 - RH - (#146611) Removed Corporate Regions
03/12/2018 - RH - (#145957) Added CenterType for #Centers
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_HaloAndHairExtensionsDetail] 'C', 3, '10/1/2017','01/02/2018', 212, 1

EXEC [spRpt_HaloAndHairExtensionsDetail] 'C', 2, '10/1/2017','01/02/2018', 4, 4

EXEC [spRpt_HaloAndHairExtensionsDetail] 'C', 0, '10/1/2017','01/02/2018', 0, 1
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_HaloAndHairExtensionsDetail]
(
	@CenterType NVARCHAR(1)
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@MainGroupSSID INT
,	@SalesCode INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

--DROP TABLE #Centers  DROP TABLE #HaloAndExt
/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupSSID INT
,	MainGroupDescription NVARCHAR(102)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(255)
)

CREATE TABLE #SalesCode(
	SalesCodeSSID INT
,	SalesCodeShortDescription NVARCHAR(50)
)

CREATE TABLE #HaloAndExt(
	MainGroupSSID INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
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
)


/********************************** Get list of centers *************************************/
IF @CenterType = 'C'  AND @Filter = 0						--@Filter = 0 for "All Corporate"
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupSSID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		DC.CenterNumber
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
IF @CenterType = 'C'  AND @Filter = 2						--@Filter = 2 "By Area"
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupSSID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON	DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CMA.CenterManagementAreaSSID = @MainGroupSSID
				AND CT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
END
ELSE
IF @CenterType = 'C'  AND @Filter = 3						--@Filter = 3 "By Center"
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupSSID'
		,		DC.CenterDescriptionNumber AS 'MainGroupDescription'
		,		DC.CenterNumber AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON DC.CenterTypeKey = CT.CenterTypeKey
		WHERE	DC.CenterNumber = @MainGroupSSID
				AND CT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
END
ELSE
IF @CenterType = 'F' AND @Filter = 0								--"All Franchises"
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupSSID'
		,		DR.RegionDescription AS 'MainGroupDescription'
		,		DR.RegionSortOrder AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
				AND DC.Active = 'Y'
END
ELSE
IF @CenterType = 'F' AND @Filter = 1								--"By Region"
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupSSID'
		,		DR.RegionDescription AS 'MainGroupDescription'
		,		DR.RegionSortOrder AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
				AND DC.Active = 'Y'
				AND DC.RegionSSID = @MainGroupSSID
END
ELSE
BEGIN																--"By Center"
	INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupSSID'
		,		DR.RegionDescription AS 'MainGroupDescription'
		,		DR.RegionSortOrder AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
				AND DC.Active = 'Y'
				AND DC.CenterNumber = @MainGroupSSID
END

/*********** Find SalesCodeSSIDs and Descriptions ********************************/

IF @SalesCode = 1						--For Halo Products
BEGIN
INSERT INTO #SalesCode
SELECT SalesCodeSSID
,	SalesCodeDescriptionShort
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE SalesCodeSSID IN(924,925)
END
ELSE
IF @SalesCode = 2						--For Extension Pack Qty
BEGIN
INSERT INTO #SalesCode
SELECT SalesCodeSSID
,	SalesCodeDescriptionShort
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE SalesCodeSSID = 926
END
ELSE
IF @SalesCode = 3						--For Extension Service
BEGIN
INSERT INTO #SalesCode
SELECT SalesCodeSSID
,	SalesCodeDescriptionShort
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE SalesCodeSSID = 927
END
ELSE
IF @SalesCode = 4						--For Halo Service
BEGIN
INSERT INTO #SalesCode
SELECT SalesCodeSSID
,	SalesCodeDescriptionShort
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE SalesCodeSSID = 928
END

--SELECT * FROM #SalesCode

/************** Select statement ************************************************/


SELECT CTR.MainGroupSSID
,	CTR.MainGroupDescription
,	CTR.MainGroupSortOrder
,	CTR.CenterNumber
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
		ON C.CenterNumber = CTR.CenterNumber
	INNER JOIN #SalesCode TMP
		ON SOD.SalesCodeSSID = TMP.SalesCodeSSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND SOD.IsVoidedFlag = 0
	AND SC.SalesCodeSSID IN (SELECT SC.SalesCodeSSID FROM #SalesCode)



END
GO
