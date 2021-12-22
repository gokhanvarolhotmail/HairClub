/*
NOTES

	01/07/2021  KMurdoch    Added a check for active center in join
	01/08/2021  KMurdoch    Added Isnull to Owner Type
	01/08/2021	KMurdoch    Added join to DimSource as primary to derive OwnerType
	01/11/2021  KMurdoch    Modified Selection to handle null result codes
	01/21/2021  KMurdoch    Date Range is between '01/01/2020 and yesterday's date
	01/22/2021	KMurdoch	Added a Union to separate selects for Lead vs. Person Account
	01/25/2021  KMurdoch    Added CampaignID
	01/25/2021  KMurdoch    Added Location__c

*/







CREATE VIEW [dbo].[vwTaskData]
AS
SELECT  t.Id
,		t.CenterNumber__c AS 'CenterNumber'
,		t.ActivityDate
,		t.WhoId
,		l.FirstName
,		l.LastName
,		l.Source_Code_Legacy__c AS 'SourceCode'
,		src.OwnerType AS 'SourceAgency'
,		c.Type AS 'CampaignAgency'
,		ISNULL(ISNULL(src.OwnerType,C.[type]),'Unknown') AS 'Agency'
,		l.Status AS 'LeadStatus'
,		l.Age__c AS 'Age'
,		l.Language__c AS 'LeadLanguage'
,		l.SolutionOffered__c AS 'SolutionOffered'
,		c.Name AS 'Campaign'
,		c.Location__c AS 'Location',
		ctrtype.CenterTypeDescription AS 'CenterType'

,        CASE
           WHEN t.Action__c IN ( 'Be back' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
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
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
		--LEFT outer JOIN HC_BI_SFDC.dbo.Lead lp
		--	ON l.ConvertedContactId = t.WhoId
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = t.CenterNumber__c
			AND ctr.Active = 'Y'
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ctrtype
			ON ctrtype.CenterTypeKey = ctr.CenterTypeKey
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign c
			ON l.OriginalCampaignID__c = c.Id
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource src
			ON l.Source_Code_Legacy__c = src.SourceSSID
		--LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment a
		--	ON a.SFDC_TaskID = t.Id


WHERE   LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
		AND (Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' ) OR ISNULL(Result__c,'') ='')
		AND t.ActivityDate BETWEEN '01/01/2020' AND DATEADD(dd,0, DATEDIFF(dd,0,GETUTCDATE()))
		AND ISNULL(t.IsDeleted, 0) = 0


UNION


SELECT  t.Id
,		t.CenterNumber__c AS 'CenterNumber'
,		t.ActivityDate
,		t.WhoId
,		l.FirstName
,		l.LastName
,		l.Source_Code_Legacy__c AS 'SourceCode'
,		src.OwnerType AS 'SourceAgency'
,		c.Type AS 'CampaignAgency'
,		ISNULL(ISNULL(src.OwnerType,C.[type]),'Unknown') AS 'Agency'
,		l.Status AS 'LeadStatus'
,		l.Age__c AS 'Age'
,		l.Language__c AS 'LeadLanguage'
,		l.SolutionOffered__c AS 'SolutionOffered'
,		c.Name AS 'Campaign'
,		c.Location__c AS 'Location',
		ctrtype.CenterTypeDescription AS 'CenterType'

,        CASE
           WHEN t.Action__c IN ( 'Be back' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
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
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr				-----------------------------------
			ON ctr.CenterNumber = t.CenterNumber__c
			AND ctr.Active = 'Y'
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ctrtype
			ON ctrtype.CenterTypeKey = ctr.CenterTypeKey
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign c
			ON l.OriginalCampaignID__c = c.Id
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource src
			ON l.Source_Code_Legacy__c = src.SourceSSID
		--LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment a
		--	ON a.SFDC_TaskID = t.Id


WHERE   LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
		AND (Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' ) OR ISNULL(Result__c,'') ='')
		AND t.ActivityDate BETWEEN '01/01/2020' AND DATEADD(dd,0, DATEDIFF(dd,0,GETUTCDATE()))
		AND ISNULL(t.IsDeleted, 0) = 0
