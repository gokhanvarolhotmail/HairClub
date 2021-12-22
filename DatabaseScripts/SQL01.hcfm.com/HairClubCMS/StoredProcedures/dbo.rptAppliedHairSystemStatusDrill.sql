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
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC rptAppliedHairSystemStatusDrill  '201','1/1/2017','1/11/2017', 0
--------------------------------------------------------------------------------------------------------
NOTES:
		* 07/11/2012 - HDu - Created new report stored proc
		* 09/10/2013 - MB - Removed SurgeryHubCenter condition
		* 01/11/2017 - RH - Added Area (#132688)
--------------------------------------------------------------------------------------------------------
================================================================================================*/
CREATE PROCEDURE [dbo].[rptAppliedHairSystemStatusDrill]
(
	 @CenterIds VARCHAR(MAX) = NULL
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@IsStockInventoryFlag BIT = 0
)
AS
BEGIN
	SET @EndDate = CONVERT(VARCHAR(10),@EndDate,120) + ' 23:59:59.999'

	DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'JV'

	-- Add All Centers to List
	IF @CenterIds IS NULL
		Select @CenterIds = COALESCE(@CenterIds  + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter

	-- Add Corporate CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 1)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds  + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
		END

	-- Add Franchise CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 2)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @FranchiseCenterTypeID
		END

	-- Add JointVenture CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @JointVentureCenterTypeID
		END

DECLARE @CenterFilter TABLE ( CenterID INT )
INSERT INTO @CenterFilter
SELECT item FROM fnSplit(@CenterIds,',')

SELECT
	Region.RegionDescription AS 'Region'
	--Center Grouping
	,Center.CenterID
	,Center.CenterDescriptionFullCalc AS 'Center'
	,	Center.CenterManagementAreaID
	,	CMA.CenterManagementAreaDescription

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

FROM dbo.lkpRegion Region
INNER JOIN dbo.cfgCenter Center ON Center.RegionID = Region.RegionID
INNER JOIN dbo.cfgCenterManagementArea CMA ON Center.CenterManagementAreaID = CMA.CenterManagementAreaID
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
	,CASE
		WHEN dt.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
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
WHERE prh = @IsStockInventoryFlag


END
