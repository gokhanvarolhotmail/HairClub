/* CreateDate: 11/13/2012 12:31:27.820 , ModifyDate: 05/26/2016 17:02:59.397 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptAppliedHairSystemType
-- Procedure Description:
--
-- Created By:				HDu
-- Implemented By:			HDu
--
-- Date Created:			11/02/2011
-- Date Implemented:		11/02/2011
--
-- Destination Server:		SQL06
-- Destination Database:	Reporting
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
		* 07/11/2012 - HDu - Created new report stored proc
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC rptAppliedHairSystemType @CenterIds = '228',@StartDate = '2012-04-01',@EndDate = '2012-05-31'
================================================================================================*/
CREATE PROCEDURE [dbo].[xxxrptAppliedHairSystemType]
(
	 @CenterIds INT--VARCHAR(MAX)  -- 1,2,3,region number, centerId
	,@StartDate DATETIME
	,@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @EndDate = CONVERT(VARCHAR(10),@EndDate,120) + ' 23:59:59.999'


	DECLARE @CenterFilter TABLE ( CenterID INT )

	-- Add CenterIDs by Type to List
	IF (@CenterIds IN (1,2,3))--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 1)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterTypeSSID = @CenterIds AND CenterSSID NOT IN (-2,100) -- IsCorporateHeadquartersFlag = 0
			AND CenterSSID = ReportingCenterSSID -- SurgeryHubCenterID IS NULL
		END

	-- Add all centers for a region to List
	IF (@CenterIds < 100)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r ON r.RegionKey = c.RegionKey
			WHERE r.RegionNumber = @CenterIds
		END

	-- Add individual center to List
	IF (@CenterIds >= 100)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterSSID = @CenterIds
		END

SELECT
	--Region.RegionDescription AS 'Region'
	--Center Grouping

	--,Center.CenterDescriptionFullCalc AS 'Center'
	hair.HairSystemDescriptionShort
	--,Center.CenterID
	,COUNT(Center.CenterSSID) AS 'Applications'

FROM HC_BI_ENT_DDS.bi_ent_dds.DimRegion Region
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter Center ON Center.RegionKey = Region.RegionKey
INNER JOIN @CenterFilter cFilter ON cFilter.CenterID = Center.CenterSSID
INNER JOIN (
	SELECT
	 ce.CenterSSID
	,hso.ClientKey
	,hso.ClientHomeCenterKey ClientHomeCenterID
	,hso.HairSystemOrderDate
	,hso.HairSystemOrderSSID HairSystemOrderGUID
	,hso.HairSystemOrderNumber
	,hso.HairSystemAppliedDate AppliedDate
	,hso.HairSystemTypeKey HairSystemID
	,hso.HairSystemDesignTemplateKey HairSystemDesignTemplateID
	,hs.HairSystemTypeDescription HairSystemDescription
	,hs.HairSystemTypeDescriptionShort HairSystemDescriptionShort
	,dt.HairSystemDesignTemplateDescription
	,dt.HairSystemDesignTemplateDescriptionShort
	,hso.IsStockInventoryFlag AS prh
	,hso.ClientMembershipKey
	,CASE
		WHEN dt.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder hso
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = hso.CenterKey
		INNER JOIN @CenterFilter hFilter ON hFilter.CenterID = ce.CenterSSID
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemType HS ON HS.HairSystemTypeKey = hso.HairSystemTypeKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateKey = hso.HairSystemDesignTemplateKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus hsos ON hsos.HairSystemOrderStatusKey = hso.HairSystemOrderStatusKey
	WHERE hsos.HairSystemOrderStatusSSID = 2
	AND hso.HairSystemAppliedDate BETWEEN @StartDate AND @EndDate
) hair ON hair.CenterSSID = Center.CenterSSID
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient c ON c.ClientKey = hair.ClientKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm ON cm.ClientMembershipKey = hair.ClientMembershipKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem ON mem.MembershipKey = cm.MembershipKey
GROUP BY hair.HairSystemDescriptionShort

END
GO
