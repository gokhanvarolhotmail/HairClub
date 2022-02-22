/* CreateDate: 02/18/2022 12:49:25.643 , ModifyDate: 02/18/2022 12:49:25.643 */
GO
--drop View [dbo].[vw_HSO_FHSO];

Create View [dbo].[vw_HSO_FHSO]
--(
--[OrderDate],
--[HairSystemOrderNumber],
--[HairSystemOrderDate],
--[HairSystemDueDate],
--[HairSystemAlocationDate],
--[HairSystemReceivedDate],
--[HairSystemShippedDate],
--[HairSystemAppliedDate],
--CenterSSID,
--CenterDescriptionNumber,
--ClientIdentifier,
--ClientFullName,
--MembershipDescription,
--HairSystemTypeDescriptionShort,
--HairSystemTypeDescription,
--HairSystemDesignTemplateDescription,
--[CapSizeKey],
--[TemplateWidth],
--[TemplateHeight],[
--TemplateArea],
--[FactorySSID],
--HairSystemOrderStatusDescription,
--[CostContract],
--[CostActual],
--[PriceContract],
--[DaystoDelivery],
--[DaysSinceAllocation],
--[HairSystemRepairReasonDescription],
--[HairSystemRedoReasonDescription],
--[IsOnHoldForReviewFlag],
--[IsSampleOrderFlag],
--[IsRepairOrderFlag],
--[IsRedoOrderFlag],
--[IsRushOrderFlag],
--[IsStockInventoryFlag],
--[OrderCount])
----with schemabinding
as
SELECT
[OrderDate],
[HairSystemOrderNumber],
[HairSystemOrderDate],
[HairSystemDueDate],
[HairSystemAlocationDate],
[HairSystemReceivedDate],
[HairSystemShippedDate],
[HairSystemAppliedDate],
c.CenterSSID,c.CenterDescriptionNumber,
cl.ClientIdentifier,cl.ClientFullName,
mem.MembershipDescription,
hst.HairSystemTypeDescriptionShort,hst.HairSystemTypeDescription,
hsdt.HairSystemDesignTemplateDescription,
[CapSizeKey],[TemplateWidth],
[TemplateHeight],[TemplateArea],[FactorySSID],
hsos.HairSystemOrderStatusDescription,[CostContract],
[CostActual],[PriceContract],[DaystoDelivery],[DaysSinceAllocation],
[HairSystemRepairReasonDescription],[HairSystemRedoReasonDescription],
[IsOnHoldForReviewFlag],[IsSampleOrderFlag],[IsRepairOrderFlag],[IsRedoOrderFlag],
[IsRushOrderFlag],[IsStockInventoryFlag],[OrderCount]
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[vwFactHairSystemOrder] hso
INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClient cl  ON cl.ClientKey = hso.ClientKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.vw_mktg_DimCenter c  ON c.CenterKey = hso.CenterKey
INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimHairSystemOrderStatus hsos  ON hsos.HairSystemOrderStatusKey = hso.HairSystemOrderStatusKey
INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimHairSystemDesignTemplate hsdt  ON hsdt.HairSystemDesignTemplateKey = hso.HairSystemDesignTemplateKey
INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimHairSystemType hst  ON hst.HairSystemTypeKey = hso.HairSystemTypeKey
INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimMembership mem  ON mem.MembershipKey = hso.MembershipKey
WHERE hso.OrderDate > '1/1/2020';
GO
