/* CreateDate: 02/01/2016 17:01:49.330 , ModifyDate: 01/09/2017 22:13:11.200 */
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
==============================================================================
SAMPLE EXECUTION
EXEC [spRpt_RetentionConversionDetails]  3, 1, '12/1/2016', '1/1/2017',1
EXEC [spRpt_RetentionConversionDetails]  9, 2, '12/1/2016', '1/1/2017',1
EXEC [spRpt_RetentionConversionDetails]  201, 1, '12/1/2016', '1/1/2017',1

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
		CenterSSID INT
		,	MainGroupID INT
		,	MainGroupDescription NVARCHAR(150)
	)

	/********************************** Get list of centers *************************************/



IF @Filter = 1						-- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	DR.RegionSSID AS 'MainGroupID'
				,	DR.RegionDescription AS 'MainGroupDescription'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE   DC.RegionSSID = @MainGroupID
				AND DC.Active = 'Y'
				AND CenterSSID LIKE '[278]%'
	END
ELSE
	IF @Filter = 2					--An Area Manager has been selected
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				AM.CenterSSID
				,	AM.CenterManagementAreaSSID AS 'MainGroupID'
				,	AM.CenterManagementAreaDescription AS 'MainGroupDescription'
		FROM   vw_AreaManager AM
		WHERE   AM.CenterManagementAreaSSID = @MainGroupID
				AND AM.Active = 'Y'
	END

ELSE IF @Filter = 3					-- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	CenterSSID AS 'MainGroupID'
				,	DC.CenterDescriptionNumber AS 'MainGroupDescription'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterSSID = @MainGroupID
				AND DC.Active = 'Y'
	END

	/****************************************************************************************/
IF @BusinessSegment = 1 --Xtrands Plus
BEGIN
	SELECT CTR.MainGroupID
	,	CTR.MainGroupDescription
	,	ce.CenterSSID AS 'center'
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
			ON CE.CenterSSID = CTR.CenterSSID
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
	,	ce.CenterSSID AS 'center'
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
			ON CE.CenterSSID = CTR.CenterSSID
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
	,	ce.CenterSSID AS 'center'
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
			ON CE.CenterSSID = CTR.CenterSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Performer
			ON t.Employee1Key = E_Performer.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Stylist
			ON t.Employee2Key = E_Stylist.EmployeeKey
WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
		AND t.NB_EXTConvCnt <> 0
END

END
GO
