/* CreateDate: 02/12/2021 11:39:59.170 , ModifyDate: 02/26/2021 07:50:03.557 */
GO
/*
NOTES
***************************
VIEW OF LEADS FOR DATORAMA
***************************
	01/05/2021	KMurdoch	Added a join to DimSource for records where there is a source but no CampaignID
	01/07/2021  KMurdoch    Added a check for active center in join
	01/08/2021	KMurdoch	Modified derivation of Ownertype making DimSource primary
	01/22/2021  KMurdoch    Added or join to ConvertedContactID with Task, WhoID
	01/29/2021  KMurdoch    Changed the user join to be a left outer join
	02/19/2021  KMurdoch    Modified link to campaign to put 'Unknown' into the column if no campaign ID exists.
	02/23/2021  KMurdoch    Fixed CenterNumber join to reflect null center numbers
	02/25/2021	KMurdoch	Changed derivation of OwnerType from Campaign first to DimSource first


*/





CREATE VIEW [dbo].[vw_DRLead]
AS
SELECT
		l.Id AS 'LeadID'
,		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END AS 'LeadName'
,		d.FullDate AS 'LeadCreateDate'
,		ctr.CenterNumber AS 'LeadCenterNumber'
,		ctr.CenterDescription AS 'LeadCenterDescription'
,		ct.CenterTypeDescription AS 'LeadCenterType'
,		dc.DMARegion AS 'LeadDMARegion'
,		ISNULL(dmz.DMA_Name_Nielsen,ctr.DMADescription) AS 'LeadDMA'
,		CASE WHEN LEN(l.PostalCode) > 5 THEN l.PostalCode ELSE RIGHT('0'+CAST(l.PostalCode AS VARCHAR(5)),5) END AS 'LeadPostalCode'
,		l.Country AS 'LeadCountry'
,		l.[Status] AS 'LeadStatus'
,		ISNULL(CONVERT(VARCHAR, l.Age__c), '') AS 'LeadAge'
,		ISNULL(l.AgeRange__c, '') AS 'LeadAgeRange'
,		COALESCE(o_T.LeadOncGender__c, l.Gender__c) AS 'LeadGender'
,		l.Language__c AS 'LeadLanguage'
,		ISNULL(CASE WHEN o_T.LeadOncEthnicity__c IS NULL THEN l.Ethnicity__c ELSE o_T.LeadOncEthnicity__c END, '') AS 'LeadEthnicity'
,		ISNULL(CASE WHEN o_T.MaritalStatus__c IS NULL THEN l.MaritalStatus__c ELSE o_T.MaritalStatus__c END, '') AS 'LeadMaritalStatus'
,		ISNULL(CASE WHEN o_T.Occupation__c IS NULL THEN l.Occupation__c ELSE o_T.Occupation__c END, '') AS 'LeadOccupation'
,		ISNULL(CASE WHEN o_T.DISC__c IS NULL THEN l.DISC__c ELSE o_T.DISC__c END, '') AS 'LeadDISC'
,		ISNULL(ISNULL(CASE WHEN o_T.NorwoodScale__c IS NULL THEN l.NorwoodScale__c ELSE o_T.NorwoodScale__c END,
						CASE WHEN o_T.LudwigScale__c IS NULL THEN l.LudwigScale__c ELSE o_T.LudwigScale__c END),'') AS 'LeadHairLossScale'
--,		ISNULL(CASE WHEN o_T.SolutionOffered__c IS NULL THEN l.SolutionOffered__c ELSE o_T.SolutionOffered__c END, '') AS 'SolutionOffered'
--,		ISNULL(o_T.NoSaleReason__c, '') AS 'NoSaleReason'
--,		ISNULL(o_T.SaleTypeDescription__c, '') AS 'SaleType'
--,		CASE ISNULL(CASE WHEN o_T.SolutionOffered__c IS NULL THEN l.SolutionOffered__c ELSE o_T.SolutionOffered__c END, '')
--			WHEN 'Extreme Therapy' THEN 'EXT'
--			WHEN 'Hair' THEN 'XTRPlus'
--			WHEN 'MDP' THEN 'RestorInk'
--			WHEN 'Restorative' THEN 'SUR'
--			WHEN 'RestorInk' THEN 'RestorInk'
--			WHEN 'Surgery' THEN 'SUR'
--			WHEN 'Xtrands' THEN 'XTR'
--			WHEN 'Xtrands+' THEN 'XTRPlus'
--			WHEN '' THEN o_T.BusinessSegment
--		END AS 'BusinessSegmentOfferedOrSold'
--,		ISNULL(l.HairLossExperience__c, '') AS 'HairLossExperience'
--,		ISNULL(l.HairLossFamily__c, '') AS 'HairLossInFamily'
--,		ISNULL(l.HairLossProductUsed__c, '') AS 'HairLossProductUsed'
--,		ISNULL(l.HairLossProductOther__c, '') AS 'HairLossProductOther'
--,		ISNULL(l.HairLossSpot__c, '') AS 'HairLossSpot'
,		ISNULL(l.GCLID__c, '') AS 'GCLID'
,		COALESCE(l.OriginalCampaignID__c,l.RecentCampaignID__c,l.id) AS 'CampaignKey'
,		COALESCE(o_Oc.Name, o_Rc.Name,'Unknown') AS 'CampaignName'
,		COALESCE(o_Oc.CampaignType__c,o_Rc.CampaignType__c,'Unknown') AS 'CampaignType'
,		COALESCE(o_Oc.Type,osrc.OwnerType,'Unknown') AS 'CampaignAgency'
,		COALESCE(o_Oc.Gender__c,o_Rc.Gender__c,'Unknown') AS 'CampaignGender'
,		COALESCE(o_Oc.Channel__c,o_Rc.Channel__c,'Unknown') AS 'CampaignChannel'
,		COALESCE(o_Oc.Language__c,o_Rc.Language__c,'Unknown') AS 'CampaignLanguage'
,		COALESCE(o_Oc.Media__c,o_Rc.Media__c,'Unknown') AS 'CampaignMedia'
,		COALESCE(o_Oc.Format__c, o_Rc.Format__c,'Unknown') AS 'CampaignFormat'
,		COALESCE(o_Oc.Location__c,o_Rc.Location__c,'Unknown') AS 'CampaignLocation'
,		COALESCE(o_Oc.Source__c,o_Rc.Source__c,'Unknown') AS 'CampaignCreative'
,		COALESCE(o_Oc.PromoCodeName__c,o_Rc.PromoCodeName__c,'Unknown') AS 'CampaignPromoCode'
,		COALESCE(o_Oc.Status,o_Rc.Status,'Unknown') AS 'CampaignStatus'
,		COALESCE(o_Oc.SourceCode_L__c,o_Rc.SourceCode_L__c,'Unknown') AS 'CampaignSourceCode'
--,		l.RecentCampaignID__c AS 'RecentCampaignKey'
--,		o_Rc.Name AS 'RecentCampaignName'
--,		o_Rc.CampaignType__c AS 'RecentCampaignType'
--,		ISNULL(rsrc.OwnerType,ISNULL(o_Rc.Type,'')) AS 'RecentCampaignAgency'
--,		o_Rc.Gender__c AS 'RecentCampaignGender'
--,		o_Rc.Channel__c AS 'RecentCampaignChannel'
--,		o_Rc.Language__c AS 'RecentCampaignLanguage'
--,		o_Rc.Media__c AS 'RecentCampaignMedia'
--,		o_Rc.Format__c AS 'RecentCampaignFormat'
--,		o_Rc.Location__c AS 'RecentCampaignLocation'
--,		o_Rc.Source__c AS 'RecentCampaignCreative'
--,		o_Rc.PromoCodeName__c AS 'RecentCampaignPromoCode'
--,		o_Rc.Status AS 'RecentCampaignStatus'
--,		o_Rc.SourceCode_L__c AS 'RecentCampaignSourceCode'
,		fl.Leads AS 'Leads'
,		fl.Appointments AS 'LeadtoAppointments'
,		fl.Shows AS 'LeadtoShows'
,		fl.Sales AS 'LeadtoSales'
FROM	Lead l
		OUTER APPLY dbo.fnIsInvalidLead(l.id) fil
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = CAST(l.ReportCreateDate__c AS DATE)
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = COALESCE(l.CenterNumber__c, l.CenterID__c,'100')
			AND ctr.Active = 'Y'
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
			ON ct.CenterTypeKey = ctr.CenterTypeKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
			ON l.Id = dc.SFDC_LeadID
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
			ON fl.ContactKey = dc.ContactKey
		LEFT OUTER JOIN HC_BI_Reporting.dbo.lkpDMAtoZipCode dmz
			ON l.PostalCode = dmz.ZipCode
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource rsrc
			ON l.RecentSourceCode__c = rsrc.SourceSSID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource osrc
			ON l.Source_Code_Legacy__c = osrc.SourceSSID
		OUTER APPLY (
			SELECT	TOP 1
					t.LeadOncGender__c
			,		t.LeadOncBirthday__c
			,		t.Occupation__c
			,		t.LeadOncEthnicity__c
			,		t.MaritalStatus__c
			,		t.NorwoodScale__c
			,		t.LudwigScale__c
			,		t.LeadOncAge__c
			,		t.PriceQuoted__c
			,		t.SolutionOffered__c
			,		t.NoSaleReason__c
			,		t.DISC__c
			,		t.SaleTypeCode__c
			,		t.SaleTypeDescription__c
			,		ISNULL(st.BusinessSegment, 'Unknown') AS 'BusinessSegment'
			FROM	Task t
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType st
						ON st.SalesTypeSSID = t.SaleTypeCode__c
			WHERE	t.WhoId = l.Id OR t.whoid = l.ConvertedContactId
					AND ISNULL(t.Result__c, '') IN ( 'Show Sale', 'Show No Sale' )
					AND ISNULL(t.IsDeleted, 0) = 0
			ORDER BY t.ActivityDate DESC
		) o_T -- Last Show
		OUTER APPLY (
			SELECT	oc.Name
			,		ISNULL(oc.CampaignType__c, '') AS 'CampaignType__c'
			,		ISNULL(oc.Type, '') AS 'Type'
			,		ISNULL(oc.CommunicationType__c, '') AS 'CommunicationType__c'
			,		ISNULL(oc.Channel__c, '') AS 'Channel__c'
			,		ISNULL(oc.Language__c, '') AS 'Language__c'
			,		ISNULL(oc.Media__c, '') AS 'Media__c'
			,		ISNULL(oc.Format__c, '') AS 'Format__c'
			,		ISNULL(oc.Location__c, '') AS 'Location__c'
			,		ISNULL(oc.Source__c, '') AS 'Source__c'
			,		ISNULL(oc.Goal__c, '') AS 'Goal__c'
			,		ISNULL(oc.PromoCodeName__c, '') AS 'PromoCodeName__c'
			,		ISNULL(oc.PromoCodeDisplay__c, '') AS 'PromoCodeDisplay__c'
			,		oc.Status
			,		oc.StartDate
			,		oc.EndDate
			,		ISNULL(oc.Gender__c, '') AS 'Gender__c'
			,		ISNULL(oc.URLDomain__c, '') AS 'URLDomain__c'
			,		ISNULL(oc.SourceCode_L__c, '') AS 'SourceCode_L__c'

			FROM	Campaign oc
			WHERE	oc.Id = l.OriginalCampaignID__c
		) o_Oc -- Original Campaign Attributes
		OUTER APPLY (
			SELECT	rc.Name
			,		ISNULL(rc.CampaignType__c, '') AS 'CampaignType__c'
			,		ISNULL(rc.Type, '') AS 'Type'
			,		ISNULL(rc.CommunicationType__c, '') AS 'CommunicationType__c'
			,		ISNULL(rc.Channel__c, '') AS 'Channel__c'
			,		ISNULL(rc.Language__c, '') AS 'Language__c'
			,		ISNULL(rc.Media__c, '') AS 'Media__c'
			,		ISNULL(rc.Format__c, '') AS 'Format__c'
			,		ISNULL(rc.Location__c, '') AS 'Location__c'
			,		ISNULL(rc.Source__c, '') AS 'Source__c'
			,		ISNULL(rc.Goal__c, '') AS 'Goal__c'
			,		ISNULL(rc.PromoCodeName__c, '') AS 'PromoCodeName__c'
			,		ISNULL(rc.PromoCodeDisplay__c, '') AS 'PromoCodeDisplay__c'
			,		rc.Status
			,		rc.StartDate
			,		rc.EndDate
			,		ISNULL(rc.Gender__c, '') AS 'Gender__c'
			,		ISNULL(rc.URLDomain__c, '') AS 'URLDomain__c'
			,		ISNULL(rc.SourceCode_L__c, '') AS 'SourceCode_L__c'
			FROM	Campaign rc
			WHERE	rc.Id = l.RecentCampaignID__c
		) o_Rc -- Recent Campaign Attributes
WHERE	l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'new', 'converted', 'scheduled', 'consultation', 'pursuing' )
		AND ct.CenterTypeDescription <> 'Surgery'
		AND ISNULL(l.IsDeleted, 0) = 0
		AND ISNULL(fil.IsInvalidLead,0) = 0
GO
