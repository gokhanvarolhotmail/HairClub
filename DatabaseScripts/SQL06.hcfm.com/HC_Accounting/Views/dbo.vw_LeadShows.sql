/* CreateDate: 03/18/2019 12:01:27.290 , ModifyDate: 07/30/2019 14:32:32.420 */
GO
/***********************************************************************
VIEW:
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Accounting
AUTHOR:					James Lee
IMPLEMENTOR:			James Lee
DATE IMPLEMENTED:		3/14/2019
DESCRIPTION:			3/14/2019
***********************************************************************/
CREATE VIEW [dbo].[vw_LeadShows]
AS

SELECT	ctr.CenterNumber
,		ctr.CenterDescription
,		t.ActivityDate AS 'ShowDate'
,		CASE WHEN t.Action__c NOT IN ( 'Be Back' ) AND t.Result__c IN ( 'Show No Sale', 'Show Sale' ) THEN 'Consultation' ELSE t.Action__c END AS 'ShowType'
,		t.Action__c AS 'AppointmentAction'
,		t.Result__c AS 'AppointmentResult'
,		t.SourceCode__c AS 'AppointmentSourceCode'
,		t.Performer__c AS 'ConsultantName'
,		RTRIM(t.SolutionOffered__c) AS 'SolutionOffered'
,		t.PriceQuoted__c AS 'PriceQuoted'
,		t.NoSaleReason__c AS 'NoBuyReason'
,		RTRIM(l.FirstName) AS 'FirstName'
,		RTRIM(l.LastName) AS 'LastName'
,		l.Status AS 'LeadStatus'
,		RTRIM(t.LeadOncGender__c) AS 'Gender'
,		RTRIM(t.LeadOncEthnicity__c) AS 'Ethnicity'
,		RTRIM(ac.Street__c) AS 'Address1'
,		RTRIM(ac.Street2__c) AS 'Address2'
,		RTRIM(ac.City__c) AS 'City'
,		RTRIM(ac.State__c) AS 'StateCode'
,		RTRIM(ac.Zip__c) AS 'ZipCode'
,		RTRIM(pc.PhoneAbr__c) AS 'PhoneNumber'
,		RTRIM(ec.Name) AS 'EmailAddress'
,		ISNULL(l.DoNotContact__c, 0) AS 'DoNoContact'
,		ISNULL(l.DoNotCall, 0) AS 'DoNotCall'
,		ISNULL(l.DoNotEmail__c, 0) AS 'DoNotEmail'
,		ISNULL(l.DoNotMail__c, 0) AS 'DoNotMail'
,		ISNULL(l.DoNotText__c, 0) AS 'DoNotText'
,		ISNULL(clt.CanContactForPromotionsByEmail, 0) AS 'CanContactForPromotionsByEmail'
FROM	SQL05.HC_BI_SFDC.dbo.Task t
		INNER JOIN SQL05.HC_BI_SFDC.dbo.Lead l
			ON t.WhoId = l.Id
		INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter ctr
			ON ctr.CenterNumber = t.CenterNumber__c
				AND ctr.CenterTypeID IN ( 1, 2,3,6 )
		INNER JOIN SQL05.HairClubCMS.dbo.datClient clt
			ON clt.SalesforceContactID = l.Id
		LEFT OUTER JOIN SQL05.HC_BI_SFDC.dbo.Address__c ac
			ON ac.Lead__c = l.Id
				AND ac.Primary__c = 1
		LEFT OUTER JOIN SQL05.HC_BI_SFDC.dbo.Phone__c pc
			ON pc.Lead__c = l.Id
				AND pc.Primary__c = 1
		LEFT OUTER JOIN SQL05.HC_BI_SFDC.dbo.Email__c ec
			ON ec.Lead__c = l.Id
				AND ec.Primary__c = 1
WHERE	t.Result__c IN ( 'Show No Sale', 'Show Sale' )
		AND ISNULL(t.IsDeleted, 0) = 0
		AND ISNULL(l.IsDeleted, 0) = 0
		AND ISNULL(ac.IsDeleted, 0) = 0
		AND ISNULL(pc.IsDeleted, 0) = 0
		AND ISNULL(ec.IsDeleted, 0) = 0
GO
