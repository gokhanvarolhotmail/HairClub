/*===============================================================================================
-- Procedure Name:			rptDeletedAppointments
-- Procedure Description:
--
-- Created By:				Mike Maass
-- Implemented By:			Mike Maass
-- Last Modified By:		Mike Maass
--
-- Date Created:			10/07/2013
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:

	10/07/13	MLM		Initial Creation
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptDeletedAppointments] 292, '2013-10-01', '2013-10-31', NULL
================================================================================================*/
CREATE PROCEDURE [dbo].[rptDeletedAppointments]
(
	@CenterID INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@StylistGUID UNIQUEIDENTIFIER = NULL -- NULL All  for center
)
AS
BEGIN
	SET NOCOUNT ON;

		SELECT
		ap.AppointmentGUID
		,ap.ClientGUID
		,cl.ClientFullNameCalc Client
		,sty.EmployeeGUID
		,sty.EmployeeFullNameCalc Stylist
		,ce.CenterDescriptionFullCalc
		,m.MembershipDescription
		,cm.EndDate AS RenewalDate

		,ap.AppointmentDate ApptDate
		,LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) ApptTime
		,LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) as StartTime
		,LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) as EndTime
		,sc.SalesCodeDescription
		,ad.AppointmentDetailDuration
		,cl.ARBalance AR

		,ap.LastUpdate as LastUpdate
		,emp.EmployeeFullNameCalc as LastUpdateUser

		FROM dbo.datAppointment ap
		INNER JOIN dbo.datAppointmentDetail ad ON ad.AppointmentGUID = ap.AppointmentGUID
			INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = ad.SalesCodeID

		INNER JOIN dbo.datAppointmentEmployee ae ON ae.AppointmentGUID = ap.AppointmentGUID
			INNER JOIN datEmployee sty ON sty.EmployeeGUID = ae.EmployeeGUID
				AND ( sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)

		INNER JOIN datClient cl ON cl.ClientGUID = ap.ClientGUID
			INNER JOIN cfgCenter ce ON ce.CenterID = ap.CenterID

		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
			INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID

		INNER JOIN datEmployee emp on ap.LastUpdateUser = emp.UserLogin

		WHERE ap.AppointmentDate BETWEEN @StartDate AND @EndDate
			AND ISNULL(ap.IsDeletedFlag, 0) = 1
			AND ap.CenterID = @CenterID
		ORDER BY ap.StartTime, ap.EndTime,sty.EmployeeFullNameCalc

END
