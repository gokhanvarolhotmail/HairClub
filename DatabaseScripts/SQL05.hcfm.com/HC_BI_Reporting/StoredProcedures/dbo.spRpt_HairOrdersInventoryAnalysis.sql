/* CreateDate: 11/05/2012 11:10:08.213 , ModifyDate: 11/05/2012 11:10:08.213 */
GO
/*==============================================================================
PROCEDURE:				spRpt_HairOrdersInventoryAnalysis
VERSION:				v1.0
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	Reporting
RELATED APPLICATION:  	Hair Orders - Inventory Analysis
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED:		11/4/2012
LAST REVISION DATE: 	11/4/2012
==============================================================================
DESCRIPTION:	Report that Inventory Analysis
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_HairOrdersInventoryAnalysis 1
==============================================================================*/
CREATE  PROCEDURE [dbo].[spRpt_HairOrdersInventoryAnalysis] (
@CenterTypeID INT = 1 --1 Corporate, 2 Franchise, 3 Joint Venture
) AS
	SET NOCOUNT ON
SET FMTONLY OFF

SELECT re.RegionDescription RegionDescription
,ce.CenterSSID CenterID
,ce.CenterDescriptionNumber CenterDescriptionFullCalc
,SUM(CENTStat) CENTStat
,SUM(ORDERStat) ORDERStat
,SUM(PRIORITYStat) PRIORITYStat
,SUM(HQShipStat) HQShipStat
,SUM(ShipCorpStat) ShipCorpStat
,SUM(CTRShipStat) CTRShipStat
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce  --cfgCenter c
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey
LEFT JOIN (
	SELECT
	CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN ClientCenter.CenterSSID ELSE SystemCenter.CenterSSID END AS CenterID
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CENT' THEN 1 ELSE 0 END AS CENTStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN 1 ELSE 0 END AS ORDERStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN 1 ELSE 0 END AS PRIORITYStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'HQ-Ship' THEN 1 ELSE 0 END AS HQShipStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ShipCorp' THEN 1 ELSE 0 END AS ShipCorpStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CTR-Ship' THEN 1 ELSE 0 END AS CTRShipStat
	,HSO.ClientKey
	,hso.CenterKey
	,hso.ClientMembershipKey
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder hso --datHairSystemOrder hso
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus hsos --lkpHairSystemOrderStatus hsos
		ON hsos.HairSystemOrderStatusKey = hso.HairSystemOrderStatusKey
		AND hsos.HairSystemOrderStatusDescriptionShort IN ('CENT','ORDER','PRIORITY','HQ-Ship','ShipCorp','CTR-Ship')
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON cl.ClientKey = hso.ClientKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ClientCenter ON ClientCenter.CenterSSID = cl.CenterSSID
	LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter SystemCenter ON SystemCenter.CenterKey = hso.CenterKey
) hair ON hair.CenterID = ce.CenterSSID
WHERE ce.CenterSSID = ce.ReportingCenterSSID --c.SurgeryHubCenterID IS NULL
AND CenterTypeSSID = @CenterTypeID
AND ce.Active = 'Y' --AND c.IsActiveFlag = 1
AND ce.CenterSSID <> 100
GROUP BY re.RegionDescription,ce.CenterSSID,ce.CenterDescriptionNumber
GO
