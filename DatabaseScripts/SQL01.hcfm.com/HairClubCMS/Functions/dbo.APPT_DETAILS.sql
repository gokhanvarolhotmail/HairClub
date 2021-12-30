/* CreateDate: 02/25/2009 10:26:42.470 , ModifyDate: 02/27/2017 09:49:36.753 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[APPT_DETAILS] (@CenterID as int, @AppointmentGUID as uniqueidentifier)
RETURNS varchar(255) AS
BEGIN

	DECLARE @code varchar(15)
	DECLARE @output varchar(100)

	SELECT @output='CODES:'

	DECLARE Appointment_Cursor CURSOR
	FOR
		SELECT sc.SalesCodeDescriptionShort
		FROM datAppointmentDetail ad
			INNER JOIN cfgSalesCode sc ON ad.SalesCodeID = sc.SalesCodeID
		WHERE ad.AppointmentGUID = @AppointmentGUID
		FOR READ ONLY

	OPEN Appointment_Cursor
	FETCH NEXT FROM Appointment_Cursor INTO @code
	WHILE @@FETCH_STATUS = 0
	BEGIN
	   SELECT @output=@output+@code+','
	   FETCH NEXT FROM Appointment_Cursor INTO @code
	END

	CLOSE Appointment_Cursor
	DEALLOCATE Appointment_Cursor

	RETURN(LEFT(@output,LEN(@output)-1))

END
GO
