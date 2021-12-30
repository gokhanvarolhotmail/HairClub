/* CreateDate: 01/12/2021 12:05:08.890 , ModifyDate: 03/15/2021 15:24:55.840 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetBosleyReferrals
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/12/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetBosleyReferrals NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetBosleyReferrals]
(
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME = GETDATE()


/********************************** Set Dates If Parameters are NULL *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = CASE WHEN DAY(@CurrentDate) = 1 THEN DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0)) ELSE DATEADD(DAY, 0, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0)) END
		SET @EndDate = CASE WHEN DAY(@CurrentDate) = 1 THEN DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @CurrentDate)) +1, 0)) ELSE DATEADD(DAY, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME)) END
   END


SELECT	c.Id
,		c.SourceCode_L__c AS 'SourceCode'
,		c.Name AS 'CampaignName'
INTO	#BosleyReferral
FROM	HC_BI_SFDC.dbo.Campaign c
WHERE	c.Format__c = 'Bosley'
		AND c.CampaignType__c = 'Referral'


SELECT	l.Id
,		ISNULL(COALESCE(l.BosleySFID__c, l.SiebelID__c, clt.SiebelID), '') AS 'SiebelID'
,       ISNULL(l.FirstName, a.FirstName) AS 'FirstName'
,       ISNULL(l.LastName, a.LastName) AS 'LastName'
,		l.Status
,		l.Source_Code_Legacy__c AS 'ReferralPurpose'
INTO	#Lead
FROM	HC_BI_SFDC.dbo.Lead l
		INNER JOIN #BosleyReferral br
			ON br.SourceCode = l.Source_Code_Legacy__c
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
			ON a.PersonContactId = l.ConvertedContactId
        LEFT OUTER JOIN HairClubCMS.dbo.datClient clt
            ON clt.SalesforceContactID = l.Id
		OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
WHERE	l.ReportCreateDate__c BETWEEN @StartDate AND @EndDate + ' 23:59:59'
		AND ISNULL(l.IsDeleted, 0) = 0
		AND ISNULL(fil.IsInvalidLead, 0) = 0


SELECT	l.ReferralPurpose AS 'LeadSourceCode'
,		ISNULL(t.SourceCode__c, '') AS 'TaskSourceCode'
,		l.SiebelID
,       CASE WHEN CONVERT(VARCHAR, clt.ClientIdentifier) IS NULL THEN ''
             ELSE CONVERT(VARCHAR, clt.ClientIdentifier)
        END AS 'ConectID'
,       t.WhoId AS 'SalesforceID'
,       l.FirstName
,       l.LastName
,       'Salesforce' AS 'HCSystem'
,       t.Id AS 'HCSystemTaskID'
,       CAST(t.ActivityDate AS DATE) AS 'ActivityDate'
,       CAST(t.CompletionDate__c AS DATE) AS 'CompletionDate'
,       t.Action__c AS 'ActivityAction'
,       ISNULL(t.Result__c, '') AS 'ActivityResolution'
,       CASE ISNULL(t.Result__c, '')
          WHEN 'Show No Sale' THEN 'Done'
          WHEN 'Show Sale' THEN 'Done'
          WHEN 'No Show' THEN 'Cancelled'
          WHEN 'Cancel' THEN 'Cancelled'
          WHEN 'Reschedule' THEN 'Rescheduled'
          WHEN '' THEN 'Scheduled'
          ELSE ''
        END AS 'ActivityStatus'
,       ISNULL(t.PriceQuoted__c, 0) AS 'SaleAmount'
,       CASE WHEN ISNULL(t.Result__c, '') <> 'Show Sale' THEN ''
             ELSE t.SaleTypeDescription__c
        END AS 'ProductSold'
,       ctr.CenterDescription AS 'HCCenterName'
,       ISNULL(t.CenterID__c, t.CenterNumber__c) AS 'HCCenterNumber'
,       ISNULL(t.Performer__c, '') AS 'ConsultantSalesPerson'
FROM	HC_BI_SFDC.dbo.Task t
		INNER JOIN #Lead l
			ON l.Id = t.WhoId
        LEFT OUTER JOIN HairClubCMS.dbo.datClient clt
            ON clt.SalesforceContactID = t.WhoId
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = ISNULL(t.CenterID__c, t.CenterNumber__c)
				AND ctr.Active = 'Y'
WHERE	LTRIM(RTRIM(t.Action__c)) NOT IN ( 'SMS' )
		AND LTRIM(RTRIM(t.Result__c)) NOT IN ( 'Void' )
		AND ISNULL(t.IsDeleted, 0) = 0
ORDER BY l.Id
,		t.ActivityDate

END
GO
