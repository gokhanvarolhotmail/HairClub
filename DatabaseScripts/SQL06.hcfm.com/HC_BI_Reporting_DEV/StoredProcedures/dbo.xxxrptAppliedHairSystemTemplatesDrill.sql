/* CreateDate: 11/12/2012 14:03:43.987 , ModifyDate: 05/26/2016 17:02:53.357 */
GO
/*===============================================================================================
-- Procedure Name:			rptAppliedHairSystemTemplatesDrill
-- Procedure Description:
--
-- Created By:				HDu
-- Implemented By:			HDu
-- Last Modified By:		HDu
--
-- Date Created:			11/02/2011
-- Date Implemented:		11/02/2011
-- Date Last Modified:		11/02/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
		* 10/26/2011 - HDu - 5901 Created new report stored proc
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC rptAppliedHairSystemTemplatesDrill @CenterIds = '264',@MembershipIds = '',@StartDate = '2012-06-01',@EndDate = '2012-06-30',@VendorIds = ''

================================================================================================*/
CREATE PROCEDURE [dbo].[xxxrptAppliedHairSystemTemplatesDrill]
(
	 @CenterIds VARCHAR(MAX)
	,@MembershipIds VARCHAR(MAX) = NULL
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@VendorIds VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @EndDate = CONVERT(VARCHAR(10),@EndDate,120) + ' 23:59:59.999'

	--DECLARE @CorpCenterTypeID int
	--DECLARE @FranchiseCenterTypeID int
	--DECLARE @JointVentureCenterTypeID int

	--SELECT @CorpCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'C'
	--SELECT @FranchiseCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'F'
	--SELECT @JointVentureCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'JV'

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
--	,COUNT(hair.HairSystemOrderGUID) OVER(PARTITION BY Center.CenterID) AS 'Applications'
	--For Center Counts
	,CASE WHEN hair.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 1 ELSE 0 END AS 'Design'
	,CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MEA' THEN 1 ELSE 0 END AS 'MEA'
	,CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MAN' THEN 1 ELSE 0 END AS 'Manual'
	,CASE hair.HairSystemDescriptionShort WHEN 'NB1' THEN 1 ELSE 0 END AS 'Express'
	,CAST(hair.prh AS INT) AS 'Priority'

	--Data for Client Group
	,CAST(c.ClientIdentifier AS VARCHAR) + ' - ' +c.ClientFullName AS 'Client'
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
	--,prh.HairSystemOrderGUID as prh
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

--	FROM dbo.datHairSystemOrder hso
--	INNER JOIN @CenterFilter hFilter ON hFilter.CenterID = hso.CenterID
--	LEFT JOIN dbo.cfgHairSystem HS ON HS.HairSystemID = hso.HairSystemID
--	LEFT JOIN dbo.lkpHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
--	--Factory Filter Joins
--	LEFT JOIN dbo.datPurchaseOrderDetail POD ON POD.HairSystemOrderGUID = HSO.HairSystemOrderGUID
--		LEFT JOIN dbo.datPurchaseOrder PO ON PO.PurchaseOrderGUID = POD.PurchaseOrderGUID
--			INNER JOIN dbo.cfgVendor v ON v.VendorID = PO.VendorID AND VendorTypeID = 2
--	--LEFT JOIN (
--	--	SELECT HairSystemOrderGUID
--	--	FROM datHairSystemOrderTransaction t
--	--	WHERE t.NewHairSystemOrderStatusID = 6
--	--	GROUP BY HairSystemOrderGUID
--	--) prh ON prh.HairSystemOrderGUID = hso.HairSystemOrderGUID
--	WHERE HSO.HairSystemOrderStatusID = 2
--	AND AppliedDate BETWEEN @StartDate AND @EndDate
--) hair ON hair.CenterID = Center.CenterID
--LEFT JOIN dbo.datClient c ON c.ClientGUID = hair.ClientGUID
--LEFT JOIN dbo.datClientMembership cm ON cm.ClientMembershipGUID = hair.ClientMembershipGUID
--	LEFT JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID

END
GO
