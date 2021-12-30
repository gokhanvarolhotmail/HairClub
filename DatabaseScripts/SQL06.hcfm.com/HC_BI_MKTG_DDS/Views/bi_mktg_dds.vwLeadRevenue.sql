/* CreateDate: 04/19/2021 13:30:31.347 , ModifyDate: 04/19/2021 13:30:31.347 */
GO
/*
NOTES
***************************
Lead revenue for Cubes
***************************

	04/09/2020	KMurdoch	Initial Creation
	04/15/2021  KMurdoch    Broke out NBLaserAmount from NB Revenue
*/




CREATE VIEW [bi_mktg_dds].[vwLeadRevenue]
AS
SELECT l.Id AS 'LeadID',
       dc.ContactKey AS 'ContactKey',
       l.ReportCreateDate__c AS 'LeadCreateDate',
       l.LastName + CASE
                        WHEN l.FirstName IS NOT NULL THEN
                            ', ' + l.FirstName
                        ELSE
                            ''
                    END AS 'LeadName',
       SUM(ISNULL(fsc.[NB_GradAmt], 0) + ISNULL(fsc.[NB_ExtAmt], 0) + ISNULL(fsc.[NB_TradAmt], 0)
           + ISNULL(fsc.[NB_XTRAmt], 0) + ISNULL(fsc.[S_PostExtAmt], 0) + ISNULL(fsc.[NB_MDPAmt], 0)
           + ISNULL(fsc.[S_SurAmt], 0) + ISNULL(fsc.[S_PRPAmt], 0)
          ) AS 'NewBusinessRevenue',
	   SUM(ISNULL(fsc.[NB_LaserAmt],0)) AS 'NBLaserRevenue',
       SUM(ISNULL(fsc.[PCP_NB2Amt], 0)) AS 'PCPMemberRevenue',
       SUM(ISNULL(fsc.[PCP_LaserAmt], 0)) AS 'PCPLaserRevenue',
       SUM(ISNULL(fsc.[RetailAmt], 0)) AS 'RetailRevenue',
       SUM(ISNULL(fsc.[ServiceAmt], 0)) AS 'ServiceRevenue'
FROM HC_BI_SFDC.dbo.Lead l
    OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
    INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
        ON l.Id = dc.SFDC_LeadID
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fsc
        ON fsc.ContactKey = dc.ContactKey
           AND fsc.ExtendedPrice <> 0
WHERE l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'new', 'converted', 'scheduled', 'consultation', 'pursuing' )
      AND l.Lead_Activity_Status__c <> 'Invalid'
      AND ISNULL(l.IsDeleted, 0) = 0
      AND ISNULL(fil.IsInvalidLead, 0) = 0
--AND l.ReportCreateDate__c >= '01/01/2018'
GROUP BY l.Id,
         dc.ContactKey,
         l.ReportCreateDate__c,
         l.LastName + CASE
                          WHEN l.FirstName IS NOT NULL THEN
                              ', ' + l.FirstName
                          ELSE
                              ''
                      END;
GO
