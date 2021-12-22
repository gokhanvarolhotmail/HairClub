/* CreateDate: 12/02/2014 12:26:59.430 , ModifyDate: 12/02/2014 12:26:59.430 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edmund Poillion
-- Create date: 11/21/2014
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[dbaETUpdateAppointmentConfirmation]
	@AppointmentGUID uniqueidentifier,
	@AppointmentDateTime datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Utility].[dbo].[ET_Log] ([RunDate],[ProcName],[AppointmentGUID],[ClientGUID],[AppointmentDateTime],[IsEmailUndeliverable],[IsAutoConfirmEmail])
		VALUES (GETDATE(),'[dbo].[dbaETUpdateAppointmentConfirmation]',@AppointmentGUID,null,@AppointmentDateTime,null,null);

	UPDATE
		[dbo].[datAppointment]
	SET
		ConfirmationTypeID = 6
	WHERE
		AppointmentGUID = @AppointmentGuid
		AND StartDateTimeCalc = @AppointmentDateTime;

	UPDATE
		[dbo].[datAppointment]
	SET
		ConfirmationTypeID = 9
	WHERE
		AppointmentGUID = @AppointmentGuid
		AND StartDateTimeCalc <> @AppointmentDateTime;

END
GO
