/* CreateDate: 04/15/2013 15:46:43.400 , ModifyDate: 11/20/2014 13:16:47.863 */
GO
/*==============================================================================
PROCEDURE:				spRpt_AttritionByGenderConversionDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Marlon Burrell
DATE IMPLEMENTED:		04/15/2013
==============================================================================
DESCRIPTION:	Attrition by Gender Conversion details
==============================================================================
NOTES:
07/24/2013	KRM	Modified to use FactSalesTransaction
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_AttritionByGenderConversionDetails 201, '4/1/13', '4/14/13', 'female'
==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_AttritionByGenderConversionDetails]
	@center int
,	@begdt DATETIME
,	@enddt DATETIME
,	@Gender varchar(10) = NULL
AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF


	CREATE TABLE #Centers (
		CenterSSID INT
	)


	/********************************** Get list of centers *************************************/
	IF @center LIKE '[2]%'
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
			WHERE c.CenterSSID = @center
				AND c.Active='Y'
		END
	ELSE IF @center LIKE '[78]%'
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
			WHERE c.CenterSSID = @center
				AND c.Active='Y'
		END
	ELSE IF @center IN (1, 2, 3, 4, 5, 6)
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
			WHERE c.RegionSSID = @center
				AND c.Active='Y'
		END


	SELECT ce.CenterSSID AS 'center'
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
	,	NULL AS 'CancelReasonID'
	,	NULL AS 'voided'
	,	NULL AS 'MembershipChange'
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
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON t.ClientMembershipKey = CM.ClientMembershipKey
	WHERE d.FullDate BETWEEN @begdt and @enddt
		AND (t.NB_BIOConvCnt <> 0 OR t.NB_XTRConvCnt <> 0)
		AND cl.ClientGenderDescription = (CASE WHEN @gender IS NULL THEN cl.ClientGenderDescription ELSE @gender END)
	ORDER BY ce.CenterSSID
	,	d.FullDate
	,	cl.ClientLastName
	,	cl.ClientFirstName

END
GO
