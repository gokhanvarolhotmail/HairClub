/* CreateDate: 12/12/2019 16:08:56.590 , ModifyDate: 12/12/2019 16:26:42.910 */
GO
/***********************************************************************
		PROCEDURE: 				[fn_GetPreviousAppointmentDate]
		DESTINATION SERVER:		SQL01
		DESTINATION DATABASE:	HairClubCMS
		AUTHOR:					Michael Maass
		DATE IMPLEMENTED:		2013-01-15
		--------------------------------------------------------------------------------------------------------
		NOTES:
		--------------------------------------------------------------------------------------------------------
		Sample Execution:
		SELECT dbo.[fn_GetPreviousAppointmentDate] ('21948A51-CFF1-4587-9C1F-D98642DE990A')
		***********************************************************************/
		CREATE FUNCTION [dbo].[fn_GetPreviousAppointmentDate]
		(
			@ClientMembershipGUID CHAR(36)
		)
		RETURNS DATETIME
		AS
		BEGIN

			DECLARE @PreviousAppointmentDate DATETIME

			SELECT top 1 @PreviousAppointmentDate = a.AppointmentDate
			FROM datAppointment a
			Where a.AppointmentDate < CAST(GETDATE() as DATE)
				AND a.ClientMembershipGUID = @ClientMembershipGUID
				AND a.IsDeletedFlag = 0
				AND a.CheckedInFlag = 1
			Order by a.StartDateTimeCalc desc

			RETURN @PreviousAppointmentDate

		END
GO
