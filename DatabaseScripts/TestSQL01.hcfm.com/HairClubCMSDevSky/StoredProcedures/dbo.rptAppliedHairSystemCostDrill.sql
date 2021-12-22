/* CreateDate: 10/09/2012 09:03:13.417 , ModifyDate: 11/29/2018 13:49:05.963 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptAppliedHairSystemCostDrill
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
		* 10/09/2012 - HDu - 5901 Created new report stored proc
		* 09/10/2013 - MB - Removed SurgeryHubCenter condition
		* 10/04/2017 - RH - Added IsActiveFlag = 1 for Center query
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC rptAppliedHairSystemCostDrill '4', NULL,'10/1/2017', '12/31/2017', NULL
================================================================================================*/
CREATE PROCEDURE [dbo].[rptAppliedHairSystemCostDrill]
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

	DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int
	DECLARE @HWCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'JV'
	SELECT @HWCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'HW'

	-- Add Corporate CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 1)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds  + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
			AND IsActiveFlag = 1
		END

	-- Add Franchise CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 2)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @FranchiseCenterTypeID
			AND IsActiveFlag = 1
		END

	-- Add JointVenture CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = 6
			AND IsActiveFlag = 1
		END

	-- Add Hans Wiemann CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 4)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @HWCenterTypeID
			AND IsActiveFlag = 1
		END

DECLARE @CenterFilter TABLE (
	CenterID INT
)
INSERT INTO @CenterFilter
SELECT item FROM fnSplit(@CenterIds,',')

SELECT
	Region.RegionDescription AS 'Region'
	--Center Grouping
	,Center.CenterID
	,Center.CenterDescriptionFullCalc AS 'Center'
--	,COUNT(hair.HairSystemOrderGUID) OVER(PARTITION BY Center.CenterID) AS 'Applications'
	--For Center Counts
	,CASE WHEN hair.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 1 ELSE 0 END AS 'Design'
	,CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MEA' THEN 1 ELSE 0 END AS 'MEA'
	,CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MAN' THEN 1 ELSE 0 END AS 'Manual'
	,CASE hair.HairSystemDescriptionShort WHEN 'NB1' THEN 1 ELSE 0 END AS 'Express'
	,CAST(hair.prh AS INT) AS 'Priority'

	--Data for Client Group
	,CAST(c.ClientIdentifier AS VARCHAR) + ' - ' +c.ClientFullNameAlt2Calc AS 'Client'
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

	,hair.HairSystemVendorContractID
	,hair.ContractName
	,hair.CostFactoryShipped AS 'CostFactoryShipped'

	,hair.HairSystemCenterContractID
	,hair.CenterPrice

FROM dbo.lkpRegion Region
INNER JOIN dbo.cfgCenter Center ON Center.RegionID = Region.RegionID
INNER JOIN @CenterFilter cFilter ON cFilter.CenterID = Center.CenterID
LEFT JOIN (
	SELECT
	 hso.CenterID
	,hso.ClientGUID
	,hso.ClientHomeCenterID
	,hso.HairSystemOrderDate
	,hso.HairSystemOrderGUID
	,hso.HairSystemOrderNumber
	,hso.AppliedDate
	,hso.HairSystemID
	,hso.HairSystemDesignTemplateID
	,hs.HairSystemDescription
	,hs.HairSystemDescriptionShort
	,dt.HairSystemDesignTemplateDescription
	,dt.HairSystemDesignTemplateDescriptionShort
	,hso.IsStockInventoryFlag AS prh
	,hso.ClientMembershipGUID
	--,prh.HairSystemOrderGUID as prh
	,CASE
		WHEN dt.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
	,hsvc.HairSystemVendorContractID
	,hsvc.ContractName
	,hso.CostFactoryShipped
	,hscc.HairSystemCenterContractID
	,hso.CenterPrice

	FROM dbo.datHairSystemOrder hso
	LEFT JOIN cfgHairSystemVendorContractPricing hsvcp ON hsvcp.HairSystemVendorContractPricingID = hso.HairSystemVendorContractPricingID
		LEFT JOIN cfgHairSystemVendorContract hsvc ON hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID
	LEFT JOIN cfgHairSystemCenterContractPricing hsccp ON hsccp.HairSystemCenterContractPricingID = hso.HairSystemCenterContractPricingID
		LEFT JOIN cfgHairSystemCenterContract hscc ON hscc.HairSystemCenterContractID = hsccp.HairSystemCenterContractID
	INNER JOIN @CenterFilter hFilter ON hFilter.CenterID = hso.CenterID
	LEFT JOIN dbo.cfgHairSystem HS ON HS.HairSystemID = hso.HairSystemID
	LEFT JOIN dbo.lkpHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
	--Factory Filter Joins
	LEFT JOIN dbo.datPurchaseOrderDetail POD ON POD.HairSystemOrderGUID = HSO.HairSystemOrderGUID
		LEFT JOIN dbo.datPurchaseOrder PO ON PO.PurchaseOrderGUID = POD.PurchaseOrderGUID
			INNER JOIN dbo.cfgVendor v ON v.VendorID = PO.VendorID AND VendorTypeID = 2
	--LEFT JOIN (
	--	SELECT HairSystemOrderGUID
	--	FROM datHairSystemOrderTransaction t
	--	WHERE t.NewHairSystemOrderStatusID = 6
	--	GROUP BY HairSystemOrderGUID
	--) prh ON prh.HairSystemOrderGUID = hso.HairSystemOrderGUID
	WHERE HSO.HairSystemOrderStatusID = 2
	AND AppliedDate BETWEEN @StartDate AND @EndDate
) hair ON hair.CenterID = Center.CenterID
LEFT JOIN dbo.datClient c ON c.ClientGUID = hair.ClientGUID
LEFT JOIN dbo.datClientMembership cm ON cm.ClientMembershipGUID = hair.ClientMembershipGUID
	LEFT JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID

END
GO
