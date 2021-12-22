/* CreateDate: 12/19/2013 07:34:11.933 , ModifyDate: 05/21/2017 22:19:15.623 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:                  rptClientOverview_FutureAppointments
-- Procedure Description:
--
-- Created By:                Mike Maass
-- Implemented By:            Marlon Burrell
-- Last Modified By:          Rachelen Hut
--
-- Date Created:              11/22/2013
-- Date Implemented:
-- Date Last Modified:        11/22/2013
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**
	11/22/13	RMH		Created stored procedure based on the code imbedded in the report.
	7/7/2014	RMH		Added fields ap.ClientGUID,	ap.CenterID, clt.ClientFullNameAltCalc,	c.CenterDescriptionFullCalc,
							e.EmployeeFullNameCalc and c.Phone1
	8/13/2014	RMH		Added a GROUP BY to remove duplicates.
	12/11/2015	RMH		Added Day of Week (WO#121413)
	02/22/2017  RMH		Changed call to SQL06 to use a SQL function for Day of Week; added top 6 (#134857)
	03/01/2017  RMH		Removed top 6 (#134857) - this affected the Membership Summary report.
	04/27/2017  PRM     Updated to reference new datClientPhone table
================================================================================================
Sample Execution:
EXEC [rptClientOverview_FutureAppointments]'3C7319C7-FCF2-42F0-9048-659B4BF176B1'  --Arthur Whalen

EXEC [rptClientOverview_FutureAppointments]'6BCF99E5-EF86-4323-ADDC-12CCD369C1FE'  --Charlotte Fennel

EXEC [rptClientOverview_FutureAppointments]'50969714-78F1-4C9B-8B6A-9E55AAFC6FB5'  --Gail Jackson

EXEC [rptClientOverview_FutureAppointments] '47B471C5-6017-4123-B3DA-8E7C4EB40A56'  --Joy Salas

================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientOverview_FutureAppointments]
	@ClientGUID UNIQUEIDENTIFIER
AS
BEGIN

	SELECT  ap.AppointmentDate
		--,	LEFT(DD.DayOfWeekName,2) AS 'DayOfWeek'
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
	--INNER JOIN SQL06.HC_BI_ENT_DDS.bief_dds.DimDate DD
	--	ON ap.AppointmentDate = DD.FullDate
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
           ,	cp1.PhoneNumber
           , apd.AppointmentDetailDuration
           , sc.SalesCodeDescription
           , e.EmployeeInitials
           , e.EmployeeFullNameCalc
	ORDER BY ap.AppointmentDate ASC
	, LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7))

END
GO
