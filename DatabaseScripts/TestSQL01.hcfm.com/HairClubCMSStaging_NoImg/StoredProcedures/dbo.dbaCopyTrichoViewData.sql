/* CreateDate: 08/24/2015 12:43:43.303 , ModifyDate: 08/24/2015 12:43:43.303 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaCopyTrichoViewData

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/21/15

LAST REVISION DATE: 	08/21/15

--------------------------------------------------------------------------------------------------------
NOTES:  Copies all TrichoView data from one appointment to anoother
	* 08/21/15 MVT - Created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [dbaCopyTrichoViewData] 'fd649763-6256-4b78-bdf8-d1af03fa6a26', 'a84dbe63-d454-4fe1-b5d0-c1f681114037'

***********************************************************************/
CREATE PROCEDURE [dbo].[dbaCopyTrichoViewData]
	@CopyFromAppointmentGUID uniqueidentifier,
	@CopyToAppointmentGUID uniqueidentifier,
	@UpdateUser nvarchar(25) = 'TV-Copy'

AS
BEGIN


SET XACT_ABORT ON
SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION

		UPDATE a SET
			a.ScalpHealthID = cfrom.ScalpHealthID,
			a.AppointmentPriorityColorID = cfrom.AppointmentPriorityColorID,
			a.CompletedVisitTypeID = cfrom.CompletedVisitTypeID,
			a.LastUpdate = GETUTCDATE(),
			a.LastUpdateUser = @UpdateUser
		FROM datAppointment a
			INNER JOIN datAppointment cfrom ON cfrom.AppointmentGUID = @CopyFromAppointmentGUID
		WHERE a.AppointmentGUID = @CopyToAppointmentGUID


		UPDATE cfrom SET
			AppointmentGUID = @CopyToAppointmentGUID,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @UpdateUser
		FROM datAppointmentPhoto cfrom
		WHERE cfrom.AppointmentGUID = @CopyFromAppointmentGUID


		UPDATE cfrom SET
			AppointmentGUID = @CopyToAppointmentGUID,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @UpdateUser
		FROM datAppointmentSebuTape cfrom
		WHERE cfrom.AppointmentGUID = @CopyFromAppointmentGUID


	COMMIT TRANSACTION

END TRY
BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		DECLARE @ErrorProcedure NVARCHAR(200);

		SELECT @ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorProcedure = ERROR_PROCEDURE();

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH


END
GO
