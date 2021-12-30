/* CreateDate: 06/10/2013 20:12:27.190 , ModifyDate: 01/21/2014 23:48:44.130 */
GO
/***********************************************************************

PROCEDURE:				extBosleyUpdateProcedureAppointment

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/05/13

LAST REVISION DATE: 	06/05/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Updates/Creates Procedure Appointment
	* 06/05/13	MVT		Created
	* 10/01/13	MVT		Modified to include Procedure Status in the Appointment subject if processing
						ProcedureUpdate process.
	*12/19/13	MVT		Modified for the new datAppointment fields (Last Change Date/User)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyUpdateProcedureAppointment] @CurrentTransactionIdBeingProcessed

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyUpdateProcedureAppointment]
	  @CurrentTransactionIdBeingProcessed INT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(10) = 'Bosley'

	IF EXISTS (SELECT * FROM datIncomingRequestLog irl WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed AND [ProcedureDate] IS NOT NULL)
	BEGIN

		DECLARE @BosleyAppointmentTypeID int
		DECLARE @AppointmentGUID uniqueidentifier
		DECLARE @Subject as nvarchar(50)
		DECLARE @ProcedureStatus as nvarchar(100)

		Select @BosleyAppointmentTypeID = AppointmentTypeId  from lkpAppointmentType Where AppointmentTypeDescriptionShort = 'BosleyAppt'

		SELECT @Subject = CASE WHEN irl.ProcessName = 'ProcedureDone' THEN 'Surgery Completed'
							ELSE 'Surgery Scheduled' END,
				@ProcedureStatus = CASE WHEN irl.ProcessName = 'ProcedureDone' THEN NULL
							ELSE irl.ProcedureStatus END
		FROM datIncomingRequestLog irl
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

		IF @ProcedureStatus IS NOT NULL
		BEGIN
			SET @Subject = @Subject + ' (' + @ProcedureStatus + ')'
		END


		SELECT @AppointmentGUID = a.AppointmentGuid
		FROM datIncomingRequestLog irl
			INNER JOIN datClientMembership cm ON irl.[ClientMembershipID] = cm.ClientMembershipIdentifier
			INNER JOIN datAppointment a ON a.ClientMembershipGUID = cm.ClientMembershipGUID
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			AND a.AppointmentTypeID = @BosleyAppointmentTypeID

		IF @AppointmentGUID IS NULL
		BEGIN
			INSERT INTO [dbo].[datAppointment]
					([AppointmentGUID]
					,[AppointmentID_Temp]
					,[ClientGUID]
					,[ClientMembershipGUID]
					,[ParentAppointmentGUID]
					,[CenterID]
					,[ClientHomeCenterID]
					,[ResourceID]
					,[ConfirmationTypeID]
					,[AppointmentTypeID]
					,[AppointmentDate]
					,[StartTime]
					,[EndTime]
					,[CheckinTime]
					,[CheckoutTime]
					,[AppointmentSubject]
					,[CanPrintCommentFlag]
					,[IsNonAppointmentFlag]
					,[RecurrenceRule]
					,[CreateDate]
					,[CreateUser]
					,[LastUpdate]
					,[LastUpdateUser]
					,[AppointmentStatusID]
					,[IsDeletedFlag]
					,[OnContactActivityID]
					,[OnContactContactID]
					,[LastChangeDate]
					,[LastChangeUser])
				SELECT NEWID()
					,NULL
					,c.ClientGUID
					,cm.ClientMembershipGUID
					,NULL
					,c.CenterID
					,c.CenterID
					,NULL
					,NULL
					,@BosleyAppointmentTypeID
					,DATEADD(dd, 0, DATEDIFF(dd, 0, irl.[ProcedureDate]))
					,CAST(irl.[ProcedureDate] as time) -- start time
					,CAST(DATEADD (hour , 1 , irl.[ProcedureDate]) as time) -- end time
					,NULL
					,NULL
					,@Subject
					,0
					,0
					,NULL
					,GETUTCDATE()
					,@User
					,GETUTCDATE()
					,@User
					,NULL
					,0
					,NULL
					,NULL
					,GETUTCDATE()
					,@User
				FROM datIncomingRequestLog irl
					INNER JOIN datClientMembership cm ON irl.[ClientMembershipID] = cm.ClientMembershipIdentifier
					INNER JOIN datClient c ON irl.ConectID = c.ClientIdentifier
				WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

		END
		ELSE
		BEGIN
				-- Update Appointment
				UPDATE a SET
					a.AppointmentDate = DATEADD(dd, 0, DATEDIFF(dd, 0, irl.[ProcedureDate]))
					,a.StartTime = CAST(irl.[ProcedureDate] as time) -- start time
					,a.EndTime = CAST(DATEADD (hour , 1 , irl.[ProcedureDate]) as time) -- end time
					,a.AppointmentSubject = @Subject
				FROM datAppointment a
					INNER JOIN datIncomingRequestLog irl ON irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				WHERE a.AppointmentGuid = @AppointmentGUID
		END
	END

END
GO
