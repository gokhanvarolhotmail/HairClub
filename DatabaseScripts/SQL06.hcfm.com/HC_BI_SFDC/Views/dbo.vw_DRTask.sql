/*
NOTES
***************************
VIEW OF LEADS FOR DATORAMA
***************************

	01/07/2021  KMurdoch    Added a check for active center in join
	01/08/2021  KMurdoch    Added Isnull to Owner Type
	01/08/2021	KMurdoch    Added join to DimSource as primary to derive OwnerType
	01/11/2021  KMurdoch    Modified Selection to handle null result codes
	01/21/2021  KMurdoch    Date Range is between '01/01/2020 and yesterday's date
	01/22/2021	KMurdoch	Added a Union to separate selects for Lead vs. Person Account
	01/25/2021  KMurdoch    Added CampaignID
	01/25/2021  KMurdoch    Added Location__c
	02/11/2021  KMurdoch    Modified join on campaign to use OriginalCampaignID rather than RecentCampaignID
	02/19/2021  KMurdoch    Modified link to campaign to put 'Unknown' into the column if no campaign ID exists.
	02/23/2021  KMurdoch    Fixed CenterNumber join to reflect null center numbers

*/







CREATE VIEW [dbo].[vw_DRTask]
AS
SELECT  t.ID AS 'TaskID'
,		t.ActivityDate AS 'ActivityDate'
,		l.Id AS 'LeadID'
,		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END AS 'LeadName'
,		t.CenterNumber__c AS 'TaskCenterNumber'
,		ctr.CenterDescription AS 'TaskCenterDescription'
,		ctrtype.CenterTypeDescription AS 'TaskCenterType'
,		ctr.DMARegion AS 'TaskDMARegion'
,		ctr.DMADescription AS 'TaskDMA'
--,		CASE WHEN LEN(l.PostalCode) > 5 THEN l.PostalCode ELSE RIGHT('0'+CAST(l.PostalCode AS VARCHAR(5)),5) END AS 'LeadPostalCode'
--,		l.Country AS 'LeadCountry'
--,		l.Status AS 'LeadStatus'
--,		l.Gender__c AS 'LeadGender'
,		t.Action__c AS 'TaskAction'
,		t.Result__c AS 'TaskResult'
,		ISNULL(c.id,t.Id) AS 'CampaignID'
,		ISNULL(c.Name, 'Unknown') AS 'CampaignName'
,		ISNULL(c.CampaignType__c, 'Unknown')  AS 'CampaignType'
,		ISNULL(c.Type,'Unknown') AS 'CampaignAgency'
,		ISNULL(c.Gender__c, 'Unknown')  AS 'CampaignGender'
,		ISNULL(c.Channel__c, 'Unknown')  AS 'CampaignChannel'
,		ISNULL(c.Language__c, 'Unknown')  AS 'CampaignLanguage'
,		ISNULL(c.Media__c, 'Unknown')  AS 'CampaignMedia'
,		ISNULL(c.Format__c, 'Unknown')  AS 'CampaignFormat'
,		ISNULL(c.Location__c, 'Unknown')  AS 'CampaignLocation'
,		ISNULL(c.Source__c, 'Unknown')  AS 'CampaignCreative'
,		ISNULL(c.PromoCodeName__c, 'Unknown')  AS 'CampaignPromoCode'
,		ISNULL(c.Status, 'Unknown')  AS 'CampaignStatus'
,		ISNULL(c.SourceCode_L__c, 'Unknown')  AS 'CampaignSourceCode'
,		ISNULL(l.Source_Code_Legacy__c, 'Unknown')  AS 'LeadSource'
--,		l.SolutionOffered__c AS 'SolutionOffered'
,        CASE
           WHEN t.Action__c IN ( 'Be back' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID', 'no show' )
						OR ISNULL(t.Result__c,'') = ''
                ) THEN
               1
           ELSE
               0
        END AS 'BeBack'
,        CASE
           WHEN t.Action__c IN ( 'Appointment', 'In House' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
                                 OR ISNULL(t.Result__c,'') = ''
                ) THEN
               1
           ELSE
               0
        END AS 'Appointment'
,	    CASE WHEN Result__c IN ('Show Sale','Show No Sale') THEN 1
		   ELSE 0
	    END AS 'Show'
,	    CASE WHEN Result__c IN ('Show Sale') THEN 1
		   ELSE 0
	    END AS 'Sale'

FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
		LEFT OUTER JOIN HC_BI_Reporting.dbo.lkpDMAtoZipCode dmz
			ON l.PostalCode = dmz.ZipCode
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = COALESCE(l.CenterNumber__c, l.CenterID__c,'100')
			AND ctr.Active = 'Y'
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ctrtype
			ON ctrtype.CenterTypeKey = ctr.CenterTypeKey
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign c
			ON l.OriginalCampaignID__c = c.Id
		--LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource src
		--	ON l.Source_Code_Legacy__c = src.SourceSSID



WHERE   LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
		AND (Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' ) OR ISNULL(Result__c,'') ='')
		AND t.ActivityDate BETWEEN '01/01/2020' AND DATEADD(dd,0, DATEDIFF(dd,0,GETUTCDATE()))
		AND ISNULL(t.IsDeleted, 0) = 0


UNION


SELECT  t.ID AS 'TaskID'
,		t.ActivityDate AS 'ActivityDate'
,		l.Id AS 'LeadID'
,		l.LastName + CASE WHEN l.FirstName IS NOT NULL THEN ', ' + l.FirstName ELSE '' END AS 'LeadName'
,		t.CenterNumber__c AS 'TaskCenterNumber'
,		ctr.CenterDescription AS 'TaskCenterDescription'
,		ctrtype.CenterTypeDescription AS 'TaskCenterType'
,		ctr.DMARegion AS 'TaskDMARegion'
,		ctr.DMADescription AS 'TaskDMA'
--,		CASE WHEN LEN(l.PostalCode) > 5 THEN l.PostalCode ELSE RIGHT('0'+CAST(l.PostalCode AS VARCHAR(5)),5) END AS 'LeadPostalCode'
--,		l.Country AS 'LeadCountry'
--,		l.Status AS 'LeadStatus'
--,		l.Gender__c AS 'LeadGender'
,		t.Action__c AS 'TaskAction'
,		t.Result__c AS 'TaskResult'
,		ISNULL(c.id,t.Id) AS 'CampaignID'
,		ISNULL(c.Name, 'Unknown') AS 'CampaignName'
,		ISNULL(c.CampaignType__c, 'Unknown')  AS 'CampaignType'
,		ISNULL(c.Type,'Unknown') AS 'CampaignAgency'
,		ISNULL(c.Gender__c, 'Unknown')  AS 'CampaignGender'
,		ISNULL(c.Channel__c, 'Unknown')  AS 'CampaignChannel'
,		ISNULL(c.Language__c, 'Unknown')  AS 'CampaignLanguage'
,		ISNULL(c.Media__c, 'Unknown')  AS 'CampaignMedia'
,		ISNULL(c.Format__c, 'Unknown')  AS 'CampaignFormat'
,		ISNULL(c.Location__c, 'Unknown')  AS 'CampaignLocation'
,		ISNULL(c.Source__c, 'Unknown')  AS 'CampaignCreative'
,		ISNULL(c.PromoCodeName__c, 'Unknown')  AS 'CampaignPromoCode'
,		ISNULL(c.Status, 'Unknown')  AS 'CampaignStatus'
,		ISNULL(c.SourceCode_L__c, 'Unknown')  AS 'CampaignSourceCode'
,		ISNULL(l.Source_Code_Legacy__c, 'Unknown')  AS 'LeadSource'
--,		l.SolutionOffered__c AS 'SolutionOffered'
,        CASE
           WHEN t.Action__c IN ( 'Be back' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID', 'no show' )
						OR ISNULL(t.Result__c,'') = ''
                ) THEN
               1
           ELSE
               0
        END AS 'Beback'
,        CASE
           WHEN t.Action__c IN ( 'Appointment', 'In House' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
                                 OR ISNULL(t.Result__c,'') = ''
                ) THEN
               1
           ELSE
               0
        END AS 'Appointment'
,	    CASE WHEN Result__c IN ('Show Sale','Show No Sale') THEN 1
		   ELSE 0
	    END AS 'Show'
,	    CASE WHEN Result__c IN ('Show Sale') THEN 1
		   ELSE 0
	    END AS 'Sale'
FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l							-----------------------------------
			ON l.ConvertedContactId = t.WhoId						----JOINS ON THE PERSON ACCOUNT
		LEFT OUTER JOIN HC_BI_Reporting.dbo.lkpDMAtoZipCode dmz		-----------------------------------
			ON l.PostalCode = dmz.ZipCode
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = COALESCE(l.CenterNumber__c, l.CenterID__c,'100')
			AND ctr.Active = 'Y'
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ctrtype
			ON ctrtype.CenterTypeKey = ctr.CenterTypeKey
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign c
			ON l.OriginalCampaignID__c = c.Id
		--LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource src
		--	ON l.Source_Code_Legacy__c = src.SourceSSID


WHERE   LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
		AND (Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' ) OR ISNULL(Result__c,'') ='')
		AND t.ActivityDate BETWEEN '01/01/2020' AND DATEADD(dd,0, DATEDIFF(dd,0,GETUTCDATE()))
		AND ISNULL(t.IsDeleted, 0) = 0
