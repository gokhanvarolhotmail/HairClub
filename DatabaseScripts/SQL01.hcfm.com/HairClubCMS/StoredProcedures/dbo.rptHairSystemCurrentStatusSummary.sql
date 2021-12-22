/*
==============================================================================

PROCEDURE:				rptHairSystemCurrentStatusSummary
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairclubCMS
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		11/29/2016

==============================================================================
DESCRIPTION:	This is a SharePoint summary version of the cONEct report rptHairSystemCurrentStatus.rdl
==============================================================================
CHANGE HISTORY:
06/18/2019 - RH - Removed RegionID and RegionDescription (Case 7979)
==============================================================================

SAMPLE EXECUTION:

EXEC [rptHairSystemCurrentStatusSummary] 1, 8

==============================================================================
*/
CREATE PROCEDURE [dbo].[rptHairSystemCurrentStatusSummary] (
	@MainGroupID INT
	,	@HairSystemOrderStatusID int
)

AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT OFF;

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	AreaID INT
,	AreaDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
);


/********************************** Get list of centers *************************************/

IF @MainGroupID = 1  --By Corporate Areas
BEGIN
	INSERT  INTO #Centers
	SELECT  CMA.CenterManagementAreaID AS 'AreaID'
	,		CMA.CenterManagementAreaDescription AS 'AreaDescription'
	,		C.CenterID
	,		C.CenterDescription
	,		C.CenterDescriptionFullCalc
	,		CT.CenterTypeDescriptionShort
	FROM    cfgCenter C
			INNER JOIN lkpCenterType CT
				ON C.CenterTypeID= CT.CenterTypeID
			INNER JOIN lkpRegion R
				ON C.RegionID = R.RegionID
			INNER JOIN dbo.cfgCenterManagementArea CMA
				ON C.CenterManagementAreaID = CMA.CenterManagementAreaID

	WHERE   CT.CenterTypeDescriptionShort = 'C'
			AND C.IsActiveFlag = 1;
END

IF @MainGroupID = 2  --By Franchise Regions
BEGIN
	INSERT  INTO #Centers
	SELECT  R.RegionID AS AreaID
	,		R.RegionDescription AS AreaDescription
	,		C.CenterID
	,		C.CenterDescription
	,		C.CenterDescriptionFullCalc
	,		CT.CenterTypeDescriptionShort
	FROM    cfgCenter C
			INNER JOIN lkpCenterType CT
				ON C.CenterTypeID= CT.CenterTypeID
			INNER JOIN lkpRegion R
				ON C.RegionID = R.RegionID
	WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
			AND C.IsActiveFlag = 1;
END


/***************** Main select statement ****************************************************************/

SELECT 	CTR.AreaID
	,	CTR.AreaDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	,	CTR.CenterTypeDescriptionShort
	,	hsos.HairSystemOrderStatusDescription
	,	hsos.HairSystemOrderStatusDescriptionShort
	,	COUNT(hso.HairSystemOrderNumber) AS HairSystemCount
FROM dbo.datHairSystemOrder hso
	INNER JOIN dbo.lkpHairSystemOrderStatus hsos
		ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	INNER JOIN dbo.cfgHairSystem hs
		ON hso.HairSystemID = hs.HairSystemID
	INNER JOIN dbo.cfgCenter C
		ON hso.ClientHomeCenterID = C.CenterID
	INNER  JOIN #Centers CTR
		ON C.CenterID = CTR.CenterID
WHERE hsos.HairSystemOrderStatusID = @HairSystemOrderStatusID
GROUP BY	CTR.AreaID
		,	CTR.AreaDescription
       ,	CTR.CenterID
       ,	CTR.CenterDescription
       ,	CTR.CenterDescriptionFullCalc
       ,	CTR.CenterTypeDescriptionShort
	   ,	hsos.HairSystemOrderStatusDescription
	   ,	hsos.HairSystemOrderStatusDescriptionShort;

END
