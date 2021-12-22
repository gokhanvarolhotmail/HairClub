/* CreateDate: 04/15/2013 14:51:14.457 , ModifyDate: 04/15/2013 15:46:09.887 */
GO
/*==============================================================================
PROCEDURE:				spRpt_AttritionByGenderDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Marlon Burrell
DATE IMPLEMENTED:		04/15/2013
==============================================================================
DESCRIPTION:	Attrition by Gender details
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_AttritionByGenderDetails 201, 3, 2013, NULL
==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_AttritionByGenderDetails]
	@center int
,	@month int
,	@year int
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


	--Get PCP Records
	SELECT C.CenterSSID AS 'CenterNum'
	,	C.CenterDescription AS 'Center'
	,	CLT.ClientIdentifier AS 'Client_No'
	,	CLT.ClientFirstName AS 'Firstname'
	,	CLT.ClientLastName AS 'Lastname'
	,	M.MembershipDescription AS 'Membership'
	,	NULL AS 'Membership_Alt'
	FROM HC_Accounting.dbo.FactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
		INNER JOIN #Centers CTR
			ON C.CenterSSID = CTR.CenterSSID
	WHERE MONTH(DD.FullDate) = @month
		AND YEAR(DD.FullDate) = @year
		AND PCPD.PCP = 1
		AND PCPD.EXT = 0
		AND CLT.ClientGenderDescription = (CASE WHEN @gender IS NULL THEN CLT.ClientGenderDescription ELSE @gender END)
	ORDER BY C.CenterSSID
	,	CLT.ClientIdentifier

END
GO
