/* CreateDate: 12/21/2020 13:31:09.920 , ModifyDate: 12/21/2020 13:31:17.287 */
GO
CREATE VIEW [dbo].[vw_SourceRevenue]

AS

SELECT l.Source_Code_Legacy__c,
	   SUM(ISNULL(fsc.[NB_TradAmt],0) + ISNULL(fsc.[NB_GradAmt],0)) AS 'XtrandsPlusRevenue',
       SUM(ISNULL(fsc.[NB_ExtAmt],0) + ISNULL(fsc.S_PostExtAmt,0)) AS 'EXTRevenue',
       SUM(ISNULL(fsc.[NB_XTRAmt],0)) AS 'XtrandsRevenue',
       SUM(ISNULL(fsc.[NB_MDPAmt],0)) AS 'RestorInkRevenue',
       SUM(ISNULL(fsc.[S_SurAmt],0)) AS 'SurgeryRevenue',
       SUM(ISNULL(fsc.[NB_GradAmt],0) + ISNULL(fsc.[NB_ExtAmt],0) + ISNULL(fsc.[NB_TradAmt],0) + ISNULL(fsc.[NB_XTRAmt],0)
					+ ISNULL(fsc.[S_PostExtAmt],0) + ISNULL(fsc.[NB_MDPAmt],0) + ISNULL(fsc.[NB_LaserAmt],0))  AS 'TotalMembershipRevenue',
       SUM(ISNULL(fsc.[RetailAmt],0)) AS 'RetailRevenue',
       SUM(ISNULL(fsc.LaserAmt,0)) AS 'LaserRevenue'

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
GROUP BY l.Source_Code_Legacy__c
GO
