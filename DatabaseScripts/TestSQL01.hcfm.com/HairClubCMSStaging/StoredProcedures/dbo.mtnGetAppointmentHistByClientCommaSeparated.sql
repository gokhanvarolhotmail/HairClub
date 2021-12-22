/* CreateDate: 02/18/2013 06:45:39.270 , ModifyDate: 02/27/2017 09:49:19.943 */
GO
/***********************************************************************

PROCEDURE:				mtnGetAppointmentHistByClientCommaSeparated	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/23/2012

LAST REVISION DATE:		4/23/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	4/23/2012	KMurdoch	Initial Creation

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetAppointmentHistByClientCommaSeparated '201','4784631D-8BE0-4902-A98B-832A7561419A'

	CenterID = Logged in Center
	ClientGUID = From datAppointment - ClientGUID
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnGetAppointmentHistByClientCommaSeparated] (
	@CenterID int
,	@ClientGUID UniqueIdentifier

) AS
	BEGIN

	SET NOCOUNT ON

	SELECT a.AppointmentGUID,
		MAX(SUBSTRING(dbo.fnGetAppointmentServiceList(a.AppointmentGUID),2,1000)) as 'ServicesProvided'
	INTO #Services
	FROM datAppointment a
		INNER JOIN datAppointmentDetail ad
			on a.AppointmentGUID = ad.AppointmentGUID
	WHERE ClientGUID = @ClientGUID
	group by a.AppointmentGUID

	SELECT
			appt.ClientGUID as 'ClientGUID'
		,	appt.AppointmentGUID as 'AppointmentGUID'
		,	appt.AppointmentDate as 'AppointmentDate'
		,	MAX(#Services.ServicesProvided) as 'ServicesProvided'
		--,	sc.SalesCodeDescription as 'ServiceProvided'
		--,	sc.SalesCodeID as 'SalesCodeID'
		--,	sc.SalesCodeSortOrder as 'SalesCodeSortOrder'
		--,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		--,	sc.SalesCodeDescription as 'SalesCodeDescription'
		--,	sc.IsSalesCodeKitFlag as 'IsKitFlag'
		,	MAX(case when apptphoto.PhotoCaptionID = 1 then apptphoto.PhotoCaptionID else null end) as 'HeadScan'
		,	MAX(case when apptphoto.PhotoCaptionID = 2 then apptphoto.PhotoCaptionID else null end) as 'MicroScan'
		,	max(nc.NotesClient) as 'AppointmentNotes'
	FROM datAppointment appt
		inner join #Services
			on appt.AppointmentGUID = #Services.AppointmentGUID
		inner join datClientMembership clm
			on appt.ClientMembershipGUID = clm.ClientMembershipGUID
		--inner join cfgSalesCode sc
		--	on apptdet.SalesCodeID = sc.SalesCodeID
		left outer join datAppointmentPhoto apptphoto
			on appt.AppointmentGUID = apptphoto.AppointmentGUID
		left outer join lkpPhotoCaption photocaption
			on apptphoto.PhotoCaptionID = photocaption.PhotoCaptionID
		left outer join datNotesClient nc
			on appt.AppointmentGUID = nc.AppointmentGUID
	WHERE
		appt.CenterID = @CenterID
		and appt.ClientGUID = @clientguid
		and appt.CheckoutTime < GETDATE()
	GROUP BY
			appt.ClientGUID
		,	appt.AppointmentGUID
		,	appt.AppointmentDate
		,	nc.NotesClient

	order by appt.AppointmentDate
END
GO
