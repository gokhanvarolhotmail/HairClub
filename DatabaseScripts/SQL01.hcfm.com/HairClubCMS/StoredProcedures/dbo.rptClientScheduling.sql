/*
==============================================================================

PROCEDURE:				rptClientScheduling
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HairclubCMS
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		10/2/2014

==============================================================================
DESCRIPTION: A report that will show the clients scheduled and contact info
		to allow managers to contact clients in the case that a center is
		going to be closed.
==============================================================================
NOTES:
08/05/2015    RH      Added code to set the end date to 11:59PM
04/27/2017    PRM     Updated to reference new datClientPhone table
==============================================================================

SAMPLE EXECUTION:

EXEC [rptClientScheduling] 201, '8/5/2015', '8/5/2015'

==============================================================================
*/
CREATE PROCEDURE [dbo].[rptClientScheduling] (
	@CenterID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

SET @EndDate = (SELECT DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,@EndDate+1),0) ))) --11:59 PM

SELECT
	ap.AppointmentGUID
,	ap.ClientGUID
,	clt.ClientFullNameCalc
,	sty.EmployeeGUID StylistGUID
,	sty.EmployeeFullNameCalc Stylist
,	ce.CenterDescriptionFullCalc
,	m.MembershipDescription
,	ap.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) AS 'ApptTime'
,	sc.SalesCodeDescription
,	cp1.PhoneNumber AS Phone1
,	clt.DoNotCallFlag
,	clt.EMailAddress
,	clt.DoNotContactFlag
,	CT.ConfirmationTypeDescription
FROM dbo.datAppointment ap
	INNER JOIN dbo.datAppointmentDetail ad ON ad.AppointmentGUID = ap.AppointmentGUID
	INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = ad.SalesCodeID
	INNER JOIN dbo.datAppointmentEmployee ae ON ae.AppointmentGUID = ap.AppointmentGUID
	INNER JOIN datEmployee sty ON sty.EmployeeGUID = ae.EmployeeGUID
	INNER JOIN datClient clt ON clt.ClientGUID = ap.ClientGUID
    OUTER APPLY (SELECT TOP 1 PhoneNumber
                    FROM datClientPhone cp
                    WHERE clt.ClientGUID = cp.ClientGUID
                    ORDER BY cp.ClientPhoneSortOrder
                ) cp1
	INNER JOIN cfgCenter ce ON ce.CenterID = ap.CenterID
	INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = ap.ClientMembershipGUID --Pull the client membership from the appointment to match the Appointment2.rdl
	INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
	LEFT JOIN dbo.lkpConfirmationType CT ON ap.ConfirmationTypeID = CT.ConfirmationTypeID
WHERE ap.AppointmentDate >= @StartDate
	AND ap.AppointmentDate < @EndDate
	AND ISNULL(ap.IsDeletedFlag, 0) = 0
	AND ap.CenterID = @CenterID
ORDER BY ap.AppointmentDate
,	ap.StartTime
,	ap.EndTime
,	sty.EmployeeFullNameCalc

END
