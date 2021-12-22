/*
NOTES
***************************
VIEW OF LEADS FOR DATORAMA
***************************

	01/05/2020	KMurdoch	Fixed TotalMembershipRevenue to be in alignment with Net NB1plusSur in the Cubes
	01/05/2020	KMurdoch	Changed Laser Revenue to be NB_Laser; Added PostEXT & PRP Revenue Amounts
	01/05/2020  KMurdoch	Added Campaign Name
	01/05/2020	KMurdoch	Added CenterNumber and CenterType
	01/07/2020  KMurdoch    Added a check for active center in join
	01/25/2021  KMurdoch    Added Location
	02/17/2021  KMurdoch    Aligned with other Datorama views
	02/19/2021  KMurdoch    Modified link to campaign to put 'Unknown' into the column if no campaign ID exists.
	02/23/2021  KMurdoch    Created new view to view data by Sales Date
*/




CREATE VIEW [dbo].[vw_DRRevenueByDate]

AS

SELECT
		l.Id AS 'LeadID',
		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END AS 'LeadName',
		CAST(dd.FullDate AS DATE) AS 'SaleDate',
		ctr.CenterNumber AS 'LeadCenterNumber',
		ctr.CenterDescription AS 'LeadCenterDescription',
		ct.CenterTypeDescription AS 'LeadCenterType',
		dc.DMARegion AS 'LeadDMARegion',
		ISNULL(dmz.DMA_Name_Nielsen,ctr.DMADescription) AS 'LeadDMA',
		CASE WHEN LEN(l.PostalCode) > 5 THEN l.PostalCode ELSE RIGHT('0'+CAST(l.PostalCode AS VARCHAR(5)),5) END AS 'LeadPostalCode',
		l.Country AS 'LeadCountry',
		l.Status AS 'LeadStatus',
		ISNULL(CONVERT(VARCHAR, l.Age__c), '') AS 'LeadAge',
		ISNULL(l.AgeRange__c, 'Unknown') AS 'LeadAgeRange',
		ISNULL(l.Gender__c,'Unknown') AS 'LeadGender',
		ISNULL(l.Language__c,'Unknown') AS 'LeadLanguage',
	    ISNULL(c.id,l.id) AS 'CampaignID',
		ISNULL(c.Name,'Unknown') AS 'CampaignName',
		ISNULL(c.CampaignType__c,'Unknown') AS 'CampaignType',
		ISNULL(c.Type,'Unknown') AS 'CampaignAgency',
		ISNULL(c.Gender__c,'Unknown') AS 'CampaignGender',
		ISNULL(c.Channel__c,'Unknown') AS 'CampaignChannel',
		ISNULL(c.Language__c,'Unknown') AS 'CampaignLanguage',
		ISNULL(c.Media__c,'Unknown') AS 'CampaignMedia',
		ISNULL(c.Format__c,'Unknown') AS 'CampaignFormat',
		ISNULL(c.Location__c,'Unknown') AS 'CampaignLocation',
		ISNULL(c.Source__c,'Unknown') AS 'CampaignCreative',
		ISNULL(c.PromoCodeName__c,'Unknown') AS 'CampaignPromoCode',
		ISNULL(c.Status,'Unknown') AS 'CampaignStatus',
		ISNULL(c.SourceCode_L__c,'Unknown') AS 'CampaignSourceCode',
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

FROM dbo.Lead l
	OUTER APPLY dbo.fnIsInvalidLead(l.id) fil
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
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
		ON fsc.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_SFDC.dbo.Campaign c
		ON l.OriginalCampaignID__c = c.Id
	LEFT OUTER JOIN HC_BI_Reporting.dbo.lkpDMAtoZipCode dmz
		ON l.PostalCode = dmz.ZipCode
WHERE l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'new', 'converted', 'scheduled', 'consultation', 'pursuing'  )
      AND ct.CenterTypeDescription <> 'Surgery'
      AND ISNULL(l.IsDeleted, 0) = 0
	  AND ISNULL(fil.IsInvalidLead,0) = 0

GROUP BY
		l.Id,
		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END,
		CAST(dd.FullDate AS DATE),
		ctr.CenterNumber,
		ctr.CenterDescription,
		ct.CenterTypeDescription,
		dc.DMARegion,
		ISNULL(dmz.DMA_Name_Nielsen,ctr.DMADescription),
		CASE WHEN LEN(l.PostalCode) > 5 THEN l.PostalCode ELSE RIGHT('0'+CAST(l.PostalCode AS VARCHAR(5)),5) END,
		l.Country,
		l.[Status],
		ISNULL(CONVERT(VARCHAR, l.Age__c), ''),
		ISNULL(l.AgeRange__c, 'Unknown') ,
		ISNULL(l.Gender__c,'Unknown') ,
		ISNULL(l.Language__c,'Unknown') ,
	    ISNULL(c.id,l.id) ,
		ISNULL(c.Name,'Unknown') ,
		ISNULL(c.CampaignType__c,'Unknown') ,
		ISNULL(c.Type,'Unknown') ,
		ISNULL(c.Gender__c,'Unknown') ,
		ISNULL(c.Channel__c,'Unknown') ,
		ISNULL(c.Language__c,'Unknown') ,
		ISNULL(c.Media__c,'Unknown') ,
		ISNULL(c.Format__c,'Unknown') ,
		ISNULL(c.Location__c,'Unknown') ,
		ISNULL(c.Source__c,'Unknown') ,
		ISNULL(c.PromoCodeName__c,'Unknown') ,
		ISNULL(c.Status,'Unknown') ,
		ISNULL(c.SourceCode_L__c,'Unknown')
