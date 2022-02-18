/* CreateDate: 04/20/2018 14:49:18.853 , ModifyDate: 03/22/2021 15:48:31.900 */
GO
/***********************************************************************
PROCEDURE:				extDeletionTrackerProcess
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

EXEC extDeletionTrackerProcess 'C0C81819-AE2E-4044-B1FF-546EE76F6A8F'
***********************************************************************/
CREATE PROCEDURE [dbo].[extDeletionTrackerProcess]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN
BEGIN TRY


DECLARE @User NVARCHAR(50) = 'extDeletionTrackerProcess'


DECLARE	@Id NVARCHAR(18)
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
WHILE ( SELECT COUNT(*) FROM HCDeletionTracker__c WHERE SessionID = @SessionID AND ISNULL(ToBeProcessed__c, 0) = 1 AND ISNULL(IsProcessed, 0) = 0 AND MasterRecordId__c IS NOT NULL ) > 0
BEGIN
	SELECT  TOP 1
			@Id = dt.Id
	,		@ObjectName__c = dt.ObjectName__c
	,       @MasterRecordId__c = dt.MasterRecordId__c
	,       @DeletedId__c = dt.DeletedId__c
	,		@DeletedById__c = dt.DeletedById__c
	FROM    HCDeletionTracker__c dt
	WHERE   dt.SessionID = @SessionID
			AND ISNULL(dt.ToBeProcessed__c, 0) = 1
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
	SET @ObjectName__c = NULL
	SET @MasterRecordId__c = NULL
	SET @MasterRecordContactID__c = NULL
	SET @MasterRecordStatus = NULL
	SET @DeletedId__c = NULL
	SET @DeletedById__c = NULL
END


-- Process Deletions
PRINT '***********************************************************************'
PRINT ' PROCESSING DELETIONS'
PRINT '***********************************************************************'
PRINT ''
WHILE ( SELECT COUNT(*) FROM HCDeletionTracker__c WHERE SessionID = @SessionID AND ISNULL(ToBeProcessed__c, 0) = 1 AND ISNULL(IsProcessed, 0) = 0 AND ISNULL(IsError, 0) = 0 AND MasterRecordId__c IS NULL ) > 0
BEGIN
	SELECT  TOP 1
			@Id = dt.Id
	,		@ObjectName__c = dt.ObjectName__c
	,       @DeletedId__c = dt.DeletedId__c
	,		@DeletedById__c = dt.DeletedById__c
	FROM    HCDeletionTracker__c dt
	WHERE   dt.SessionID = @SessionID
			AND ISNULL(dt.ToBeProcessed__c, 0) = 1
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
	END


	-- Process Campaign Deletions
	IF @ObjectName__c = 'Campaign'
	BEGIN
		-- Update SFDC Campaign
		PRINT 'Setting IsDeleted to 1 for Campaign ' + @DeletedId__c + ' in SFDC.'

		UPDATE  c
		SET     c.IsDeleted = 1
		,       c.LastModifiedDate = GETDATE()
		,       c.LastModifiedById = @DeletedById__c
		FROM    Campaign c
		WHERE   c.Id = @DeletedId__c
	END


	-- Process User Deletions
	IF @ObjectName__c = 'User'
	BEGIN
		-- Update SFDC User
		PRINT 'Setting IsDeleted to 1 for User ' + @DeletedId__c + ' in SFDC.'

		UPDATE  u
		SET     u.IsDeleted = 1
		,       u.LastModifiedDate = GETDATE()
		,       u.LastModifiedById = @DeletedById__c
		FROM    [User] u
		WHERE   u.Id = @DeletedId__c
	END


	-- Process Phone Deletions
	IF @ObjectName__c = 'Phone__c'
	BEGIN
		-- Update SFDC Phone
		PRINT 'Setting IsDeleted to 1 for Phone ' + @DeletedId__c + ' in SFDC.'

		UPDATE  p
		SET     p.IsDeleted = 1
		,       p.LastModifiedDate = GETDATE()
		,       p.LastModifiedById = @DeletedById__c
		FROM    Phone__c p
		WHERE   p.Id = @DeletedId__c
	END


	-- Process Address Deletions
	IF @ObjectName__c = 'Address__c'
	BEGIN
		-- Update SFDC Address
		PRINT 'Setting IsDeleted to 1 for Address ' + @DeletedId__c + ' in SFDC.'

		UPDATE  a
		SET     a.IsDeleted = 1
		,       a.LastModifiedDate = GETDATE()
		,       a.LastModifiedById = @DeletedById__c
		FROM    Address__c a
		WHERE   a.Id = @DeletedId__c
	END


	-- Process Email Deletions
	IF @ObjectName__c = 'Email__c'
	BEGIN
		-- Update SFDC Email
		PRINT 'Setting IsDeleted to 1 for Email ' + @DeletedId__c + ' in SFDC.'

		UPDATE  e
		SET     e.IsDeleted = 1
		,       e.LastModifiedDate = GETDATE()
		,       e.LastModifiedById = @DeletedById__c
		FROM    Email__c e
		WHERE   e.Id = @DeletedId__c
	END


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
