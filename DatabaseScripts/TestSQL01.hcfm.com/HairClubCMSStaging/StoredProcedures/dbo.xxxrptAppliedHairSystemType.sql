/* CreateDate: 07/24/2012 15:53:48.130 , ModifyDate: 02/27/2017 09:49:36.587 */
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
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

Sample Execution:
EXEC rptAppliedHairSystemType @CenterIds = '228',@StartDate = '2012-04-01',@EndDate = '2012-05-31'
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
		* 07/11/2012 - HDu - Created new report stored proc
		* 09/09/2013 - MB - Removed SurgeryHubCenter condition
--------------------------------------------------------------------------------------------------------
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

	DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'JV'

	DECLARE @CenterFilter TABLE ( CenterID INT )
	--INSERT INTO @CenterFilter
	--SELECT item FROM fnSplit(@CenterIds,',')

	-- Add Corporate CenterIDs to List
	IF (@CenterIds =1)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 1)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterID
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
		END

	-- Add Franchise CenterIDs to List
	IF (@CenterIds =2)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 2)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterID
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @FranchiseCenterTypeID
		END

	-- Add JointVenture CenterIDs to List
	IF (@CenterIds =3)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterID
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @JointVentureCenterTypeID
		END

	-- Add all centers for a region to List
	IF (@CenterIds < 100)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			INSERT INTO @CenterFilter
			Select c.CenterID
			FROM dbo.cfgCenter c
			INNER JOIN lkpRegion r ON r.RegionID = c.RegionID
			WHERE r.RegionNumber = @CenterIds
		END

	-- Add individual center to List
	IF (@CenterIds >= 100)--EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			INSERT INTO @CenterFilter
			Select CenterID
			FROM dbo.cfgCenter
			WHERE CenterID = @CenterIds
		END



SELECT
	--Region.RegionDescription AS 'Region'
	--Center Grouping

	--,Center.CenterDescriptionFullCalc AS 'Center'
	hair.HairSystemDescriptionShort
	--,Center.CenterID
	,COUNT(Center.CenterID) AS 'Applications'

FROM dbo.lkpRegion Region
INNER JOIN dbo.cfgCenter Center ON Center.RegionID = Region.RegionID
INNER JOIN @CenterFilter cFilter ON cFilter.CenterID = Center.CenterID
INNER JOIN (
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
	,CASE
		WHEN dt.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
	FROM dbo.datHairSystemOrder hso
	INNER JOIN @CenterFilter hFilter ON hFilter.CenterID = hso.CenterID
	INNER JOIN dbo.cfgHairSystem HS ON HS.HairSystemID = hso.HairSystemID
	INNER JOIN dbo.lkpHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
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
GROUP BY hair.HairSystemDescriptionShort

END
GO
