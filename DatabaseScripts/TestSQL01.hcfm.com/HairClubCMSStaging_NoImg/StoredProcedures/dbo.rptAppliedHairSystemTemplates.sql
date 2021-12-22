/* CreateDate: 07/24/2012 15:53:53.393 , ModifyDate: 08/06/2018 16:13:28.000 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*======================================================================================================
 Procedure Name:			rptAppliedHairSystemTemplates
 Procedure Description:

 Created By:				HDu
 Implemented By:			HDu
 Last Modified By:			HDu

 Date Created:				11/02/2011
 Date Implemented:			11/02/2011
 Date Last Modified:		11/02/2011

 Destination Server:		SQL01
 Destination Database:		HairClubCMS
 Related Application:		CMS


--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
10/26/2011 - HDu - 5901 Created new report stored proc
07/10/2013 - MB - Removed SurgeryHubCenter condition
08/06/2018 - RH - Added code to include CenterManagementArea as a "Region"
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC rptAppliedHairSystemTemplates '201,203,204,205,228', NULL, '7/1/2018', '7/10/2018', NULL
=======================================================================================================*/
CREATE PROCEDURE [dbo].[rptAppliedHairSystemTemplates]
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

	SELECT @CorpCenterTypeID =  CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'C' AND IsActiveFlag = 1
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'F' AND IsActiveFlag = 1
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM dbo.lkpCenterType where CenterTypeDescriptionShort = 'JV' AND IsActiveFlag = 1

	-- Add Corporate CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 1)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds  + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @CorpCenterTypeID
				AND IsCorporateHeadquartersFlag = 0
				AND IsActiveFlag = 1
			--AND SurgeryHubCenterID IS NULL
		END

	-- Add Franchise CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 2)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @FranchiseCenterTypeID
				AND IsActiveFlag = 1
			--AND SurgeryHubCenterID IS NULL
		END

	-- Add JointVenture CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIds, ',') WHERE item = 3)
		BEGIN
			Select @CenterIds = COALESCE(@CenterIds + ',' + CONVERT(nvarchar,CenterID),'')
			FROM dbo.cfgCenter
			WHERE CenterTypeID = @JointVentureCenterTypeID
				AND IsActiveFlag = 1
			--AND SurgeryHubCenterID IS NULL
		END


DECLARE @CenterFilter TABLE (
	CenterID INT
)
INSERT INTO @CenterFilter
SELECT item FROM fnSplit(@CenterIds,',')

SELECT
CASE WHEN CT.CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaDescription ELSE Region.RegionDescription END AS 'Region'
,	Center.CenterID
,	Center.CenterDescriptionFullCalc AS 'Center'
,	SUM(CASE WHEN hair.HairSystemOrderNumber IS NOT NULL THEN 1 ELSE 0 END)  AS 'Applications'
,	SUM(CASE WHEN hair.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 1 ELSE 0 END) AS 'Design'
,	SUM(CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MEA' THEN 1 ELSE 0 END) AS 'MEA'
,	SUM(CASE hair.HairSystemDesignTemplateDescriptionShort WHEN 'MAN' THEN 1 ELSE 0 END) AS 'Manual'
,	SUM(CASE hair.HairSystemDescriptionShort WHEN 'NB1' THEN 1 ELSE 0 END) AS 'Express'
FROM @CenterFilter cFilter
INNER JOIN dbo.cfgCenter Center ON Center.CenterID = cFilter.CenterID
INNER JOIN dbo.lkpCenterType CT ON CT.CenterTypeID = Center.CenterTypeID
LEFT JOIN dbo.cfgCenterManagementArea CMA ON CMA.CenterManagementAreaID = Center.CenterManagementAreaID
LEFT JOIN dbo.lkpRegion Region ON Region.RegionID = Center.RegionID
LEFT JOIN (
	SELECT
		hso.CenterID
	,	hso.ClientGUID
	,	hso.ClientHomeCenterID
	,	hso.HairSystemOrderDate
	,	hso.HairSystemOrderGUID
	,	hso.HairSystemOrderNumber
	,	hso.AppliedDate
	,	hso.HairSystemID
	,	hso.HairSystemDesignTemplateID
	,	hs.HairSystemDescription
	,	hs.HairSystemDescriptionShort
	,	dt.HairSystemDesignTemplateDescription
	,	dt.HairSystemDesignTemplateDescriptionShort
	,	hso.IsStockInventoryFlag AS prh
	,	hso.ClientMembershipGUID
	,	CASE
		WHEN dt.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
		WHEN dt.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
	FROM dbo.datHairSystemOrder hso
	INNER JOIN @CenterFilter hFilter ON hFilter.CenterID = hso.CenterID
	LEFT JOIN dbo.cfgHairSystem HS ON HS.HairSystemID = hso.HairSystemID
	LEFT JOIN dbo.lkpHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
	LEFT JOIN dbo.datPurchaseOrderDetail POD ON POD.HairSystemOrderGUID = HSO.HairSystemOrderGUID
		LEFT JOIN dbo.datPurchaseOrder PO ON PO.PurchaseOrderGUID = POD.PurchaseOrderGUID
			INNER JOIN dbo.cfgVendor v ON v.VendorID = PO.VendorID AND VendorTypeID = 2
	WHERE HSO.HairSystemOrderStatusID = 2
	AND AppliedDate BETWEEN @StartDate AND @EndDate
) hair ON hair.CenterID = Center.CenterID
LEFT JOIN dbo.datClient c ON c.ClientGUID = hair.ClientGUID
LEFT JOIN dbo.datClientMembership cm ON cm.ClientMembershipGUID = hair.ClientMembershipGUID
LEFT JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
GROUP BY CMA.CenterManagementAreaDescription
,	Region.RegionDescription
,	Center.CenterID
,	Center.CenterDescriptionFullCalc
,	CT.CenterTypeDescriptionShort



END
GO
