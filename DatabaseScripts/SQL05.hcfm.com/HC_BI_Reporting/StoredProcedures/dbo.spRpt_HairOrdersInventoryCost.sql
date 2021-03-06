/* CreateDate: 11/05/2012 11:11:22.167 , ModifyDate: 11/09/2012 15:24:30.763 */
GO
/*==============================================================================
PROCEDURE:				spRpt_HairOrdersInventoryCost
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
EXEC spRpt_HairOrdersInventoryCost 1
==============================================================================*/
CREATE  PROCEDURE [dbo].[spRpt_HairOrdersInventoryCost] (
@CenterTypeID INT = 1 --1 Corporate, 2 Franchise, 3 Joint Venture
) AS
	SET NOCOUNT ON
SET FMTONLY OFF

SELECT re.RegionDescription RegionDescription
,ce.CenterSSID CenterID
,ce.CenterDescriptionNumber CenterDescriptionFullCalc
,SUM(CENTStat) CENTStat
,SUM(CENTCost) CENTCost
,SUM(ORDERStat) ORDERStat
,SUM(ORDERCost) ORDERCost
,SUM(PRIORITYStat) PRIORITYStat
,SUM(PRIORITYCost) PRIORITYCost
,SUM(INTRANStat) INTRANStat
,SUM(INTRANCost) INTRANCost
,SUM(CENTStat) + SUM(PRIORITYStat) + SUM(INTRANStat) TOTALStat
,SUM(CENTCost) + SUM(PRIORITYCost) + SUM(INTRANCost) TOTALCost

FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce  --cfgCenter c
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey
LEFT JOIN (
	SELECT
	CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN ClientCenter.CenterSSID ELSE SystemCenter.CenterSSID END AS CenterID
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CENT' THEN 1 ELSE 0 END AS CENTStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CENT' THEN hso.CostActual ELSE 0 END AS CENTCost
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN 1 ELSE 0 END AS ORDERStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN hso.CostActual ELSE 0 END AS ORDERCost
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN 1 ELSE 0 END AS PRIORITYStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN hso.CostActual ELSE 0 END AS PRIORITYCost
	--,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'HQ-Ship' THEN 1 ELSE 0 END AS HQShipStat
	--,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ShipCorp' THEN 1 ELSE 0 END AS ShipCorpStat
	--,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CTR-Ship' THEN 1 ELSE 0 END AS CTRShipStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('HQ-Ship','ShipCorp','CTR-Ship') THEN 1 ELSE 0 END AS INTRANStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('HQ-Ship','ShipCorp','CTR-Ship') THEN hso.CostActual ELSE 0 END AS INTRANCost
	,HSO.ClientKey
	,hso.CenterKey
	,hso.ClientMembershipKey
	,hso.CostActual
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
