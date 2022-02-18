/* CreateDate: 06/03/2015 16:42:26.493 , ModifyDate: 01/23/2018 14:36:28.750 */
GO
/*==============================================================================
PROCEDURE:				spRpt_RetentionByGenderConversionDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		06/03/2015
==============================================================================
DESCRIPTION:	Retention version based on Attrition by Gender Conversion Details
==============================================================================
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
07/02/2015 - RH - Changed to BIO conversions only
07/28/2015 - RH - Added @ConversionEndDate as the last day of the month for the month previous to the End Date (#116552)
10/14/2015 - RH - Changed @PCPStartDate to one month earlier for Conversions (#119399)
11/04/2015 - RH - Changed back the @PCPStartDate to the beginning of the @StartDate month (#120165)
01/04/2016 - RH - Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)(#120705)
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
01/23/2018 - RH - (#145957) Removed regions for Corporate; Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION
EXEC spRpt_RetentionByGenderConversionDetails  3, 2,'12/1/2017', '1/31/2018', 'Female'
EXEC spRpt_RetentionByGenderConversionDetails  9, 2, '12/1/2017', '1/31/2018', 'Female'
EXEC spRpt_RetentionByGenderConversionDetails  250, 3, '12/1/2017', '1/31/2018', NULL

==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_RetentionByGenderConversionDetails]
@MainGroupID INT
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Gender VARCHAR(10)
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


	SELECT CTR.MainGroupID
	,	CTR.MainGroupDescription
	,	ce.CenterNumber AS 'center'
	,	ce.CenterDescription AS 'center_name'
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
		INNER JOIN #Centers CTR
			ON CE.CenterNumber = CTR.CenterNumber
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Performer
			ON t.Employee1Key = E_Performer.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Stylist
			ON t.Employee2Key = E_Stylist.EmployeeKey
	WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
		AND (t.NB_BIOConvCnt <> 0)
		AND cl.ClientGenderDescription = (CASE WHEN @Gender IS NULL THEN cl.ClientGenderDescription
											WHEN @Gender = '0' THEN cl.ClientGenderDescription
											ELSE @Gender END)
	ORDER BY ce.CenterNumber
	,	d.FullDate
	,	cl.ClientLastName
	,	cl.ClientFirstName

END
GO
