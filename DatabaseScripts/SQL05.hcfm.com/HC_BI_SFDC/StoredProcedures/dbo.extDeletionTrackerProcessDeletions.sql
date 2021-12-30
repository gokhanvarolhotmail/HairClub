/* CreateDate: 06/28/2018 09:36:59.280 , ModifyDate: 03/22/2021 15:48:37.817 */
GO
/***********************************************************************
PROCEDURE:				extDeletionTrackerProcessDeletions
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

EXEC extDeletionTrackerProcessDeletions
***********************************************************************/
CREATE PROCEDURE [dbo].[extDeletionTrackerProcessDeletions]
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
		INNER JOIN HCM.dbo.oncd_contact oc
			ON oc.cst_sfdc_lead_id = hdtc.DeletedId__c
WHERE   hdtc.MasterRecordId__c IS NULL
		AND hdtc.ObjectName__c = 'Lead'
		AND oc.contact_status_code <> 'DELETED'


-- Deleted Task
UPDATE  hdtc
SET     ToBeProcessed__c = 1
,		IsProcessed = 0
,		IsError = 0
,		LastProcessedDate__c = NULL
FROM    HCDeletionTracker__c hdtc
		INNER JOIN HCM.dbo.oncd_activity oa
			ON oa.cst_sfdc_task_id = hdtc.DeletedId__c
WHERE   hdtc.MasterRecordId__c IS NULL
		AND hdtc.ObjectName__c = 'Task'
		AND ( oa.action_code <> 'DELETED' OR oa.result_code <> 'DELETED' )


DECLARE @User NVARCHAR(50) = 'extDeletionTrackerProcessDeletions'


DECLARE	@Id NVARCHAR(18)
,		@ObjectName__c NVARCHAR(50)
,		@MasterRecordId__c NVARCHAR(18)
,		@MasterRecordContactID__c NVARCHAR(50)
,		@MasterRecordStatus NCHAR(10)
,		@DeletedId__c NVARCHAR(18)
,		@DeletedById__c NVARCHAR(18)


-- Process Deletions
PRINT '***********************************************************************'
PRINT ' PROCESSING DELETIONS'
PRINT '***********************************************************************'
PRINT ''
WHILE ( SELECT COUNT(*) FROM HCDeletionTracker__c WHERE ISNULL(ToBeProcessed__c, 0) = 1 AND ISNULL(IsProcessed, 0) = 0 AND MasterRecordId__c IS NULL ) > 0
BEGIN
	SELECT  TOP 1
			@Id = dt.Id
	,		@ObjectName__c = dt.ObjectName__c
	,       @DeletedId__c = dt.DeletedId__c
	,		@DeletedById__c = dt.DeletedById__c
	FROM    HCDeletionTracker__c dt
	WHERE   ISNULL(dt.ToBeProcessed__c, 0) = 1
			AND ISNULL(dt.IsProcessed, 0) = 0
			AND dt.MasterRecordId__c IS NULL
	ORDER BY dt.CreatedDate


	-- Process Lead Deletions
	IF @ObjectName__c = 'Lead'
	BEGIN
		-- Update SFDC Lead
		PRINT 'Setting status for Lead: ' + @DeletedId__c + ' to Deleted in SFDC.'

		UPDATE  l
		SET     l.IsDeleted = 1
		,		l.Status = 'Deleted'
		,		l.Lead_Activity_Status__c = 'Deleted'
		,       l.LastModifiedDate = GETDATE()
		,       l.LastModifiedById = @DeletedById__c
		FROM    Lead l
		WHERE	l.Id = @DeletedId__c


		---- Update OnContact Lead
		--PRINT 'Setting status for Lead: ' + @DeletedId__c + ' to Deleted in OnContact.'

		--EXEC OnContact_extSFDCUpdateLeadStatus_PROC @DeletedId__c, 'DELETED'

		--IF NOT EXISTS (SELECT oc.contact_id FROM OnContact_oncd_contact_TABLE oc WHERE oc.cst_sfdc_lead_id = @DeletedId__c)
		--BEGIN
		--	PRINT 'Record not found in OnContact.'

		--	UPDATE  HCDeletionTracker__c
		--	SET     IsError = 1
		--	,		ErrorMessage = 'Record not found in OnContact.'
		--	WHERE   Id = @Id
		--END
		--ELSE IF NOT EXISTS (SELECT oc.contact_id FROM OnContact_oncd_contact_TABLE oc WHERE oc.cst_sfdc_lead_id = @DeletedId__c AND oc.contact_status_code = 'DELETED')
		--BEGIN
		--	PRINT 'Record not marked as DELETED in OnContact.'

		--	UPDATE  HCDeletionTracker__c
		--	SET     IsError = 1
		--	,		ErrorMessage = 'Record not marked as DELETED in OnContact.'
		--	WHERE   Id = @Id
		--END

		---- Update cONEct Client
		--INSERT	INTO ChangeLog
		--		SELECT  @SessionID
		--		,       'HairClubCMS.dbo.datClient'
		--		,       clt.ClientIdentifier
		--		,       'SalesforceContactID'
		--		,       clt.SalesforceContactID
		--		,       NULL
		--		,       GETDATE()
		--		,       @User
		--		,       GETDATE()
		--		,       @User
		--		FROM    HairClubCMS_datClient_TABLE clt
		--			LEFT OUTER JOIN ChangeLog cl
		--				ON cl.SessionID = @SessionID
		--					AND cl.ObjectName = 'HairClubCMS.dbo.datClient'
		--					AND cl.OldValue = clt.SalesforceContactID
		--					AND cl.NewValue = NULL
		--		WHERE   clt.SalesforceContactID = @DeletedId__c
		--				AND cl.ChangeLogID IS NULL


		--UPDATE  clt
		--SET     clt.SalesforceContactID = NULL
		--,       clt.LastUpdate = GETUTCDATE()
		--FROM    HairClubCMS_datClient_TABLE clt
		--WHERE	clt.SalesforceContactID = @DeletedId__c
	END


	-- Process Task Deletions
	IF @ObjectName__c = 'Task'
	BEGIN
		PRINT 'Setting action & result codes to Deleted for Task ' + @DeletedId__c + ' in SFDC.'

		UPDATE  t
		SET     t.Action__c = 'Deleted'
		,       t.Result__c = 'Deleted'
		,       t.IsDeleted = 1
		,       t.LastModifiedDate = GETDATE()
		,       t.LastModifiedById = @DeletedById__c
		FROM    Task t
		WHERE   t.Id = @DeletedId__c


		---- Update OnContact Activity
		--PRINT 'Setting action & result codes to Deleted for Activity ' + @DeletedId__c + ' in OnContact.'

		--EXEC OnContact_extSFDCUpdateTask_PROC @DeletedId__c, 'DELETED', 'DELETED'

		--IF NOT EXISTS (SELECT oa.activity_id FROM OnContact_oncd_activity_TABLE oa WHERE oa.cst_sfdc_task_id = @DeletedId__c)
		--BEGIN
		--	PRINT 'Record not found in OnContact.'

		--	UPDATE  HCDeletionTracker__c
		--	SET     IsError = 1
		--	,		ErrorMessage = 'Record not found in OnContact.'
		--	WHERE   Id = @Id
		--END
  --      ELSE IF NOT EXISTS (SELECT oa.activity_id FROM OnContact_oncd_activity_TABLE oa WHERE oa.cst_sfdc_task_id = @DeletedId__c AND oa.action_code = 'DELETED' AND oa.result_code = 'DELETED')
  --      BEGIN
		--	PRINT 'Record not marked as DELETED in OnContact.'

		--	UPDATE  HCDeletionTracker__c
		--	SET     IsError = 1
		--	,		ErrorMessage = 'Record not marked as DELETED in OnContact.'
		--	WHERE   Id = @Id
  --      END
	END


	-- Update Transaction as Processed
	PRINT 'Finished Processing ' + @Id + ' in SFDC.'

	UPDATE  HCDeletionTracker__c
	SET     ToBeProcessed__c = 0
	,		IsProcessed = 1
	,		LastProcessedDate__c = GETDATE()
	WHERE   Id = @Id
			AND ISNULL(ToBeProcessed__c, 0) = 1
			AND ISNULL(IsProcessed, 0) = 0


	SET @Id = NULL
	SET @ObjectName__c = NULL
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
