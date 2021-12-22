/* CreateDate: 05/14/2012 17:41:17.357 , ModifyDate: 02/27/2017 09:49:23.573 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:                  mtnUpdateReconcileFeeNotifications

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           05/08/2012

LAST REVISION DATE:			05/08/2012

==============================================================================
DESCRIPTION:    Run nightly to create reconcile notifications for center fee batches
					and cener decline batches

==============================================================================
NOTES:
            * 05/08/2012 MVT - Created Stored Proc

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnUpdateReconcileFeeNotifications]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnUpdateReconcileFeeNotifications]
		@User AS nvarchar(50)
AS
BEGIN

	DECLARE @ReconNotificationTypeID int, @CorpCenterID int, @ReconNotificationExists bit, @FailedFeeBatchesCount int, @FailedDeclineBatchesCount int, @UTCDate date, @MonetraProcessingBuffer Int

	SET @UTCDate = CONVERT(date, GETUTCDATE())

	SELECT @ReconNotificationTypeID = NotificationTypeID
		FROM lkpNotificationType
		Where NotificationTypeDescriptionShort = 'Recon'

	SELECT Top(1) @CorpCenterID = CenterID
		FROM cfgCenter
		WHERE IsCorporateHeadquartersFlag = 1


	SET @MonetraProcessingBuffer = (SELECT TOP(1) MonetraProcessingBufferInMinutes FROM dbo.cfgConfigurationApplication)



	SELECT @FailedFeeBatchesCount = Count(*)
				FROM datCenterFeeBatch cfb
					INNER JOIN lkpCenterFeeBatchStatus s ON s.CenterFeeBatchStatusID = cfb.CenterFeeBatchStatusID
				Where s.CenterFeeBatchStatusDescriptionShort = 'Processing'
					AND DATEADD(MINUTE,@MonetraProcessingBuffer,cfb.LastUpdate) < GETUTCDATE()

	SELECT @FailedDeclineBatchesCount = Count(*)
				FROM datCenterDeclineBatch cdb
					INNER JOIN lkpCenterDeclineBatchStatus s ON s.CenterDeclineBatchStatusID = cdb.CenterDeclineBatchStatusID
				Where s.CenterDeclineBatchStatusDescriptionShort = 'Processing'
					AND DATEADD(MINUTE,@MonetraProcessingBuffer,cdb.LastUpdate) < GETUTCDATE()



	IF (SELECT Count(*) FROM datNotification
			WHERE CenterID = @CorpCenterID
				AND IsAcknowledgedFlag = 0
				AND NotificationTypeID = @ReconNotificationTypeID) > 0
		SET @ReconNotificationExists = 1

	-- CREATE/UPDATE Notifications

	IF 	@ReconNotificationExists = 1 AND (@FailedFeeBatchesCount > 0 OR @FailedDeclineBatchesCount > 0)
		UPDATE datNotification SET
			[Description] = 'Please Reconcile failed batches. There are ' + Convert(nvarchar(5),@FailedFeeBatchesCount) + ' Failed Fee Batches and ' + Convert(nvarchar(5),@FailedDeclineBatchesCount) + ' Failed Decline Batches.' ,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE CenterID = @CorpCenterID
			AND IsAcknowledgedFlag = 0
			AND NotificationTypeID = @ReconNotificationTypeID

	ELSE IF @ReconNotificationExists = 1 AND @FailedFeeBatchesCount = 0 AND @FailedDeclineBatchesCount = 0
		UPDATE datNotification SET
			[IsAcknowledgedFlag] = 1,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE CenterID = @CorpCenterID
			AND IsAcknowledgedFlag = 0
			AND NotificationTypeID = @ReconNotificationTypeID

	ELSE IF @ReconNotificationExists = 0 AND (@FailedFeeBatchesCount > 0 OR @FailedDeclineBatchesCount > 0)
		INSERT INTO [dbo].[datNotification]
		   ([NotificationDate]
		   ,[NotificationTypeID]
		   ,[ClientGUID]
		   ,[FeePayCycleID]
		   ,[FeeDate]
		   ,[CenterID]
		   ,[IsAcknowledgedFlag]
		   ,[Description]
		   ,[CreateDate]
		   ,[CreateUser]
		   ,[LastUpdate]
		   ,[LastUpdateUser])
		VALUES (
			GETUTCDATE(),
			@ReconNotificationTypeID,
			NULL,
			NULL,
			NULL,
			@CorpCenterID,
			0,
			'Please Reconcile failed batches. There are ' + Convert(nvarchar(5),@FailedFeeBatchesCount) + ' Failed Fee Batches and ' + Convert(nvarchar(5),@FailedDeclineBatchesCount) + ' Failed Decline Batches.' ,
			GETUTCDATE(),
			@User,
			GETUTCDATE(),
			@User)

END
GO
