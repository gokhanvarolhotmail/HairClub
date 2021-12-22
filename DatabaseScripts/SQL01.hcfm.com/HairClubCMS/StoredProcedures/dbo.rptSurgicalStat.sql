/***********************************************************************

PROCEDURE:				rptSurgicalStat

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09
						7/21/09 PRM - Updated where statement to use short description instead of full description to follow our coding standards

--------------------------------------------------------------------------------------------------------
NOTES: 	Get Surgical Statistic information for Surgical Stat subreport.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptSurgicalStat '5D044E24-96C8-4C10-B097-51C16F6F05D4'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptSurgicalStat]
	@AppointmentGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

    SELECT
		e.EmployeeFullNameCalc
	FROM datAppointment a
		INNER JOIN datAppointmentEmployee ae ON a.AppointmentGUID = ae.AppointmentGUID
		INNER JOIN datEmployee e ON ae.EmployeeGUID = e.EmployeeGUID
		INNER JOIN cfgEmployeePositionJoin epj ON e.EmployeeGUID = epj.EmployeeGUID
		INNER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
	WHERE a.AppointmentGUID = @AppointmentGUID
      AND ep.EmployeePositionDescriptionShort = 'MedAsstn'

END
