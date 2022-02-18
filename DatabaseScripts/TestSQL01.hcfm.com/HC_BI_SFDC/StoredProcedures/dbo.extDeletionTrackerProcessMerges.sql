/* CreateDate: 05/31/2018 11:52:36.223 , ModifyDate: 03/22/2021 15:48:42.897 */
GO
/***********************************************************************
PROCEDURE:				extDeletionTrackerProcessMerges
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/20/2018
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extDeletionTrackerProcessMerges
***********************************************************************/
CREATE PROCEDURE [dbo].[extDeletionTrackerProcessMerges]
AS
BEGIN
BEGIN TRY

PRINT 'Resetting Batches in SFDC.'
UPDATE  hdtc
SET     ToBeProcessed__c = 1
,		IsProcessed = 0
,		IsError = 0
,		LastProcessedDate__c = NULL
FROM    HCDeletionTracker__c hdtc
		INNER JOIN Lead l
			ON l.Id = hdtc.DeletedId__c
WHERE   hdtc.MasterRecordId__c IS NOT NULL
		AND l.Status <> 'Merged'


-- Update merged leads that are not in SFDC database but were synched to ONC
UPDATE  hdtc
SET     ToBeProcessed__c = 1
,		IsProcessed = 0
,		IsError = 0
,		LastProcessedDate__c = NULL
FROM    HCDeletionTracker__c hdtc
		INNER JOIN HCM.dbo.oncd_contact oc
			ON oc.cst_sfdc_lead_id = hdtc.DeletedId__c
		LEFT OUTER JOIN Lead l
			ON l.Id = hdtc.DeletedId__c
WHERE   hdtc.ObjectName__c = 'Lead'
		AND hdtc.MasterRecordId__c IS NOT NULL
		AND oc.contact_status_code <> 'Merged'
		AND l.Id IS NULL


DECLARE @User NVARCHAR(50) = 'extDeletionTrackerProcessMerges'


DECLARE	@Id NVARCHAR(18)
,		@SessionID NVARCHAR(100)
,		@ObjectName__c NVARCHAR(50)
,		@MasterRecordId__c NVARCHAR(18)
,		@MasterRecordContactID__c NVARCHAR(50)
,		@MasterRecordStatus NCHAR(10)
,		@DeletedId__c NVARCHAR(18)
,		@DeletedById__c NVARCHAR(18)


-- Process Merges
PRINT '***********************************************************************'
PRINT ' PROCESSING MERGES'
PRINT '***********************************************************************'
PRINT ''
WHILE ( SELECT COUNT(*) FROM HCDeletionTracker__c WHERE ISNULL(ToBeProcessed__c, 0) = 1 AND ISNULL(IsProcessed, 0) = 0 AND MasterRecordId__c IS NOT NULL ) > 0
BEGIN
	SELECT  TOP 1
			@Id = dt.Id
	,		@SessionID = dt.SessionID
	,		@ObjectName__c = dt.ObjectName__c
	,       @MasterRecordId__c = dt.MasterRecordId__c
	,       @DeletedId__c = dt.DeletedId__c
	,		@DeletedById__c = dt.DeletedById__c
	FROM    HCDeletionTracker__c dt
	WHERE   ISNULL(dt.ToBeProcessed__c, 0) = 1
			AND ISNULL(dt.IsProcessed, 0) = 0
			AND dt.MasterRecordId__c IS NOT NULL
	ORDER BY dt.CreatedDate


	-- Update SFDC Lead
	PRINT 'Setting status for Lead: ' + @DeletedId__c + ' to Merged in SFDC.'

	UPDATE  l
	SET     l.IsDeleted = 1
	,		l.Status = 'Merged'
	,		l.Lead_Activity_Status__c = 'Merged'
	,       l.LastModifiedDate = GETDATE()
	,       l.LastModifiedById = @DeletedById__c
	FROM    Lead l
	WHERE	l.Id = @DeletedId__c


	SET @MasterRecordContactID__c = (SELECT l.ContactID__c FROM Lead l WHERE l.Id = @MasterRecordId__c)


	-- Update cONEct records
	EXEC HairClubCMS_extSFDCDeletionTrackerProcess_PROC @DeletedId__c, @MasterRecordId__c, @MasterRecordContactID__c


	---- Update OnContact Merged Lead
	--PRINT 'Setting status for Lead: ' + @DeletedId__c + ' to Merged in OnContact.'

	--EXEC OnContact_extSFDCUpdateLeadStatus_PROC @DeletedId__c, 'MERGED'

	--IF NOT EXISTS (SELECT oc.contact_id FROM OnContact_oncd_contact_TABLE oc WHERE oc.cst_sfdc_lead_id = @DeletedId__c AND oc.contact_status_code = 'MERGED')
	--BEGIN
	--    PRINT 'Record not marked as MERGED in OnContact.'

	--	UPDATE  HCDeletionTracker__c
	--	SET     IsError = 1
	--	,		ErrorMessage = 'Record not marked as MERGED in OnContact.'
	--	WHERE   Id = @Id
	--			AND SessionID = @SessionID
	--END


	---- Update OnContact Master Lead
	--PRINT 'Setting status to match Salesforce for Lead: ' + @MasterRecordId__c + ' in OnContact.'

	--SET @MasterRecordStatus = (SELECT l.Status FROM Lead l WHERE l.Id = @MasterRecordId__c)

	--EXEC OnContact_extSFDCUpdateLeadStatus_PROC @MasterRecordId__c, @MasterRecordStatus

	--IF NOT EXISTS (SELECT oc.contact_id FROM OnContact_oncd_contact_TABLE oc WHERE oc.cst_sfdc_lead_id = @MasterRecordId__c AND oc.contact_status_code = @MasterRecordStatus)
	--BEGIN
	--    PRINT 'Master Record not updated in OnContact.'

	--	UPDATE  HCDeletionTracker__c
	--	SET     IsError = 1
	--	,		ErrorMessage = 'Master Record not updated in OnContact.'
	--	WHERE   Id = @Id
	--			AND SessionID = @SessionID
	--END


	---- Insert Change Log record
	--PRINT 'Inserting client change log record for Client: ' + @MasterRecordId__c + ' in cONEct.'

	--INSERT	INTO ChangeLog
	--		SELECT  @SessionID
	--		,       'HairClubCMS.dbo.datClient'
	--		,       clt.ClientIdentifier
	--		,       'SalesforceContactID'
	--		,       clt.SalesforceContactID
	--		,       @MasterRecordId__c
	--		,       GETDATE()
	--		,       @User
	--		,       GETDATE()
	--		,       @User
	--		FROM    HairClubCMS_datClient_TABLE clt
	--				LEFT OUTER JOIN ChangeLog cl
	--					ON cl.SessionID = @SessionID
	--						AND cl.ObjectName = 'HairClubCMS.dbo.datClient'
	--						AND cl.OldValue = clt.SalesforceContactID
	--						AND cl.NewValue = @MasterRecordId__c
	--		WHERE   clt.SalesforceContactID = @DeletedId__c
	--				AND cl.ChangeLogID IS NULL


	---- Update cONEct Client
	--PRINT 'Updating client record for Client: ' + @MasterRecordId__c + ' in cONEct.'

	--SET @MasterRecordContactID__c = (SELECT l.ContactID__c FROM Lead l WHERE l.Id = @MasterRecordId__c)

	--UPDATE  clt
	--SET     clt.SalesforceContactID = @MasterRecordId__c
	--,		clt.ContactID = @MasterRecordContactID__c
	--,       clt.LastUpdate = GETUTCDATE()
	--FROM    HairClubCMS_datClient_TABLE clt
	--WHERE   clt.SalesforceContactID = @DeletedId__c


	---- Insert Change Log record
	--PRINT 'Inserting appointment change log record for Appointment: ' + @MasterRecordId__c + ' in cONEct.'

	--INSERT	INTO ChangeLog
	--		SELECT  @SessionID
	--		,       'HairClubCMS.dbo.datAppointment'
	--		,       da.AppointmentGUID
	--		,       'SalesforceContactID'
	--		,       da.SalesforceContactID
	--		,       @MasterRecordId__c
	--		,       GETDATE()
	--		,       @User
	--		,       GETDATE()
	--		,       @User
	--		FROM    HairClubCMS_datAppointment_TABLE da
	--				LEFT OUTER JOIN ChangeLog cl
	--					ON cl.SessionID = @SessionID
	--						AND cl.ObjectName = 'HairClubCMS.dbo.datAppointment'
	--						AND cl.OldValue = CONVERT(NVARCHAR(100), da.AppointmentGUID)
	--						AND cl.NewValue = @MasterRecordId__c
	--		WHERE   da.SalesforceContactID = @DeletedId__c
	--				AND cl.ChangeLogID IS NULL


	---- Update cONEct Appointment
	--PRINT 'Updating appointment record for Client: ' + @MasterRecordId__c + ' in cONEct.'

	--UPDATE  da
	--SET     da.SalesforceContactID = @MasterRecordId__c
	--,       da.LastUpdate = GETUTCDATE()
	--FROM    HairClubCMS_datAppointment_TABLE da
	--WHERE	da.SalesforceContactID = @DeletedId__c


	-- Update Transaction as Processed
	PRINT 'Finished Processing ' + @Id + ' in SFDC.'

	UPDATE  HCDeletionTracker__c
	SET     ToBeProcessed__c = 0
	,		IsProcessed = 1
	,		LastProcessedDate__c = GETDATE()
	WHERE   Id = @Id
			AND SessionID = @SessionID
			AND ISNULL(ToBeProcessed__c, 0) = 1
			AND ISNULL(IsProcessed, 0) = 0


	SET @Id = NULL
	SET @SessionID = NULL
	SET @ObjectName__c = NULL
	SET @MasterRecordId__c = NULL
	SET @MasterRecordContactID__c = NULL
	SET @MasterRecordStatus = NULL
	SET @DeletedId__c = NULL
	SET @DeletedById__c = NULL
END
END TRY
BEGIN CATCH

-- Write Error Message to the Error Log Table
UPDATE	HCDeletionTracker__c
SET		IsError = 1
,		ErrorMessage = ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
WHERE	Id = @Id
		AND SessionID = @SessionID


DECLARE @ErrorMessage NVARCHAR(4000);
DECLARE @ErrorSeverity INT;
DECLARE @ErrorState INT;


SELECT  @ErrorMessage = ERROR_MESSAGE()
,       @ErrorSeverity = ERROR_SEVERITY()
,       @ErrorState = ERROR_STATE();


RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH

END
GO
