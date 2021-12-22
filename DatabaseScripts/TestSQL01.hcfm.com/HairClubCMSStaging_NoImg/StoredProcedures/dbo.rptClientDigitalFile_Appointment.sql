/* CreateDate: 12/18/2015 11:13:41.547 , ModifyDate: 12/18/2015 11:13:41.547 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptClientDigitalFile_Appointment
 Procedure Description:     This stored procedure provides all of the appointment information for the client digital file.
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              12/14/2015
 Destination Server:        SQL01
 Destination Database:      HairclubCMS

================================================================================================
**NOTES**

================================================================================================
Sample Execution:

EXEC [rptClientDigitalFile_Appointment] 105270  --Arthur Whalen (283)

================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientDigitalFile_Appointment]
	@ClientIdentifier INT
AS
BEGIN

DECLARE @ClientGUID UNIQUEIDENTIFIER

--Find the ClientGUID using the @ClientIdentifier

SET @ClientGUID = (SELECT TOP 1 ClientGUID FROM datClient WHERE ClientIdentifier = @ClientIdentifier)

	SELECT ap.AppointmentDate
		,	LEFT(DD.DayOfWeekName,2) AS 'DayOfWeek'
		,	ap.ClientGUID
		,	ap.CenterID
		,	clt.ClientFullNameAltCalc
		,	c.CenterDescriptionFullCalc
		,	c.Phone1
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) StartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) EndTime
		,	apd.AppointmentDetailDuration
		,	sc.SalesCodeDescription
		,	e.EmployeeInitials
		,	e.EmployeeFullNameCalc
		,	ap.CheckoutTime
		,	ap.CompletedVisitTypeID
		,	CVT.CompletedVisitTypeDescription
		,	ap.CheckedInFlag
		,	CASE WHEN ap.AppointmentDate > GETDATE() THEN 'Future' ELSE 'Previous' END AS 'Future'
	FROM datAppointment ap
	INNER JOIN SQL06.HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON ap.AppointmentDate = DD.FullDate
	INNER JOIN datAppointmentDetail apd
		ON apd.AppointmentGUID = ap.AppointmentGUID
	INNER JOIN cfgCenter c
		ON ap.CenterID = c.CenterID
	INNER JOIN dbo.datClient clt
		ON ap.ClientGUID = clt.ClientGUID
	INNER JOIN cfgSalesCode sc
		ON sc.SalesCodeID = apd.SalesCodeID
	INNER JOIN datAppointmentEmployee ape
		ON ape.AppointmentGUID = ap.AppointmentGUID
	INNER JOIN datEmployee e
		ON e.EmployeeGUID = ape.EmployeeGUID
	INNER JOIN cfgEmployeePositionJoin epj
		ON epj.EmployeeGUID = e.EmployeeGUID
	INNER JOIN lkpEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionID
	LEFT OUTER JOIN dbo.lkpCompletedVisitType CVT
		ON ap.CompletedVisitTypeID = CVT.CompletedVisitTypeID
	WHERE ap.ClientGUID = @ClientGUID
		AND ap.IsDeletedFlag = 0
	GROUP BY ap.AppointmentDate
		,	LEFT(DD.DayOfWeekName,2)
		,	ap.ClientGUID
		,	ap.CenterID
		,	clt.ClientFullNameAltCalc
		,	c.CenterDescriptionFullCalc
		,	c.Phone1
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7))
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7))
		,	apd.AppointmentDetailDuration
		,	sc.SalesCodeDescription
		,	e.EmployeeInitials
		,	e.EmployeeFullNameCalc
		,	ap.CheckoutTime
		,	ap.CompletedVisitTypeID
		,	CVT.CompletedVisitTypeDescription
		,	ap.CheckedInFlag
	ORDER BY ap.AppointmentDate, LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7))

END
GO
