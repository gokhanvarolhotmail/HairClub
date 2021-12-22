/***********************************************************************

PROCEDURE:				rptInventoryAuditWorksheet
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Rachelen Hut

--------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
08/28/2019 - RH - Changed CenterNumber to CenterID so that Delray Beach would show data
02/27/2020 - RH - Added where scdist.CenterID = 1091  --distributor
08/20/2020 - AP - Change order by TFS14630
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptInventoryAuditWorksheet] 1080

******************************************************************************************************/

CREATE PROCEDURE [dbo].[rptInventoryAuditWorksheet] (
	@CenterID INT )
AS
BEGIN

	SET NOCOUNT ON;

/************* Select statement **********************************************************************/

SELECT	CASE WHEN b.BrandDescription = '' THEN 'No Brand Name' ELSE ISNULL(b.BrandDescription,'No Brand Name') END AS Brand
	,sc.SalesCodeDescriptionShort AS [ItemSKU]
	,scd.SalesCodeDepartmentDescription AS Category
	,sc.Size
	,sc.SalesCodeDescription AS [ItemDescription]
FROM dbo.cfgSalesCode sc
	LEFT JOIN dbo.cfgSalesCodeCenter scc on sc.SalesCodeID = scc.SalesCodeID
	LEFT JOIN dbo.cfgCenter c on scc.CenterID = c.CenterID
	LEFT JOIN dbo.datSalesCodeCenterInventory scci on scc.SalesCodeCenterID = scci.SalesCodeCenterID
	LEFT JOIN dbo.lkpSalesCodeDepartment scd on sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
	LEFT JOIN dbo.lkpBrand b on sc.BrandID = b.BrandID
	LEFT JOIN dbo.cfgSalesCodeDistributor scdist on sc.SalesCodeID = scdist.SalesCodeID
WHERE c.CenterID = @CenterID
	AND sc.IsActiveFlag = 1
	AND scc.IsActiveFlag = 1
	AND scci.IsActive = 1
	AND sc.IsSerialized = 0
	AND scdist.CenterID = 1091  --distributor
ORDER BY  scd.SalesCodeDepartmentDescription, sc.SalesCodeDescription

--b.BrandDescription,

END
