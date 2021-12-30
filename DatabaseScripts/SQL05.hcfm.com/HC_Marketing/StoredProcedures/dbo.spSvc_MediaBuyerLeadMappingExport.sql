/* CreateDate: 08/21/2018 13:56:56.870 , ModifyDate: 09/08/2020 16:39:51.550 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerLeadMappingExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/12/2018
DESCRIPTION:			4/12/2018
------------------------------------------------------------------------
NOTES:
	09/08/2020	KMurdoch	Added new Lead statuses, , 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MediaBuyerLeadMappingExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MediaBuyerLeadMappingExport]
AS
BEGIN

SET NOCOUNT ON;


-- Get Data
SELECT  l.Id AS 'SalesforceRecordID'
,		ISNULL(l.ContactID__c, l.Id) AS 'RecordID'
FROM    HC_BI_SFDC.dbo.Lead l
WHERE	l.Status IN ( 'Lead', 'Client', 'Deleted', 'Invalid', 'Merged', 'HWLead', 'HWClient', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
		AND l.ContactID__c IS NOT NULL

END
GO
