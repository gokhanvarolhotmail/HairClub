/* CreateDate: 12/18/2017 06:55:50.240 , ModifyDate: 02/12/2018 17:14:29.330 */
GO
/*
==============================================================================
PROCEDURE:				mtnSalesConsultationUndo

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		12/12/2017

LAST REVISION DATE: 	12/12/2017

==============================================================================
DESCRIPTION:	Used to undo sales consultation Check-In
==============================================================================
NOTES:
		* 12/12/2017 MVT - Created

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnSalesConsultationUndo] '67BAEB9D-E683-48A7-B090-5B0A715890F6', 'SALE', 'APPOINT', '00T1h000002Lg51EAC','00Qf4000003lyCNEAY', 235, 'testuser'
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnSalesConsultationUndo]
(
	@AppointmentGuid uniqueidentifier,
	@ResultCode nvarchar(50),
	@AppointmentAction nvarchar(50),
	@SalesforceTaskID nvarchar(18),
	@SalesforceContactID nvarchar(18),
	@CenterID int,
	@Username nvarchar(25)
)
AS

SET NOCOUNT ON
--SET XACT_ABORT ON

BEGIN TRY

	DECLARE @IsCheckedIn bit = 0,
			@IsCheckedOut bit = 0,
			@IsTrichoViewCompleted bit = 0,
			@IsMoneyCollected bit = 0,
			@ClientGUID uniqueidentifier,
			@ClientMembershipGUID uniqueidentifier,
			@AppointmentCreateUser nvarchar(25),
		    @AppointmentLastUpdateUser nvarchar(25)

	SELECT
		@IsCheckedIn = CASE WHEN a.CheckinTime IS NULL THEN 0 ELSE 1 END
	,	@IsCheckedOut = CASE WHEN a.CheckoutTime IS NULL THEN 0 ELSE 1 END
	,	@IsTrichoViewCompleted = CASE WHEN x_ap.AppointmentPhotoGUID IS NULL THEN 0 ELSE 1 END
	,	@IsMoneyCollected = CASE WHEN x_t.SalesOrderTender IS NULL OR x_t.SalesOrderTender = 0 THEN 0 ELSE 1 END
	,	@ClientGUID = a.ClientGUID
	,   @ClientMembershipGUID = a.ClientMembershipGUID
	,   @AppointmentCreateUser = a.CreateUser
	,   @AppointmentLastUpdateUser = a.LastUpdateUser
	FROM datAppointment a
		OUTER APPLY (
			 SELECT SUM(ABS(sot.Amount)) AS SalesOrderTender
			 FROM datSalesOrder so
				LEFT JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				LEFT JOIN lkpSalesOrderType st ON st.SalesOrderTypeID = so.SalesOrderTypeID
				LEFT JOIN lkpTenderType tt ON tt.TenderTypeID = sot.TenderTypeID
			 WHERE so.ClientMembershipGUID = a.ClientMembershipGUID
				--AND tt.TenderTypeDescriptionShort IN ('Cash','Check','CC','Finance','AR')
		) x_t
		OUTER APPLY (
			SELECT ap.AppointmentPhotoGUID
			FROM datAppointmentPhoto ap
			WHERE ap.AppointmentGUID = a.AppointmentGUID) x_ap
	WHERE a.AppointmentGUID = @AppointmentGuid


	IF EXISTS (SELECT * FROM datClientMembership cm
					INNER JOIN lkpClientMembershipStatus st ON st.ClientMembershipStatusID = cm.ClientMembershipStatusID
					INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
					WHERE cm.ClientMembershipGUID = @ClientMembershipGUID
						AND m.MembershipDescriptionShort IN ('SHOWNOSALE','SNSSURGOFF')
						AND st.ClientMembershipStatusDescriptionShort = 'A')
	BEGIN
		DECLARE @EmployeeGUID uniqueidentifier, @MembershipOrderReasonID int
		SET @EmployeeGUID = (SELECT Top(1) @EmployeeGUID FROM datAppointmentEmployee WHERE AppointmentGUID = @AppointmentGuid)

		SELECT @MembershipOrderReasonID = r.MembershipOrderReasonID
			FROM lkpMembershipOrderReason r
				INNER JOIN lkpMembershipOrderReasonType t ON r.MembershipOrderReasonTypeID = t.MembershipOrderReasonTypeID
				INNER JOIN lkpRevenueGroup rg ON rg.RevenueGroupID = r.RevenueTypeID
			WHERE t.MembershipOrderReasonTypeDescriptionShort = 'CANCEL'
				AND rg.RevenueGroupDescriptionShort = 'NB'
				AND r.MembershipOrderReasonDescriptionShort = 'DATA'

		-- Cancel Client Membership if Show No Sale or Show No Sale Surgery Offered
		EXEC utlCancelClientMembership @ClientMembershipGUID,
				@MembershipOrderReasonID, @EmployeeGUID, @CenterID, @Username

	END


	IF EXISTS (SELECT * FROM datClientMembership cm
						INNER JOIN lkpClientMembershipStatus st ON st.ClientMembershipStatusID = cm.ClientMembershipStatusID
						WHERE cm.ClientMembershipGUID = @ClientMembershipGUID AND st.ClientMembershipStatusDescriptionShort = 'A')
	BEGIN

		-- RAISE ERROR
		RAISERROR (N'Client is in an Active Membership', -- Message text.
               16, -- Severity.
               1 -- State.
			   );
	END

	DECLARE @MoneyBalance Money
	SELECT @MoneyBalance = SUM(sot.Amount)
	FROM datSalesOrder so
		INNER JOIN datSalesOrderTender sot ON sot.SalesOrderGUID = so.SalesOrderGUID
	WHERE so.ClientMembershipGUID = @ClientMembershipGUID

	IF ISNULL(@MoneyBalance, 0) <> 0
	BEGIN

		DECLARE @MoneyString varchar(30)
		SELECT @MoneyString = convert(varchar(30), @MoneyBalance, 1)

		-- RAISE ERROR
		RAISERROR (N'Please refund all Sales Orders for the Client Membership. %s is an outstanding balance.', -- Message text.
               16, -- Severity.
               1, -- State.
			   @MoneyString
			   );
	END

	INSERT INTO [dbo].[logSalesConsultationReset]
           ([AppointmentGUID]
           ,[AppointmentAction]
           ,[SalesforceTaskID]
           ,[SalesforceContactID]
           ,[CenterID]
           ,[ResultCode]
           ,[IsCheckedIn]
           ,[IsCheckedOut]
           ,[IsTrichoViewCompleted]
           ,[IsMoneyCollected]
           ,[AppointmentCreateUser]
           ,[AppointmentLastUpdateUser]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
	VALUES
           (@AppointmentGuid
		   ,@AppointmentAction
		   ,@SalesforceTaskID
		   ,@SalesforceContactID
		   ,@CenterID
		   ,@ResultCode
           ,@IsCheckedIn
           ,@IsCheckedOut
           ,@IsTrichoViewCompleted
           ,@IsMoneyCollected
		   ,@AppointmentCreateUser
		   ,@AppointmentLastUpdateUser
           ,GETUTCDATE()
           ,@Username
           ,GETUTCDATE()
           ,@Username)

	-- Delete Client Demographic Record if there is a Result Code. That
	-- indicates that the consultation was managed.
	IF (@ResultCode IS NOT NULL)
	BEGIN
		DELETE FROM datClientDemographic WHERE ClientGUID = @ClientGUID
	END

	UPDATE datAppointment SET
		IsDeletedFlag = 1
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @Username
	WHERE AppointmentGUID = @AppointmentGuid

END TRY
BEGIN CATCH

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;
GO
