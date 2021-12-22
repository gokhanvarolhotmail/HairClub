/* CreateDate: 03/01/2017 12:14:26.663 , ModifyDate: 05/21/2017 22:19:15.553 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:                  [rptAppointment2_FutureAppointments]
-- Procedure Description:
--
-- Created By:                Rachelen Hut
-- Date Created:              03/01/2017
-- Date Implemented:          03/01/2017

--
-- Destination Server:        HairclubCMS
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**

================================================================================================
Sample Execution:
EXEC [rptAppointment2_FutureAppointments]'3C7319C7-FCF2-42F0-9048-659B4BF176B1'  --Arthur Whalen

EXEC [rptAppointment2_FutureAppointments]'6BCF99E5-EF86-4323-ADDC-12CCD369C1FE'  --Charlotte Fennel

EXEC [rptAppointment2_FutureAppointments]'50969714-78F1-4C9B-8B6A-9E55AAFC6FB5'  --Gail Jackson

EXEC [rptAppointment2_FutureAppointments] '47B471C5-6017-4123-B3DA-8E7C4EB40A56'  --Joy Salas

================================================================================================*/

CREATE PROCEDURE [dbo].[rptAppointment2_FutureAppointments]
	@ClientGUID UNIQUEIDENTIFIER
AS
BEGIN

	SELECT  TOP 6 ap.AppointmentDate
		,	DATENAME(dw,ap.AppointmentDate) AS 'DayOfWeek'
		,	ap.ClientGUID
		,	ap.CenterID
		,	clt.ClientFullNameAltCalc
		,	c.CenterDescriptionFullCalc
		,	cp1.PhoneNumber AS Phone1
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) StartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) EndTime
		,	apd.AppointmentDetailDuration
		,	sc.SalesCodeDescription
		,	e.EmployeeInitials
		,	e.EmployeeFullNameCalc
	FROM datAppointment ap
		INNER JOIN datAppointmentDetail apd ON apd.AppointmentGUID = ap.AppointmentGUID
		INNER JOIN cfgCenter c ON ap.CenterID = c.CenterID
		INNER JOIN dbo.datClient clt ON ap.ClientGUID = clt.ClientGUID
        OUTER APPLY (SELECT TOP 1 PhoneNumber
                        FROM datClientPhone cp
                        WHERE clt.ClientGUID = cp.ClientGUID
                        ORDER BY cp.ClientPhoneSortOrder
                    ) cp1
		INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = apd.SalesCodeID
		INNER JOIN datAppointmentEmployee ape ON ape.AppointmentGUID = ap.AppointmentGUID
		INNER JOIN datEmployee e ON e.EmployeeGUID = ape.EmployeeGUID
		INNER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = e.EmployeeGUID
		INNER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
	WHERE ap.ClientGUID = @ClientGUID
		AND ap.AppointmentDate > GETUTCDATE()
		AND ap.CheckedInFlag = 0
		AND ep.CanScheduleStylist = 1
		AND ap.IsDeletedFlag = 0
	GROUP BY DATENAME(dw,ap.AppointmentDate)
           , LTRIM(RIGHT(CONVERT(VARCHAR(25) ,ap.StartTime ,100) ,7))
           , LTRIM(RIGHT(CONVERT(VARCHAR(25) ,ap.EndTime ,100) ,7))
           , ap.AppointmentDate
           , ap.ClientGUID
           , ap.CenterID
           , clt.ClientFullNameAltCalc
           , c.CenterDescriptionFullCalc
           , cp1.PhoneNumber
           , apd.AppointmentDetailDuration
           , sc.SalesCodeDescription
           , e.EmployeeInitials
           , e.EmployeeFullNameCalc
	ORDER BY ap.AppointmentDate ASC  --Keep ascending to show the next six appointments
	, LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7))

END
GO
