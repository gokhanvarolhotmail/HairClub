/***********************************************************************

PROCEDURE:				mtnGetCheckedInAppts	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/11/2012

LAST REVISION DATE:		4/11/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	* 4/11/2012	    KMurdoch	Initial Creation
							    Requires new column added to datAppointment (CheckedInFlag)
	* 04/27/2017    PRM         Updated to reference new datClientPhone table

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
EXEC mtnGetCheckedInAppts 201,'04/11/17', 'adoczy', 'C'

	CenterID = Logged in Center
	Date = Today's date only
	UserLogin = Logged in Active Directory UserID
	ApptStatus = 'A' for All, 'C' for only Checked In
		***This can be used as a toggle for the stylist to Review ALL appts for the day
***********************************************************************/


CREATE   PROCEDURE [dbo].[mtnGetCheckedInAppts] (
	@center int
,	@Date smalldatetime
,	@UserLogin varchar(20)
,	@ApptStatus varchar
) AS
	BEGIN


	SET NOCOUNT ON

	DECLARE @ApptStatFrom INT
	DECLARE	@ApptStatTo INT

	SET @ApptStatFrom = CASE WHEN @ApptStatus = 'A' THEN 0 ELSE 1 END
	SET @ApptStatTo = 1

			SELECT
				CONVERT(VARCHAR, appt.StartTime,100) AS 'DisplayStartTime',
				appt.StartTime AS 'StartTime',
				client.ClientIdentifier AS 'ClientNumber',
				client.ClientFullNameCalc AS 'ClientFullNamewNumber',
				client.ClientFullNameAltCalc AS 'ClientFullName',
				client.ClientFullNameAlt2Calc AS 'ClientLNFirst',
				client.FirstName AS 'ClientFirstName',
				client.LAStName AS 'ClientLAStName',
				client.Address1 AS 'Address1',
				client.Address2 AS 'Address2',
				client.City AS 'City',
				st.StateDescriptionShort AS 'State',
				client.PostalCode AS 'Zip',
				(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = client.ClientGUID ORDER BY ClientPhoneSortOrder) as 'PhoneUnformatted',
				(SELECT TOP 1 '('+ LEFT(PhoneNumber,3) + ') ' + SUBSTRING(PhoneNumber, 4,3) + '-' + RIGHT(PhoneNumber,4) FROM datClientPhone WHERE ClientGUID = client.ClientGUID ORDER BY ClientPhoneSortOrder) as 'PhoneFormatted',
				(SELECT TOP 1 PhoneTypeDescription FROM datClientPhone cp LEFT JOIN lkpPhoneType pt ON cp.PhoneTypeID = pt.PhoneTypeID WHERE ClientGUID = client.ClientGUID ORDER BY ClientPhoneSortOrder) as 'PhoneType',
				client.EMailAddress AS 'Email',
				gender.GenderDescription AS 'Gender',
				mem.MembershipDescription AS 'MembershipDescription',
				clientmem.EndDate AS 'MembershipExpiration',
				appt.AppointmentSubject AS 'ApptSubject',
				busseg.BusinessSegmentDescription AS 'BusinessSegmentLongDesc',
				busseg.BusinessSegmentDescriptionShort AS 'BusinessSegmentShortDesc',
				emp.EmployeeFullNameCalc,
				emp.UserLogin,
				appt.ClientGUID AS 'ClientGUID',
				appt.AppointmentGUID AS 'AppointmentGUID',
				apptemp.EmployeeGUID AS 'EmployeeGUID'
			FROM datAppointment appt
				INNER JOIN datAppointmentEmployee apptemp ON appt.AppointmentGUID = apptemp.AppointmentGUID
				INNER JOIN datClient client ON appt.clientguid = client.ClientGUID
				INNER JOIN datClientMembership clientmem ON appt.ClientMembershipGUID = clientmem.ClientMembershipGUID
				INNER JOIN datEmployee emp ON apptemp.EmployeeGUID = emp.EmployeeGUID
				INNER JOIN cfgMembership mem ON clientmem.MembershipID = mem.MembershipID
				INNER JOIN lkpBusinessSegment busseg ON mem.BusinessSegmentID = busseg.BusinessSegmentID
				INNER JOIN lkpState st ON client.StateID = st.StateID
				INNER JOIN lkpGender gender ON client.GenderID = gender.GenderID

			WHERE
					AppointmentDate = @Date
				AND appt.CenterID = @center
				--AND emp.UserLogin = @UserLogin
				AND appt.CheckedInFlag between @ApptStatFrom AND @ApptStatTo
				AND appt.CheckoutTime IS NULL
			ORDER BY appt.starttime
		END
