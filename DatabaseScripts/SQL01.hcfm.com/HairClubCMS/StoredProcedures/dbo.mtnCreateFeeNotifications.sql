/*
==============================================================================
PROCEDURE:                  mtnCreateFeeNotifications

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           03/05/2012

LAST REVISION DATE:			03/05/2012

==============================================================================
DESCRIPTION:    Run nightly to create fee notifications for centers  based on
		center configured notification days.

==============================================================================
NOTES:
            * 02/27/2012 MVT - Created Stored Proc
            * 07/13/2012 MVT - Modified to only create notifications if the fees have
							not yet been appoved and to only create notifications if
							the fees are processed centrally for the center.

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnCreateFeeNotifications]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnCreateFeeNotifications]
AS
BEGIN

	DECLARE @FeeNotificationTypeID int, @InactiveFeeProfileNotificationTypeID int, @FeePayCycleDay int, @FeePayCycleID int, @NextFeePayCycleDate date, @UTCDate date

	SET @UTCDate = CONVERT(date, GETUTCDATE())

	SELECT @FeeNotificationTypeID = NotificationTypeID
		FROM lkpNotificationType
		Where NotificationTypeDescriptionShort = 'Fees'

	SELECT @InactiveFeeProfileNotificationTypeID = NotificationTypeID
		FROM lkpNotificationType
		Where NotificationTypeDescriptionShort = 'InactvFee'

	-- Determine next fee pay cycle date.
	SELECT @FeePayCycleDay = FeePayCycleValue,
			@FeePayCycleID = FeePayCycleID
		FROM lkpFeePayCycle
		WHERE IsActiveFlag = 1
			AND FeePayCycleValue > 0
			AND FeePayCycleValue >= DATEPART(day, @UTCDate)


	IF @FeePayCycleDay IS NOT NULL
		SET @NextFeePayCycleDate = CONVERT(date, CONVERT(VarChar(2), MONTH(@UTCDate)) + '/' + CONVERT(varchar(2), @FeePayCycleDay) + '/' + CONVERT(VarChar(4), YEAR(@UTCDate)))
	ELSE
	BEGIN
		SELECT Top(1) @FeePayCycleDay= FeePayCycleValue,
					@FeePayCycleID = FeePayCycleID
				FROM lkpFeePayCycle
				WHERE IsActiveFlag = 1
					AND FeePayCycleValue > 0
					AND FeePayCycleValue < DATEPART(day, @UTCDate)
				ORDER BY FeePayCycleValue asc

		IF @FeePayCycleDay IS NOT NULL
			SET @NextFeePayCycleDate = CONVERT(date, CONVERT(VarChar(2), MONTH(DATEADD(month,1,@UTCDate))) + '/' + CONVERT(varchar(2), @FeePayCycleDay) + '/' + CONVERT(VarChar(4), YEAR(DATEADD(month,1,@UTCDate))))
	END


	-- Create notifications if don't already exist
	-- for the center.
	IF @NextFeePayCycleDate IS NOT NULL
	BEGIN

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
    	SELECT	GETUTCDATE(),
    			@FeeNotificationTypeID,
    			NULL,
    			@FeePayCycleID,
    			@NextFeePayCycleDate,
    			c.CenterID,
    			0,
    			'Verify monthly fees that will run on ' + DATENAME(MM,@NextFeePayCycleDate) + ' ' + DATENAME(dd, @NextFeePayCycleDate) + ', ' + DATENAME(yyyy, @NextFeePayCycleDate),
    			GETUTCDATE(),
    			'Nightly Job',
    			GETUTCDATE(),
    			'Nightly Job'
		FROM cfgCenter c
			INNER JOIN cfgConfigurationCenter config ON c.CenterID = config.CenterID
			LEFT JOIN datNotification n ON c.CenterID = n.CenterID AND n.FeeDate = @NextFeePayCycleDate  -- Not notified for this pay cycle
			LEFT OUTER JOIN datCenterFeeBatch cfb ON cfb.CenterID = c.CenterID
								AND cfb.FeePayCycleID = @FeePayCycleID
								AND cfb.FeeMonth = MONTH(@NextFeePayCycleDate)
								AND cfb.FeeYear = YEAR(@NextFeePayCycleDate)
			LEFT JOIN lkpCenterFeeBatchStatus stat ON stat.CenterFeeBatchStatusID = cfb.CenterFeeBatchStatusID
		Where c.IsActiveFlag = 1
			AND c.IsCorporateHeadquartersFlag = 0
			AND config.IsFeeProcessedCentrallyFlag = 1
			AND c.EmployeeDoctorGUID IS NULL	-- non-surgery centers only.
			AND DATEDIFF(day,@UTCDate,@NextFeePayCycleDate) <= config.FeeNotificationDays
			AND n.NotificationID IS NULL
			AND (cfb.CenterFeeBatchGUID IS NULL OR stat.CenterFeeBatchStatusDescriptionShort = 'WAITING')

	END

	-- Update Inactive Fee Profile notifications that have not been acknowledged yet, but
	-- have a valid profile now.
	UPDATE n SET
		n.IsAcknowledgedFlag = 1,
		n.LastUpdate = GETUTCDATE(),
		n.LastUpdateUser = 'Nightly Job'
	FROM datNotification n
		INNER JOIN datClientEFT ceft ON ceft.ClientGUID = n.ClientGUID
	WHERE n.NotificationTypeID = @InactiveFeeProfileNotificationTypeID
		AND ceft.IsActiveFlag = 1


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
    SELECT	GETUTCDATE(),
    		@InactiveFeeProfileNotificationTypeID,
    		c.ClientGUID,
    		NULL,
    		NULL,
    		c.CenterID,
    		0,
    		'Client ' + c.ClientFullNameCalc + ' has an inactive fee profile.  Fees will not run for this client until the profile is updated.',
    		GETUTCDATE(),
    		'Nightly Job',
    		GETUTCDATE(),
    		'Nightly Job'
	FROM datClientEFT ceft
		INNER JOIN datClient c ON c.ClientGUID = ceft.ClientGUID
		LEFT JOIN datNotification n ON c.CenterID = n.CenterID AND n.NotificationTypeID = @InactiveFeeProfileNotificationTypeID
										AND n.ClientGUID = c.ClientGUID
	Where ceft.IsActiveFlag = 0
		AND (n.NotificationID IS NULL
			 OR (n.[IsAcknowledgedFlag] = 1 AND n.[LastUpdate] < DATEADD(week, -1, GETUTCDATE()))) -- Notification has been acknowledged over a week ago


END
