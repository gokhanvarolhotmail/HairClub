/* CreateDate: 10/09/2012 09:02:44.243 , ModifyDate: 11/29/2018 13:48:54.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptAppliedHairSystemCost
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
-------------------------------------------------------------------------------------------------------
NOTES: 	Returns
		* 10/09/2012 - HDu - 5901 Created new report stored proc
		* 09/10/2013 - MB - Removed SurgeryHubCenter condition
		* 10/04/2017 - RH - Added IsActiveFlag = 1 for Center query
-------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC rptAppliedHairSystemCost '201,203,204,205,228', NULL, '8/1/2017', '8/31/2017', NULL

================================================================================================*/
CREATE PROCEDURE [dbo].[rptAppliedHairSystemCost]
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
			WHERE CenterTypeID = @JointVentureCenterTypeID
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
	,SUM(CASE WHEN hair.HairSystemOrderNumber IS NOT NULL THEN 1 ELSE 0 END)  AS 'Applications'
	--For Center Counts
	--,SUM(CASE WHEN hair.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 1 ELSE 0 END) AS 'Design'
	--,SUM(CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MEA' THEN 1 ELSE 0 END) AS 'MEA'
	--,SUM(CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MAN' THEN 1 ELSE 0 END) AS 'Manual'
	--,SUM(CASE hair.HairSystemDescriptionShort WHEN 'NB1' THEN 1 ELSE 0 END) AS 'Express'
	,SUM(hair.CostActual) AS 'TotalCost'

	,dbo.fxDivideDecimal(SUM(hair.CostActual),SUM(CASE WHEN hair.HairSystemOrderNumber IS NOT NULL THEN 1 ELSE 0 END)) AS 'AverageCost'
	,SUM(hair.CenterPrice) AS TotalPrice
	,dbo.fxDivideDecimal(SUM(hair.CenterPrice),SUM(CASE WHEN hair.HairSystemOrderNumber IS NOT NULL THEN 1 ELSE 0 END)) AS AveragePrice
	,dbo.fxDivideDecimal(SUM(hair.CenterPrice) - SUM(hair.CostActual),SUM(hair.CenterPrice)) AS 'Margin'
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
	,hso.CenterPrice
	,CASE
		WHEN dt.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
	,hso.CostActual
	,hso.CostFactoryShipped
	FROM dbo.datHairSystemOrder hso
	INNER JOIN @CenterFilter hFilter ON hFilter.CenterID = hso.CenterID
	LEFT JOIN dbo.cfgHairSystem HS ON HS.HairSystemID = hso.HairSystemID
	LEFT JOIN dbo.lkpHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
	--Factory Filter Joins
	LEFT JOIN dbo.datPurchaseOrderDetail POD ON POD.HairSystemOrderGUID = HSO.HairSystemOrderGUID
		LEFT JOIN dbo.datPurchaseOrder PO ON PO.PurchaseOrderGUID = POD.PurchaseOrderGUID
			INNER JOIN dbo.cfgVendor v ON v.VendorID = PO.VendorID AND VendorTypeID = 2
	WHERE HSO.HairSystemOrderStatusID = 2
	AND AppliedDate BETWEEN @StartDate AND @EndDate
) hair ON hair.CenterID = Center.CenterID
LEFT JOIN dbo.datClient c ON c.ClientGUID = hair.ClientGUID
LEFT JOIN dbo.datClientMembership cm ON cm.ClientMembershipGUID = hair.ClientMembershipGUID
	LEFT JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
GROUP BY Region.RegionDescription
,Center.CenterID
,Center.CenterDescriptionFullCalc

END
GO
