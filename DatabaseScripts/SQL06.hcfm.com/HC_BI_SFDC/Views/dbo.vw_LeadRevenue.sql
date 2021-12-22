/* CreateDate: 07/22/2020 14:16:40.580 , ModifyDate: 02/23/2021 11:40:12.783 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NOTES

	01/05/2020	KMurdoch	Fixed TotalMembershipRevenue to be in alignment with Net NB1plusSur in the Cubes
	01/05/2020	KMurdoch	Changed Laser Revenue to be NB_Laser; Added PostEXT & PRP Revenue Amounts
	01/05/2020  KMurdoch	Added Campaign Name
	01/05/2020	KMurdoch	Added CenterNumber and CenterType
	01/07/2020  KMurdoch    Added a check for active center in join
	01/25/2021  KMurdoch    Added Location
	02/23/2021  KMurdoch    Fixed CenterNumber join to reflect null center numbers

*/




CREATE VIEW [dbo].[vw_LeadRevenue]

AS

SELECT dc.SFDC_LeadID,
       dc.CreationDate AS 'CreatedDate',
	   ISNULL(ISNULL(l.CenterNumber__c,l.CenterID__c),'100') AS 'CenterNumber',
	   ISNULL(ct.CenterTypeDescription,'Unknown') AS 'CenterType',
	   ISNULL(ds.OwnerType,'Unknown') AS 'OwnerType',
	   ISNULL(ds.CampaignName,'Unknown') AS 'CampaignName',
	   ISNULL(l.OriginalCampaignID__c,'Unknown') AS 'CampaignID',
	   ISNULL(l.Source_Code_Legacy__c,'Unknown') AS 'OriginalSourceCode',
	   ISNULL(ds.Level02Location,'Unknown') AS 'Location__c',
	   SUM((fsc.[NB_TradAmt] + fsc.[NB_GradAmt])) AS 'XtrandsPlusRevenue',
       SUM(fsc.[NB_ExtAmt]) AS 'EXTRevenue',
       SUM(fsc.[NB_XTRAmt]) AS 'XtrandsRevenue',
       SUM(fsc.[NB_MDPAmt]) AS 'RestorInkRevenue',
       SUM(fsc.[S_SurAmt]) AS 'SurgeryRevenue',
       SUM(fsc.[NB_GradAmt] + fsc.[NB_ExtAmt] + fsc.[NB_TradAmt] + fsc.[NB_XTRAmt] + fsc.[S_PostExtAmt] + fsc.[NB_MDPAmt] + fsc.[NB_LaserAmt] + fsc.[S_SurAmt] + fsc.[S_PRPAmt]) AS 'TotalMembershipRevenue',
       SUM(fsc.[RetailAmt]) AS 'RetailRevenue',
       SUM(fsc.[NB_LaserAmt]) AS 'LaserRevenue',
	   SUM(fsc.[S_PostExtAmt]) AS 'PostExtRevenue',
	   SUM(fsc.[S_PRPAmt]) AS 'PRPRevenue'

FROM dbo.Lead l
	OUTER APPLY dbo.fnIsInvalidLead(l.id) fil
    INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
        ON l.Id = dc.SFDC_LeadID
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		ON fl.ContactKey = dc.ContactKey
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
        ON ctr.CenterNumber = COALESCE(l.CenterNumber__c, l.CenterID__c,'100')
		AND ctr.Active = 'Y'
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
        ON ct.CenterTypeKey = ctr.CenterTypeKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fsc
        ON fsc.contactkey = dc.ContactKey
		AND fsc.ExtendedPrice <> 0
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds
		ON ds.SourceKey = fl.SourceKey
WHERE l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'new', 'converted', 'scheduled', 'consultation', 'pursuing'  )
      AND ct.CenterTypeDescription <> 'Surgery'
      AND ISNULL(l.IsDeleted, 0) = 0
	  AND ISNULL(fil.IsInvalidLead,0) = 0

GROUP BY dc.SFDC_LeadID,
       dc.CreationDate,
	   ISNULL(ISNULL(l.CenterNumber__c,l.CenterID__c),'100'),
	   ISNULL(ct.CenterTypeDescription,'Unknown'),
	   ISNULL(ds.OwnerType,'Unknown'),
	   ISNULL(ds.CampaignName,'Unknown'),
	   ISNULL(l.OriginalCampaignID__c,'Unknown'),
	   ISNULL(l.Source_Code_Legacy__c,'Unknown'),
	   ISNULL(ds.Level02Location,'Unknown')
GO
