/*
==============================================================================

PROCEDURE:				rptHairInventory

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairclubCMS

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		07/10/13

==============================================================================
DESCRIPTION:	Hair Inventory
==============================================================================
SAMPLE EXECUTION:
EXEC rptHairInventory 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptHairInventory] (
	@CenterTypeID INT
)AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


	SELECT r.RegionDescription
	,c.CenterID
	,c.CenterDescriptionFullCalc
	,SUM(CENTStat) CENTStat
	,SUM(ORDERStat) ORDERStat
	,SUM(PRIORITYStat) PRIORITYStat
	,SUM(HQShipStat) HQShipStat
	,SUM(ShipCorpStat) ShipCorpStat
	,SUM(CTRShipStat) CTRShipStat
	FROM cfgCenter c
	INNER JOIN lkpRegion r ON r.RegionID = c.RegionID
	LEFT JOIN (
		SELECT
		CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN ClientHomeCenterID ELSE CenterID END AS CenterID
		,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CENT' THEN 1 ELSE 0 END AS CENTStat
		,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN 1 ELSE 0 END AS ORDERStat
		,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN 1 ELSE 0 END AS PRIORITYStat
		,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'HQ-Ship' THEN 1 ELSE 0 END AS HQShipStat
		,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ShipCorp' THEN 1 ELSE 0 END AS ShipCorpStat
		,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CTR-Ship' THEN 1 ELSE 0 END AS CTRShipStat
		FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hsos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
			AND hsos.HairSystemOrderStatusDescriptionShort IN ('CENT','ORDER','PRIORITY','HQ-Ship','ShipCorp','CTR-Ship')
	) hair ON hair.CenterID = c.CenterID
		WHERE CenterTypeID = @CenterTypeID
	AND c.IsActiveFlag = 1
	GROUP BY RegionDescription,CenterDescriptionFullCalc,c.CenterID

END
