/***********************************************************************
PROCEDURE:				extSFDCDeletionTrackerProcess
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/22/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSFDCDeletionTrackerProcess
***********************************************************************/
CREATE PROCEDURE extSFDCDeletionTrackerProcess
(
	@DeletedId__c NVARCHAR(18)
,	@MasterRecordId__c NVARCHAR(18)
,	@MasterRecordContactID__c NVARCHAR(50)
)
AS
BEGIN

-- Update cONEct Client
PRINT 'Updating client record for Client: ' + @MasterRecordId__c + ' in cONEct.'

UPDATE  clt
SET     clt.SalesforceContactID = @MasterRecordId__c
,		clt.ContactID = @MasterRecordContactID__c
,       clt.LastUpdate = GETUTCDATE()
FROM    datClient clt
WHERE   clt.SalesforceContactID = @DeletedId__c


-- Update cONEct Appointment
PRINT 'Updating appointment record for Client: ' + @MasterRecordId__c + ' in cONEct.'

UPDATE  da
SET     da.SalesforceContactID = @MasterRecordId__c
,       da.LastUpdate = GETUTCDATE()
FROM    datAppointment da
WHERE	da.SalesforceContactID = @DeletedId__c

END
