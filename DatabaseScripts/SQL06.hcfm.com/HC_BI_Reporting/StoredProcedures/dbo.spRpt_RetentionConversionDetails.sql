/* CreateDate: 02/01/2016 17:01:49.330 , ModifyDate: 01/23/2018 15:03:07.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
PROCEDURE:				spRpt_RetentionConversionDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		06/03/2015
==============================================================================
DESCRIPTION:
==============================================================================
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
@BusinessSegment = 1 Xtrands+, 2 = Xtrands, 3 = EXT
==============================================================================
CHANGE HISTORY:
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
01/23/2018 - RH - (#145957) Removed regions for Corporate; Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION
EXEC [spRpt_RetentionConversionDetails]  6, 1, '12/1/2017', '1/31/2018',1
EXEC [spRpt_RetentionConversionDetails]  9, 2, '12/1/2017', '1/31/2018',1
EXEC [spRpt_RetentionConversionDetails]  201, 3, '12/1/2017', '1/31/2018',1

==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_RetentionConversionDetails]
@MainGroupID INT
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@BusinessSegment INT

AS
BEGIN
--SET FMTONLY OFF
SET NOCOUNT OFF

DECLARE @PCPStartDate DATETIME
,	@PCPEndDate DATETIME
,	@ConversionEndDate DATETIME

SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate))) --Beginning of the month
,	@PCPEndDate =   CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate)))
,	@ConversionEndDate = DATEADD(MINUTE,-1,@PCPEndDate)


PRINT '@PCPStartDate = ' + CAST(@PCPStartDate AS VARCHAR(12))
PRINT '@PCPEndDate = ' + CAST(@PCPEndDate AS VARCHAR(12))
PRINT '@ConversionEndDate = ' +  CAST(@ConversionEndDate AS VARCHAR(12))


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
			MainGroupID INT
		,	MainGroupDescription NVARCHAR(150)
		,	CenterNumber INT
		,	CenterKey INT
		,	CenterDescription NVARCHAR(50)
		,	CenterDescriptionNumber NVARCHAR(103)
	)

/********************************** Get list of centers *************************************/


IF  @Filter = 2  --By Area Managers
BEGIN
	INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
			,	CMA.CenterManagementAreaDescription AS MainGroupDescription
			,	DC.CenterNumber
			,	DC.CenterKey
			,	DC.CenterDescription
			,	DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON	DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE	CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
					AND CMA.Active = 'Y'
					AND CMA.CenterManagementAreaSSID = @MainGroupID
END
ELSE
IF  @Filter = 3  -- By Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  DC.CenterNumber AS MainGroupID
			,		DC.CenterDescriptionNumber AS MainGroupDescription
			,		DC.CenterNumber
			,		DC.CenterKey
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   DC.CenterNumber = @MainGroupID
				AND DC.Active = 'Y'

END
ELSE
IF @Filter = 1
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS MainGroupID
			,		DR.RegionDescription AS MainGroupDescription
			,		DC.CenterNumber
			,		DC.CenterKey
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
					AND DR.RegionSSID = @MainGroupID
END

	/****************************************************************************************/
IF @BusinessSegment = 1 --Xtrands Plus
BEGIN
	SELECT CTR.MainGroupID
	,	CTR.MainGroupDescription
	,	ce.CenterNumber AS 'center'
	,	ce.CenterDescription AS 'center_name'
	,	ce.RegionSSID AS 'RegionID'
	,	r.RegionDescription AS 'Region'
	,	cl.ClientIdentifier AS 'Client_no'
	,	cl.ClientLastName AS 'Last_Name'
	,	cl.ClientFirstName AS 'First_Name'
	,	t.SalesOrderKey AS 'ticket_no'
	,	t.SalesOrderDetailKey AS 'transact_no'
	,	d.FullDate AS 'date'
	,	sc.SalesCodeDescriptionShort AS 'code'
	,	sc.SalesCodeDescription AS 'description'
	,	sc.SalesCodeDepartmentSSID AS 'department'
	,	t.Quantity AS 'qty'
	,	t.ExtendedPrice AS 'Price'
	,	t.Tax1 AS 'tax_1'
	,	t.Tax2 AS 'tax_2'
	,	E_Performer.EmployeeInitials AS 'Performer'
	,	E_Stylist.EmployeeInitials AS 'Stylist'
	,	@PCPStartDate AS 'PCPStartDate'
	,	@ConversionEndDate AS 'ConversionEndDate'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ce.CenterKey = t.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON cl.ClientKey = t.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = t.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeKey = t.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			ON ce.RegionSSID = r.RegionSSID
		INNER JOIN #Centers CTR
			ON CE.CenterNumber = CTR.CenterNumber
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Performer
			ON t.Employee1Key = E_Performer.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Stylist
			ON t.Employee2Key = E_Stylist.EmployeeKey
WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
		AND t.NB_BIOConvCnt <> 0

END
ELSE IF @BusinessSegment = 2 --Xtrands
BEGIN
SELECT CTR.MainGroupID
	,	CTR.MainGroupDescription
	,	ce.CenterNumber AS 'center'
	,	ce.CenterDescription AS 'center_name'
	,	ce.RegionSSID AS 'RegionID'
	,	r.RegionDescription AS 'Region'
	,	cl.ClientIdentifier AS 'Client_no'
	,	cl.ClientLastName AS 'Last_Name'
	,	cl.ClientFirstName AS 'First_Name'
	,	t.SalesOrderKey AS 'ticket_no'
	,	t.SalesOrderDetailKey AS 'transact_no'
	,	d.FullDate AS 'date'
	,	sc.SalesCodeDescriptionShort AS 'code'
	,	sc.SalesCodeDescription AS 'description'
	,	sc.SalesCodeDepartmentSSID AS 'department'
	,	t.Quantity AS 'qty'
	,	t.ExtendedPrice AS 'Price'
	,	t.Tax1 AS 'tax_1'
	,	t.Tax2 AS 'tax_2'
	,	E_Performer.EmployeeInitials AS 'Performer'
	,	E_Stylist.EmployeeInitials AS 'Stylist'
	,	@PCPStartDate AS 'PCPStartDate'
	,	@ConversionEndDate AS 'ConversionEndDate'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ce.CenterKey = t.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON cl.ClientKey = t.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = t.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeKey = t.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			ON ce.RegionSSID = r.RegionSSID
		INNER JOIN #Centers CTR
			ON CE.CenterNumber = CTR.CenterNumber
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Performer
			ON t.Employee1Key = E_Performer.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Stylist
			ON t.Employee2Key = E_Stylist.EmployeeKey
WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
		AND t.NB_XTRConvCnt <> 0

END
ELSE IF @BusinessSegment = 3 --EXT
BEGIN
SELECT CTR.MainGroupID
	,	CTR.MainGroupDescription
	,	ce.CenterNumber AS 'center'
	,	ce.CenterDescription AS 'center_name'
	,	ce.RegionSSID AS 'RegionID'
	,	r.RegionDescription AS 'Region'
	,	cl.ClientIdentifier AS 'Client_no'
	,	cl.ClientLastName AS 'Last_Name'
	,	cl.ClientFirstName AS 'First_Name'
	,	t.SalesOrderKey AS 'ticket_no'
	,	t.SalesOrderDetailKey AS 'transact_no'
	,	d.FullDate AS 'date'
	,	sc.SalesCodeDescriptionShort AS 'code'
	,	sc.SalesCodeDescription AS 'description'
	,	sc.SalesCodeDepartmentSSID AS 'department'
	,	t.Quantity AS 'qty'
	,	t.ExtendedPrice AS 'Price'
	,	t.Tax1 AS 'tax_1'
	,	t.Tax2 AS 'tax_2'
	,	E_Performer.EmployeeInitials AS 'Performer'
	,	E_Stylist.EmployeeInitials AS 'Stylist'
	,	@PCPStartDate AS 'PCPStartDate'
	,	@ConversionEndDate AS 'ConversionEndDate'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ce.CenterKey = t.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON cl.ClientKey = t.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = t.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeKey = t.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			ON ce.RegionSSID = r.RegionSSID
		INNER JOIN #Centers CTR
			ON CE.CenterNumber = CTR.CenterNumber
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Performer
			ON t.Employee1Key = E_Performer.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Stylist
			ON t.Employee2Key = E_Stylist.EmployeeKey
WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
		AND t.NB_EXTConvCnt <> 0
END

END
GO
