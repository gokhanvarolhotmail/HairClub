/* CreateDate: 02/18/2013 07:43:35.670 , ModifyDate: 02/27/2017 09:49:37.060 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
		PROCEDURE: 				[fn_GetNextAppointmentDate]
		DESTINATION SERVER:		SQL01
		DESTINATION DATABASE:	HairClubCMS
		AUTHOR:					Michael Maass
		DATE IMPLEMENTED:		2013-01-15
		--------------------------------------------------------------------------------------------------------
		NOTES:
			5/22/13	MLM - Fixed Issue with Future Appointments not displaying correctly.
		--------------------------------------------------------------------------------------------------------
		Sample Execution:
		SELECT dbo.[fn_GetNextAppointmentDate] ('8A839DD5-C833-4381-A9D4-1210506EB644')
		***********************************************************************/
		CREATE FUNCTION [dbo].[fn_GetNextAppointmentDate]
		(
			@ClientMembershipGUID CHAR(36)
		)
		RETURNS DATETIME
		AS
		BEGIN

			DECLARE @NextAppointmentDate DATETIME

			SELECT top 1 @NextAppointmentDate = a.AppointmentDate
			FROM datAppointment a
			Where a.AppointmentDate > CAST(GETDATE() as DATE)
				AND a.ClientMembershipGUID = @ClientMembershipGUID
				AND a.IsDeletedFlag = 0
				AND a.CheckedInFlag = 0
			Order by a.StartDateTimeCalc

			RETURN @NextAppointmentDate

		END
GO
