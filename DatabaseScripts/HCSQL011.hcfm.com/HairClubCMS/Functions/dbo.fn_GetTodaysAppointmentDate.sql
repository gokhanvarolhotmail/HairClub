/* CreateDate: 12/22/2015 11:55:44.540 , ModifyDate: 12/22/2015 12:10:37.010 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[fn_GetTodaysAppointmentDate]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Michael Maass
DATE IMPLEMENTED:		2013-01-15
--------------------------------------------------------------------------------------------------------
NOTES:
	12/22/2015	RLM - Created this function to find today's appointments for the TrichoView Progress Reviews Due report
--------------------------------------------------------------------------------------------------------
Sample Execution:
SELECT dbo.[fn_GetTodaysAppointmentDate] ('D0F13430-0DC0-4CBA-B445-CF19D64B8CA9')
***********************************************************************/
CREATE FUNCTION [dbo].[fn_GetTodaysAppointmentDate]
(
	@ClientMembershipGUID CHAR(36)
)
RETURNS DATETIME
AS
BEGIN

DECLARE @TodaysAppointmentDate NVARCHAR(25)
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)						--Today at 12:00AM
SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) )) --Today at 11:59PM

	SELECT TOP 1 @TodaysAppointmentDate = CAST(a.AppointmentDate AS NVARCHAR(12)) + ' ' + CAST(a.StartTime AS NVARCHAR(10))
	FROM datAppointment a
	WHERE a.AppointmentDate BETWEEN @StartDate AND @EndDate
		AND a.ClientMembershipGUID = @ClientMembershipGUID
		AND a.IsDeletedFlag = 0
	ORDER BY a.StartDateTimeCalc

	RETURN @TodaysAppointmentDate

END
GO
