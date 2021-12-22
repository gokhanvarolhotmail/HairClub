/* CreateDate: 11/09/2012 15:30:27.783 , ModifyDate: 10/02/2019 09:52:33.550 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
PROCEDURE:				spRpt_HairOrdersInventoryDetails
VERSION:				v1.0
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	Reporting
RELATED APPLICATION:  	Hair Orders Inventory Details for 2 Hair Inventory reports
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED:		11/9/2012
LAST REVISION DATE: 	11/9/2012
==============================================================================
DESCRIPTION:	Report Details for Inventory Analysis
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_HairOrdersInventoryDetails 1080
==============================================================================*/
CREATE  PROCEDURE [dbo].[spRpt_HairOrdersInventoryDetails] (
--@CenterTypeID INT = 1 --1 Corporate, 2 Franchise, 3 Joint Venture
@CenterID INT
) AS
	SET NOCOUNT ON
SET FMTONLY OFF

SELECT re.RegionDescription RegionDescription
,ce.CenterSSID CenterID
--,ce.CenterNumber CenterID
,ce.CenterDescriptionNumber CenterDescriptionFullCalc
,ClientFullName
,HairSystemOrderNumber
,HairSystemOrderDate
,CostActual

--For Drilldown Filter
,CENTStat
,ORDERStat
,PRIORITYStat
,INTRANStat
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce  --cfgCenter c
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey
LEFT JOIN (
	SELECT
	CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN ClientCenter.CenterSSID ELSE SystemCenter.CenterSSID END AS CenterID
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'CENT' THEN 1 ELSE 0 END AS CENTStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'ORDER' THEN 1 ELSE 0 END AS ORDERStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN 1 ELSE 0 END AS PRIORITYStat
	,CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('HQ-Ship','ShipCorp','CTR-Ship') THEN 1 ELSE 0 END AS INTRANStat
	,hso.HairSystemOrderNumber
	,hso.HairSystemOrderDate
	,hsos.HairSystemOrderStatusDescriptionShort
	,HSO.ClientKey
	,hso.CenterKey
	,hso.ClientMembershipKey
	,hso.CostActual
	,cl.ClientFullName

	FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder hso --datHairSystemOrder hso
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus hsos --lkpHairSystemOrderStatus hsos
		ON hsos.HairSystemOrderStatusKey = hso.HairSystemOrderStatusKey
		AND hsos.HairSystemOrderStatusDescriptionShort IN ('CENT','ORDER','PRIORITY','HQ-Ship','ShipCorp','CTR-Ship')
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON cl.ClientKey = hso.ClientKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ClientCenter ON ClientCenter.CenterSSID = cl.CenterSSID
	LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter SystemCenter ON SystemCenter.CenterKey = hso.CenterKey
) hair ON hair.CenterID = ce.CenterSSID

WHERE ce.CenterSSID = ce.ReportingCenterSSID --c.SurgeryHubCenterID IS NULL
--AND CenterTypeSSID = @CenterTypeID
AND ce.CenterSSID = @CenterID
AND ce.Active = 'Y' --AND c.IsActiveFlag = 1
AND ce.CenterSSID <> 100
--GROUP BY re.RegionDescription,ce.CenterSSID,ce.CenterDescriptionNumber
GO
