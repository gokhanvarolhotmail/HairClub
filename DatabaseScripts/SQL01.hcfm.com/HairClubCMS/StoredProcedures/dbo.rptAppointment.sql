/***********************************************************************

PROCEDURE:				rptAppointment

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	7/6/09 PRM - Formatted date/times, added home center

--------------------------------------------------------------------------------------------------------
NOTES: 	Get data for appointment report.

	02/11/13	MLM - Added ClientNotes
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptAppointment '77D43560-5623-4F93-8A7F-9D77976F792D'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptAppointment]
	@AppointmentGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		c.ClientFullNameCalc,
		a.AppointmentDate,
		CAST(a.StartTime AS datetime) AS StartTime,
		CAST(a.EndTime AS datetime) AS EndTime,
		a.AppointmentDurationCalc,
		gm.MembershipDescription,
		ct.CenterDescriptionFullCalc,
		ctHome.CenterDescriptionFullCalc AS HomeCenterDescriptionFullCalc,
		nc.NotesClient
	FROM datAppointment a
		LEFT OUTER JOIN datAppointmentDetail ad ON a.AppointmentGUID = ad.AppointmentGUID
		INNER JOIN datClient c ON a.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm ON a.ClientGUID = cm.ClientGUID
		INNER JOIN cfgMembership gm ON cm.MembershipID = gm.MembershipID
		INNER JOIN cfgCenter ct ON a.CenterID = ct.CenterID
		INNER JOIN cfgCenter cthome ON a.ClientHomeCenterID = cthome.CenterID
		LEFT OUTER JOIN datNotesClient nc on a.AppointmentGUID = nc.AppointmentGUID
	WHERE a.AppointmentGUID = @AppointmentGUID

END
