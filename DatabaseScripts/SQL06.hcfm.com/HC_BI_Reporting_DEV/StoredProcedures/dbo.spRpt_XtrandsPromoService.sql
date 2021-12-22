/* CreateDate: 09/14/2015 14:11:08.323 , ModifyDate: 01/05/2017 11:28:05.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_XtrandsPromoService
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_XtrandsPromoService
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		09/14/2015
------------------------------------------------------------------------
NOTES:
This report shows the data from free xtrands services to current and former EXT members and ShowNoSale clients
for the purpose of showcasing Xtrands benefits and working towards upgrading/converting a client
to a membership that includes Xtrands benefits. Only show where the client has had an Xtrands Promo Service.
@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
11/24/2015 - RH - Changed stored procedure to run more quickly
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_XtrandsPromoService] '12/1/2015','12/31/2015','C', 1
EXEC [spRpt_XtrandsPromoService] '12/1/2015','12/31/2015','C', 2
EXEC [spRpt_XtrandsPromoService] '12/1/2015','12/31/2015','C', 3

EXEC [spRpt_XtrandsPromoService] '12/1/2015','12/31/2015','F', 1
EXEC [spRpt_XtrandsPromoService] '12/1/2015','12/31/2015','F', 2
EXEC [spRpt_XtrandsPromoService] '12/1/2015','12/31/2015','F', 3

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_XtrandsPromoService]
(
	@StartDate	DATETIME
	,	@EndDate DATETIME
	,	@sType NVARCHAR(1)
	,	@Filter INT

) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;


	/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterKey INT
,	EmployeeKey INT
,	EmployeeFullName VARCHAR(102)
)


CREATE TABLE #subPromo(ClientKey INT
,	ClientIdentifier INT
,	CenterKey INT
,	SalesCodeDescriptionShort NVARCHAR(50)
,	AppointmentDate DATETIME
,	ServiceMembership NVARCHAR(50)
,	Employee2FullName  NVARCHAR(102)
,	InvoiceNumber NVARCHAR(50)
)

/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 1  --By Regions
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS MainGroupID
				,		DR.RegionDescription AS MainGroup
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DC.CenterKey
				,		NULL AS EmployeeKey
				,		NULL AS EmployeeFullName
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
						AND DC.Active = 'Y'
	END

	IF @sType = 'C' AND @Filter = 2  --By Area Managers
	BEGIN
		INSERT  INTO #Centers
			SELECT  AM.CenterManagementAreaSSID AS MainGroupID
				,	AM.CenterManagementAreaDescription AS MainGroup
				,	AM.CenterSSID
				,	AM.CenterDescriptionNumber
				,	AM.CenterKey
				,	AM.EmployeeKey
				,	AM.EmployeeFullName
			FROM    dbo.vw_AreaManager AM
			WHERE	Active = 'Y'
	END
	IF @sType = 'C' AND @Filter = 3  -- By Centers
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterSSID AS MainGroupID
				,		DC.CenterDescriptionNumber AS MainGroup
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DC.CenterKey
				,		NULL AS EmployeeKey
				,		NULL AS EmployeeFullName
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


IF @sType = 'F'  --Always By Regions for Franchises
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS MainGroupID
				,		DR.RegionDescription AS MainGroup
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DC.CenterKey
				,		NULL AS EmployeeKey
				,		NULL AS EmployeeFullName
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END

--SELECT * FROM #Centers
/********************************** Get Total Number of Free Services *************************************/

INSERT INTO #subPromo
SELECT C.ClientKey
	,	C.ClientIdentifier
	,	DA.CenterKey
	,	DSC.SalesCodeDescriptionShort
	,	DA.AppointmentDate
	,	DM.MembershipDescription AS 'ServiceMembership'
	,	E.EmployeeFullName AS 'Employee2FullName'
	,	NULL AS InvoiceNumber
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
	INNER JOIN #Centers CTR
		ON DA.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient C
		ON DA.ClientKey = C.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
		ON DA.AppointmentKey = FAD.AppointmentKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
		ON FAD.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		ON FST.ClientKey = DA.ClientKey AND FST.CenterKey = DA.CenterKey AND FST.SalesCodeKey = FAD.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON FST.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		ON DCM.MembershipKey = DM.MembershipKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee2Key = E.EmployeeKey
WHERE   DA.AppointmentDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeDescriptionShort = 'XTRPROMOSV'
		AND DA.IsDeletedFlag = 0
GROUP BY C.ClientKey
       ,	C.ClientIdentifier
       ,	DA.CenterKey
       ,	DSC.SalesCodeDescriptionShort
       ,	DA.AppointmentDate
       ,	DM.MembershipDescription
	   ,	E.EmployeeFullName


UPDATE SP
SET SP.InvoiceNumber = DSO.InvoiceNumber
FROM #subPromo SP
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON CAST(SP.AppointmentDate AS VARCHAR(12)) = CAST(DSO.OrderDate AS VARCHAR(12))
	AND DSO.ClientKey = SP.ClientKey
	AND DSO.CenterKey = SP.CenterKey
WHERE DSO.IsVoidedFlag = 0


/************************Find SUM of Services ************************************/
SELECT  SP.ClientKey
,   SP.ClientIdentifier
,	SP.CenterKey
,	Details.CenterDescription
,	Details.ClientName
,	Details.MembershipBeginDate
,	Details.MembershipEndDate
,	Details.MembershipStatus
,	Details.Membership AS 'CurrentMembership'
,	COUNT(SP.ClientIdentifier) AS 'XtrPromoCount'
,	SP.Employee2FullName
INTO    #XTRPromoCount
FROM  #subPromo SP
LEFT JOIN #Centers CTR
	ON SP.CenterKey = CTR.CenterKey
CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientKey(ClientKey) Details
GROUP BY  SP.ClientKey
,   SP.ClientIdentifier
,	SP.CenterKey
,	Details.CenterDescription
,	Details.ClientName
,	Details.MembershipBeginDate
,	Details.MembershipEndDate
,	Details.Membership
,	Details.MembershipStatus
,	SP.Employee2FullName


/********************************** Final select statement **********************************************/

SELECT 	MainGroupID
	,	MainGroup
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	XTR.MembershipBeginDate
	,	XTR.MembershipEndDate
	,	SP.AppointmentDate
	,	XTR.CurrentMembership
	,	XTR.ClientIdentifier
	,	XTR.ClientName
	,	XTR.XtrPromoCount
	,	XTR.MembershipStatus
	,	CASE WHEN XTR.CurrentMembership LIKE 'Xtrands%Mem%' THEN 1 ELSE 0 END AS 'IsXtrandsCurrentMembership'
	,	XTR.Employee2FullName
	,	SP.InvoiceNumber
	,	SP.ServiceMembership
FROM #Centers C
INNER JOIN #XTRPromoCount XTR
	ON C.CenterKey = XTR.CenterKey
LEFT JOIN #subPromo SP
	ON XTR.ClientIdentifier = SP.ClientIdentifier
	AND C.CenterKey = SP.CenterKey
GROUP BY C.MainGroupID
	,	C.MainGroup
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	XTR.MembershipBeginDate
	,	XTR.MembershipEndDate
	,	SP.AppointmentDate
	,	XTR.CurrentMembership
	,	XTR.ClientIdentifier
	,	XTR.ClientName
	,	XTR.XtrPromoCount
	,	XTR.MembershipStatus
	,	XTR.Employee2FullName
	,	SP.InvoiceNumber
	,	SP.ServiceMembership

END
GO
