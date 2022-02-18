/* CreateDate: 04/09/2021 08:05:55.570 , ModifyDate: 04/09/2021 08:06:46.850 */
GO
/*
NOTES
***************************
Lead revenue for Cubes
***************************

	04/09/2020	KMurdoch	Initial Creation
*/




CREATE VIEW [dbo].[vwLeadRevenue]

AS

SELECT
		l.Id AS 'LeadID',
		fl.ContactKey AS 'ContactKey',
		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END AS 'LeadName',
		CAST(l.CreatedDate AS DATE) AS 'LeadCreateDate',
		ctr.CenterNumber AS 'LeadCenterNumber',
		ctr.CenterDescription AS 'LeadCenterDescription',
		ct.CenterTypeDescription AS 'LeadCenterType',
		SUM(fsc.[NB_GradAmt] + fsc.[NB_ExtAmt] + fsc.[NB_TradAmt]
			+ fsc.[NB_XTRAmt] + fsc.[S_PostExtAmt] + fsc.[NB_MDPAmt] + fsc.[NB_LaserAmt] + fsc.[S_SurAmt] + fsc.[S_PRPAmt]) AS 'NewBusinessRevenue',
		SUM((fsc.[NB_TradAmt] + fsc.[NB_GradAmt])) AS 'XtrandsPlusRevenue',
		SUM(fsc.[NB_ExtAmt]) AS 'EXTRevenue',
		SUM(fsc.[NB_XTRAmt]) AS 'XtrandsRevenue',
		SUM(fsc.[NB_MDPAmt]) AS 'RestorInkRevenue',
		SUM(fsc.[S_SurAmt]) AS 'SurgeryRevenue',
		SUM(fsc.[RetailAmt]) AS 'RetailRevenue',
		SUM(fsc.[NB_LaserAmt]) AS 'LaserRevenue',
		SUM(fsc.[S_PostExtAmt]) AS 'PostExtRevenue',
		SUM(fsc.[S_PRPAmt]) AS 'PRPRevenue'
FROM HC_BI_SFDC.dbo.Lead l
	OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.id) fil
    INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
        ON l.Id = dc.SFDC_LeadID
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		ON fl.ContactKey = dc.ContactKey
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
        ON ctr.CenterNumber = ISNULL(ISNULL(l.CenterNumber__c, l.CenterID__c),'100')
		AND ctr.Active = 'Y'
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
        ON ct.CenterTypeKey = ctr.CenterTypeKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fsc
        ON fsc.contactkey = dc.ContactKey
		AND fsc.ExtendedPrice <> 0
WHERE l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'new', 'converted', 'scheduled', 'consultation', 'pursuing'  )
      AND ct.CenterTypeDescription <> 'Surgery'
      AND ISNULL(l.IsDeleted, 0) = 0
	  AND ISNULL(fil.IsInvalidLead,0) = 0

GROUP BY
		l.Id,
		fl.ContactKey ,
		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END,
		CAST(l.CreatedDate AS DATE),
		ctr.CenterNumber,
		ctr.CenterDescription,
		ct.CenterTypeDescription
GO
