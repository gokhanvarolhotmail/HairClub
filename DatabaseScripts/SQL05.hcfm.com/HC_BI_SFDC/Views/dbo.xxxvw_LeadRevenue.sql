/* CreateDate: 07/22/2020 14:16:27.793 , ModifyDate: 01/22/2021 11:54:26.133 */
GO
CREATE VIEW [dbo].[xxxvw_LeadRevenue]

AS

SELECT dc.SFDC_LeadID,
       MIN(dc.CreationDate) AS 'CreatedDate',
	   SUM((fsc.[NB_TradAmt] + fsc.[NB_GradAmt])) AS 'XtrandsPlusRevenue',
       SUM(fsc.[NB_ExtAmt] + fsc.S_PostExtAmt) AS 'EXTRevenue',
       SUM(fsc.[NB_XTRAmt]) AS 'XtrandsRevenue',
       SUM(fsc.[NB_MDPAmt]) AS 'RestorInkRevenue',
       SUM(fsc.[S_SurAmt]) AS 'SurgeryRevenue',
       SUM(fsc.[NetMembershipAmt]) AS 'TotalMembershipRevenue',
       SUM(fsc.[RetailAmt]) AS 'RetailRevenue',
       SUM(fsc.LaserAmt) AS 'LaserRevenue'

FROM dbo.Lead l
    INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
        ON l.Id = dc.SFDC_LeadID
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
        ON ctr.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
        ON ct.CenterTypeKey = ctr.CenterTypeKey
    LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fsc
        ON fsc.contactkey = dc.ContactKey
WHERE l.Status IN (  'Lead', 'Client', 'HWLead', 'HWClient', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION')
      AND ct.CenterTypeDescription <> 'Surgery'
      AND ISNULL(l.IsDeleted, 0) = 0
	  AND l.ReportCreateDate__c >= '01/01/2020'
GROUP BY dc.SFDC_LeadID
GO
