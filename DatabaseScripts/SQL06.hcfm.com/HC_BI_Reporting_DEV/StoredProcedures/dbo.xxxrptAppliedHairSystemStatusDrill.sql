/* CreateDate: 11/13/2012 11:31:32.167 , ModifyDate: 05/26/2016 17:02:42.257 */
GO
/*===============================================================================================
-- Procedure Name:			rptAppliedHairSystemStatusDrill
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
EXEC rptAppliedHairSystemStatusDrill @CenterIds = '264',@StartDate = '2012-06-01',@EndDate = '2012-06-30', @IsStockInventoryFlag = 1
================================================================================================*/
CREATE PROCEDURE [dbo].[xxxrptAppliedHairSystemStatusDrill]
(
	 @CenterIds VARCHAR(MAX) = NULL
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@IsStockInventoryFlag BIT = 0
)
AS
BEGIN
	SET @EndDate = CONVERT(VARCHAR(10),@EndDate,120) + ' 23:59:59.999'

	-- Add All Centers to List
	IF @CenterIds IS NULL
		Select @CenterIds = COALESCE(@CenterIds  + ',' + CONVERT(nvarchar,CenterSSID),'')
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterSSID NOT IN (-2,100) -- IsCorporateHeadquartersFlag = 0
			AND CenterSSID = ReportingCenterSSID -- SurgeryHubCenterID IS NULL

	-- Add Corporate CenterIDs to List
	IF EXISTS(SELECT CenterNumber from SplitCenterIDs(@CenterIds) WHERE CenterNumber = 1)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds  + ',' + CONVERT(nvarchar,ReportingCenterSSID),'')
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterTypeSSID = 1 AND CenterSSID NOT IN (-2,100) -- IsCorporateHeadquartersFlag = 0
			AND CenterSSID = ReportingCenterSSID -- SurgeryHubCenterID IS NULL
		END

	-- Add Franchise CenterIDs to List
	IF EXISTS(SELECT CenterNumber from SplitCenterIDs(@CenterIds) WHERE CenterNumber = 2)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,ReportingCenterSSID),'')
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterTypeSSID = 2
			AND CenterSSID = ReportingCenterSSID
		END

	-- Add JointVenture CenterIDs to List
	IF EXISTS(SELECT CenterNumber from SplitCenterIDs(@CenterIds) WHERE CenterNumber = 3)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,ReportingCenterSSID),'')
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterTypeSSID = 3
			AND CenterSSID = ReportingCenterSSID
		END


DECLARE @CenterFilter TABLE (CenterID INT)
INSERT INTO @CenterFilter
SELECT DISTINCT CenterNumber FROM SplitCenterIDs(@CenterIds)

SELECT
	Region.RegionDescription AS 'Region'
	--Center Grouping
	,Center.ReportingCenterSSID CenterID
	,Center.CenterDescriptionNumber AS 'Center'

	--For Center Counts
	,CASE WHEN hair.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 1 ELSE 0 END AS 'Design'
	,CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MEA' THEN 1 ELSE 0 END AS 'MEA'
	,CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MAN' THEN 1 ELSE 0 END AS 'Manual'
	,CASE hair.HairSystemDescriptionShort WHEN 'NB1' THEN 1 ELSE 0 END AS 'Express'
	,CAST(hair.prh AS INT) AS 'Priority'

	--Data for Client Group
	,CAST(c.ClientIdentifier AS VARCHAR) + ' - ' + c.ClientFullName AS 'Client'
	,c.ClientIdentifier
	,mem.MembershipDescription AS 'MembershipDescriptionShort'
	,CASE
		WHEN hair.HairSystemDescriptionShort = 'NB1' AND hair.prh = 1 THEN hair.ApplicationType + ' (Express,Priority)'
		WHEN hair.HairSystemDescriptionShort = 'NB1' THEN hair.ApplicationType + ' (Express)'
		WHEN hair.prh = 1 THEN hair.ApplicationType + ' (Priority)'
		ELSE hair.ApplicationType
	END AS 'ApplicationType'
	--,Appl.HairSystemOrderTransactionDate AS 'ApplicationDate'
	,hair.AppliedDate AS 'ApplicationDate'
	,hair.HairSystemOrderNumber AS 'HairOrderNumber'

FROM HC_BI_ENT_DDS.bi_ent_dds.DimRegion Region
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter Center ON Center.RegionKey = Region.RegionKey
INNER JOIN @CenterFilter cFilter ON cFilter.CenterID = Center.CenterSSID
LEFT JOIN (
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
WHERE prh = @IsStockInventoryFlag


END
GO
