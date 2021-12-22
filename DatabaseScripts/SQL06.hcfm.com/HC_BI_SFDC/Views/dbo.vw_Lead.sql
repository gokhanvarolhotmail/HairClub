/* CreateDate: 10/29/2019 11:54:53.193 , ModifyDate: 02/05/2021 10:06:22.410 */
GO
/*
NOTES

	01/05/2021	KMurdoch	Added a join to DimSource for records where there is a source but no CampaignID
	01/07/2021  KMurdoch    Added a check for active center in join
	01/08/2021	KMurdoch	Modified derivation of Ownertype making DimSource primary
	01/22/2021  KMurdoch    Added or join to ConvertedContactID with Task, WhoID
	01/29/2021  KMurdoch    Changed the user join to be a left outer join


*/









CREATE VIEW [dbo].[vw_Lead]
AS
SELECT	d.FullDate AS 'CreatedDate'
,		d.MonthName AS 'MonthCreated'
,		d.YearNumber AS 'YearCreated'
,		d.DayOfWeekName
,		d.WeekNumber
,		ctr.CenterNumber
,		ctr.CenterDescription
,		ct.CenterTypeDescription AS 'CenterType'
,		l.Id AS 'SFDC_LeadID'
,		l.FirstName
,		l.LastName
,		l.Status
,		ISNULL(CONVERT(VARCHAR, l.Age__c), '') AS 'Age'
,		ISNULL(l.AgeRange__c, '') AS 'AgeRange'
,		ISNULL(CONVERT(VARCHAR(11), CAST(l.Birthday__c AS DATE), 101), '') AS 'Birthday'
,		COALESCE(o_T.LeadOncGender__c, l.Gender__c) AS 'Gender'
,		l.Language__c AS 'Language'
,		ISNULL(CASE WHEN o_T.LeadOncEthnicity__c IS NULL THEN l.Ethnicity__c ELSE o_T.LeadOncEthnicity__c END, '') AS 'Ethnicity'
,		ISNULL(CASE WHEN o_T.MaritalStatus__c IS NULL THEN l.MaritalStatus__c ELSE o_T.MaritalStatus__c END, '') AS 'MaritalStatus'
,		ISNULL(CASE WHEN o_T.Occupation__c IS NULL THEN l.Occupation__c ELSE o_T.Occupation__c END, '') AS 'Occupation'
,		ISNULL(CASE WHEN o_T.DISC__c IS NULL THEN l.DISC__c ELSE o_T.DISC__c END, '') AS 'DISC'
,		ISNULL(CASE WHEN o_T.NorwoodScale__c IS NULL THEN l.NorwoodScale__c ELSE o_T.NorwoodScale__c END, '') AS 'Norwood'
,		ISNULL(CASE WHEN o_T.LudwigScale__c IS NULL THEN l.LudwigScale__c ELSE o_T.LudwigScale__c END, '') AS 'Ludwig'
,		ISNULL(CASE WHEN o_T.SolutionOffered__c IS NULL THEN l.SolutionOffered__c ELSE o_T.SolutionOffered__c END, '') AS 'SolutionOffered'
,		ISNULL(o_T.PriceQuoted__c, 0) AS 'PriceQuoted'
,		ISNULL(o_T.NoSaleReason__c, '') AS 'NoSaleReason'
,		ISNULL(o_T.SaleTypeDescription__c, '') AS 'SaleType'
,		CASE ISNULL(CASE WHEN o_T.SolutionOffered__c IS NULL THEN l.SolutionOffered__c ELSE o_T.SolutionOffered__c END, '')
			WHEN 'Extreme Therapy' THEN 'EXT'
			WHEN 'Hair' THEN 'XTRPlus'
			WHEN 'MDP' THEN 'RestorInk'
			WHEN 'Restorative' THEN 'SUR'
			WHEN 'RestorInk' THEN 'RestorInk'
			WHEN 'Surgery' THEN 'SUR'
			WHEN 'Xtrands' THEN 'XTR'
			WHEN 'Xtrands+' THEN 'XTRPlus'
			WHEN '' THEN o_T.BusinessSegment
		END AS 'BusinessSegmentOfferedOrSold'
,		ISNULL(l.HairLossExperience__c, '') AS 'HairLossExperience'
,		ISNULL(l.HairLossFamily__c, '') AS 'HairLossInFamily'
,		ISNULL(l.HairLossProductUsed__c, '') AS 'HairLossProductUsed'
,		ISNULL(l.HairLossProductOther__c, '') AS 'HairLossProductOther'
,		ISNULL(l.HairLossSpot__c, '') AS 'HairLossSpot'
,		ISNULL(l.SiebelID__c, '') AS 'SiebelID'
,		ISNULL(l.GCLID__c, '') AS 'GCLID'
,		l.DoNotContact__c AS 'DoNotContact'
,		l.DoNotCall
,		l.DoNotEmail__c AS 'DoNotEmail'
,		l.DoNotMail__c AS 'DoNotMail'
,		l.DoNotText__c AS 'DoNotText'
,		ISNULL(u.UserCode__c, '') AS 'CreatedByUserCode'
,		ISNULL(u.FirstName,'Unknown') AS 'CreatedByFirstName'
,		ISNULL(u.LastName, 'Unknown') AS 'CreatedByLastName'
,		ISNULL(u.Department,'Unknown') AS 'CreatedByDepartment'
,		o_Oc.Name AS 'OriginalCampaignName'
,		o_Oc.CampaignType__c AS 'OriginalCampaignType'
,		ISNULL(osrc.OwnerType,ISNULL(o_Oc.Type,'Unknown')) AS 'OriginalType'
,		o_Oc.CommunicationType__c AS 'OriginalCampaignCommunicationType'
,		o_Oc.Gender__c AS 'OriginalCampaignGender'
,		o_Oc.Channel__c AS 'OriginalCampaignChannel'
,		o_Oc.Language__c AS 'OriginalCampaignLanguage'
,		o_Oc.Media__c AS 'OriginalCampaignMedia'
,		o_Oc.Format__c AS 'OriginalCampaignFormat'
,		o_Oc.Location__c AS 'OriginalCampaignLocation'
,		o_Oc.Source__c AS 'OriginalCampaignCreative'
,		o_Oc.Goal__c AS 'OriginalCampaignGoal'
,		o_Oc.PromoCodeName__c AS 'OriginalCampaignPromoCode'
,		o_Oc.PromoCodeDisplay__c AS 'OriginalCampaignPromoCodeDescription'
,		o_Oc.Status AS 'OriginalCampaignStatus'
,		o_Oc.StartDate AS 'OriginalCampaignStartDate'
,		o_Oc.EndDate AS 'OriginalCampaignEndDate'
,		o_Oc.TollFreeName__c AS 'OriginalCampaignTollFreeNumber'
,		o_Oc.DNIS__c AS 'OriginalCampaignDNIS'
,		o_Oc.TollFreeMobileName__c AS 'OriginalCampaignTollFreeMobileNumber'
,		o_Oc.DNISMobile__c AS 'OriginalCampaignDNISMobile'
,		o_Oc.URLDomain__c AS 'OriginalCampaignURL'
,		o_Oc.SourceCode_L__c AS 'OriginalCampaignSourceCode'
,		o_Oc.DPNCode__c AS 'OriginalCampaignDPNCode'
,		o_Oc.DWFCode__c AS 'OriginalCampaignDWFCode'
,		o_Oc.DWCCode__c AS 'OriginalCampaignDWCCode'
,		o_Oc.MPNCode__c AS 'OriginalCampaignMPNCode'
,		o_Oc.MWFCode__c AS 'OriginalCampaignMWFCode'
,		o_Oc.MWCCode__c AS 'OriginalCampaignMWCCode'
,		o_Oc.WebCode__c AS 'OriginalCampaignWebCode'
,		o_Rc.Name AS 'RecentCampaignName'
,		o_Rc.CampaignType__c AS 'RecentCampaignType'
,		ISNULL(rsrc.OwnerType,ISNULL(o_Rc.Type,'')) AS 'RecentType'
,		o_Rc.CommunicationType__c AS 'RecentCampaignCommunicationType'
,		o_Rc.Gender__c AS 'RecentCampaignGender'
,		o_Rc.Channel__c AS 'RecentCampaignChannel'
,		o_Rc.Language__c AS 'RecentCampaignLanguage'
,		o_Rc.Media__c AS 'RecentCampaignMedia'
,		o_Rc.Format__c AS 'RecentCampaignFormat'
,		o_Rc.Location__c AS 'RecentCampaignLocation'
,		o_Rc.Source__c AS 'RecentCampaignCreative'
,		o_Rc.Goal__c AS 'RecentCampaignGoal'
,		o_Rc.PromoCodeName__c AS 'RecentCampaignPromoCode'
,		o_Rc.PromoCodeDisplay__c AS 'RecentCampaignPromoCodeDescription'
,		o_Rc.Status AS 'RecentCampaignStatus'
,		o_Rc.StartDate AS 'RecentCampaignStartDate'
,		o_Rc.EndDate AS 'RecentCampaignEndDate'
,		o_Rc.TollFreeName__c AS 'RecentCampaignTollFreeNumber'
,		o_Rc.DNIS__c AS 'RecentCampaignDNIS'
,		o_Rc.TollFreeMobileName__c AS 'RecentCampaignTollFreeMobileNumber'
,		o_Rc.DNISMobile__c AS 'RecentCampaignDNISMobile'
,		o_Rc.URLDomain__c AS 'RecentCampaignURL'
,		o_Rc.SourceCode_L__c AS 'RecentCampaignSourceCode'
,		o_Rc.DPNCode__c AS 'RecentCampaignDPNCode'
,		o_Rc.DWFCode__c AS 'RecentCampaignDWFCode'
,		o_Rc.DWCCode__c AS 'RecentCampaignDWCCode'
,		o_Rc.MPNCode__c AS 'RecentCampaignMPNCode'
,		o_Rc.MWFCode__c AS 'RecentCampaignMWFCode'
,		o_Rc.MWCCode__c AS 'RecentCampaignMWCCode'
,		o_Rc.WebCode__c AS 'RecentCampaignWebCode'
,		l.PostalCode AS 'PostalCode'
,		fl.Leads AS 'Leads'
,		fl.Appointments AS 'Appointments'
,		fl.Shows AS 'Shows'
,		fl.Sales AS 'Sales'
,		dc.DMARegion AS 'DMARegion'
,		dc.DMADescription AS 'LeadDMA'
,		l.Country AS 'Country'
FROM	Lead l
		OUTER APPLY dbo.fnIsInvalidLead(l.id) fil
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = CAST(l.ReportCreateDate__c AS DATE)
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
			AND ctr.Active = 'Y'
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
			ON ct.CenterTypeKey = ctr.CenterTypeKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
			ON l.Id = dc.SFDC_LeadID
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
			ON fl.ContactKey = dc.ContactKey
		LEFT OUTER JOIN [User] u
			ON u.Id = l.CreatedById
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
			,		ISNULL(oc.TollFreeName__c, '') AS 'TollFreeName__c'
			,		ISNULL(oc.DNIS__c, '') AS 'DNIS__c'
			,		ISNULL(oc.TollFreeMobileName__c, '') AS 'TollFreeMobileName__c'
			,		ISNULL(oc.DNISMobile__c, '') AS 'DNISMobile__c'
			,		ISNULL(oc.URLDomain__c, '') AS 'URLDomain__c'
			,		ISNULL(oc.SourceCode_L__c, '') AS 'SourceCode_L__c'
			,		ISNULL(oc.DPNCode__c, '') AS 'DPNCode__c'
			,		ISNULL(oc.DWFCode__c, '') AS 'DWFCode__c'
			,		ISNULL(oc.DWCCode__c, '') AS 'DWCCode__c'
			,		ISNULL(oc.MPNCode__c, '') AS 'MPNCode__c'
			,		ISNULL(oc.MWFCode__c, '') AS 'MWFCode__c'
			,		ISNULL(oc.MWCCode__c, '') AS 'MWCCode__c'
			,		ISNULL(oc.WebCode__c, '') AS 'WebCode__c'
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
			,		ISNULL(rc.TollFreeName__c, '') AS 'TollFreeName__c'
			,		ISNULL(rc.DNIS__c, '') AS 'DNIS__c'
			,		ISNULL(rc.TollFreeMobileName__c, '') AS 'TollFreeMobileName__c'
			,		ISNULL(rc.DNISMobile__c, '') AS 'DNISMobile__c'
			,		ISNULL(rc.URLDomain__c, '') AS 'URLDomain__c'
			,		ISNULL(rc.SourceCode_L__c, '') AS 'SourceCode_L__c'
			,		ISNULL(rc.DPNCode__c, '') AS 'DPNCode__c'
			,		ISNULL(rc.DWFCode__c, '') AS 'DWFCode__c'
			,		ISNULL(rc.DWCCode__c, '') AS 'DWCCode__c'
			,		ISNULL(rc.MPNCode__c, '') AS 'MPNCode__c'
			,		ISNULL(rc.MWFCode__c, '') AS 'MWFCode__c'
			,		ISNULL(rc.MWCCode__c, '') AS 'MWCCode__c'
			,		ISNULL(rc.WebCode__c, '') AS 'WebCode__c'
			FROM	Campaign rc
			WHERE	rc.Id = l.RecentCampaignID__c
		) o_Rc -- Recent Campaign Attributes
WHERE	l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'new', 'converted', 'scheduled', 'consultation', 'pursuing' )
		AND ct.CenterTypeDescription <> 'Surgery'
		AND ISNULL(l.IsDeleted, 0) = 0
		AND ISNULL(fil.IsInvalidLead,0) = 0
GO
