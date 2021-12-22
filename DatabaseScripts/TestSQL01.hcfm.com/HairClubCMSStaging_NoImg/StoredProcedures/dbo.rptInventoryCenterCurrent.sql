/* CreateDate: 10/26/2018 15:39:41.150 , ModifyDate: 03/03/2020 13:16:28.740 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptInventoryCenterCurrent
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Rachelen Hut
================================================================================================
Change History:
07/23/2019 - JL - Case 6321 Modify 'Center Current Inventory' Report, added parameter itemksu
02/27/2020 - RH - TrackIT 7474 Added where scdist.CenterID = 1091  --distributor
================================================================================================
--------------------------------------------------------------------------------------------------------
NOTES: This version of the report will be in ClubHouse.
@Center = 1 for All Corporate Centers OR 2 for All Franchise Centers OR 3 for All Centers, OR @Center = the individual center
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptInventoryCenterCurrent] 1, NULL, 'ALL'
EXEC [rptInventoryCenterCurrent] 2, NULL, '03-03-08-001/'
EXEC [rptInventoryCenterCurrent] 3, NULL, 'ALL'
EXEC [rptInventoryCenterCurrent] 4, 240, 'ALL'

******************************************************************************************************/

CREATE PROCEDURE [dbo].[rptInventoryCenterCurrent] (
	@Center INT
	,	@CenterID INT = NULL
	,   @ItemSku NVARCHAR(50) = null)
AS
BEGIN

	SET NOCOUNT ON;

/************* Create temp tables *******************************************************************/

CREATE TABLE #Centers(
	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
)

CREATE TABLE #Inv(
	CenterID INT
,   CenterNumber INT
,   CenterDescription NVARCHAR(104)
,   CenterDescriptionFullCalc NVARCHAR(104)
,   ItemSKU NVARCHAR(150)
,   Category NVARCHAR(50)
,	SalesCodeDescription NVARCHAR(60)
,	Size NVARCHAR(50)
,	BrandDescription NVARCHAR(150)
,   QuantityOnHand INT
,   PacksAvailable INT
)

/************* Find Centers *************************************************************************/

IF @Center = 1						--All Corporate Centers
BEGIN
	INSERT INTO #Centers
	SELECT CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	FROM dbo.cfgCenter CTR
		INNER JOIN dbo.lkpCenterType CT
			ON CTR.CenterTypeID = CT.CenterTypeID
	WHERE CT.CenterTypeDescriptionShort = 'C'
		AND CTR.IsActiveFlag = 1
END
ELSE IF @Center = 2					--All Franchise Centers
BEGIN
	INSERT INTO #Centers
	SELECT CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	FROM dbo.cfgCenter CTR
		INNER JOIN dbo.lkpCenterType CT
			ON CTR.CenterTypeID = CT.CenterTypeID
	WHERE CT.CenterTypeDescriptionShort IN('F','JV')
		AND CTR.IsActiveFlag = 1
END
ELSE IF @Center = 3					--All Centers
BEGIN
	INSERT INTO #Centers
	SELECT CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	FROM dbo.cfgCenter CTR
		INNER JOIN dbo.lkpCenterType CT
			ON CTR.CenterTypeID = CT.CenterTypeID
	WHERE CT.CenterTypeDescriptionShort IN('C','F','JV')
		AND CTR.IsActiveFlag = 1
END
ELSE IF @Center = 4			--Individual Center
BEGIN
	INSERT INTO #Centers
	SELECT CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	FROM dbo.cfgCenter CTR
	WHERE CenterID = @CenterID
		AND CTR.IsActiveFlag = 1
END


/************* Select statement **********************************************************************/

INSERT INTO #Inv
SELECT r.CenterID
,       r.CenterNumber
,       r.CenterDescription
,       r.CenterDescriptionFullCalc
,       r.ItemSKU
,       r.Category
,		r.SalesCodeDescription
,		r.Size
,		r.BrandDescription
,       SUM(r.QuantityOnHand) AS QuantityOnHand
,       SUM(r.PacksAvailable ) AS PacksAvailable
FROM
	(SELECT	c.CenterID
	,	c.CenterNumber
	,	c.CenterDescription
	,	c.CenterDescriptionFullCalc
	,	scdist.ItemSKU
	,	scd.SalesCodeDepartmentDescription AS Category
	,	scci.QuantityOnHand
	,	CASE WHEN sc.QuantityPerPack > 0 THEN scdist.QuantityAvailable/sc.QuantityPerPack
			ELSE scdist.QuantityAvailable
		END AS 'PacksAvailable'
	,	sc.SalesCodeDescription
	,	sc.Size
	,	b.BrandDescription
	FROM dbo.cfgSalesCode sc
		LEFT JOIN dbo.cfgSalesCodeCenter scc
			ON sc.SalesCodeID = scc.SalesCodeID
		LEFT JOIN dbo.cfgCenter c
			ON scc.CenterID = c.CenterID
		LEFT JOIN dbo.datSalesCodeCenterInventory scci
			ON scc.SalesCodeCenterID = scci.SalesCodeCenterID
		LEFT JOIN dbo.lkpSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
		LEFT JOIN dbo.cfgSalesCodeDistributor scdist
			ON sc.SalesCodeID = scdist.SalesCodeID
		LEFT JOIN dbo.lkpBrand B
			ON SC.BrandID = B.BrandID
	WHERE c.CenterID IN(SELECT CenterID FROM #Centers)
		AND sc.IsActiveFlag = 1
		AND scc.IsActiveFlag = 1
		AND scci.IsActive = 1
		AND (scdist.itemsku = @ItemSku OR @ItemSku = 'ALL')
		AND scdist.CenterID = 1091  --distributor
	)r
WHERE r.ItemSKU IS NOT NULL
GROUP BY r.CenterID
,       r.CenterNumber
,       r.CenterDescription
,       r.CenterDescriptionFullCalc
,       r.ItemSKU
,       r.Category
,		r.SalesCodeDescription
,		r.Size
,		r.BrandDescription

SELECT * FROM #Inv


END
GO
