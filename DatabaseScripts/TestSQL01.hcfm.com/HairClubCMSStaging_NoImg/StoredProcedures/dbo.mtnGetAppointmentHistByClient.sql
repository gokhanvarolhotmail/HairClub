/* CreateDate: 02/18/2013 06:45:39.247 , ModifyDate: 02/27/2017 09:49:19.863 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnGetAppointmentHistByClient	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/20/2012

LAST REVISION DATE:		4/20/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	4/20/2012	KMurdoch	Initial Creation
	4/20/2012	KMurdoch	Added 2 columns for Headscan & Microscan photos
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetAppointmentHistByClient '201','4784631D-8BE0-4902-A98B-832A7561419A'

	CenterID = Logged in Center
	ClientGUID = From datAppointment - ClientGUID
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnGetAppointmentHistByClient] (
	@CenterID int
,	@ClientGUID UniqueIdentifier

) AS
	BEGIN


	SET NOCOUNT ON


	SELECT
			appt.ClientGUID as 'ClientGUID'
		,	appt.AppointmentGUID as 'AppointmentGUID'
		,	appt.AppointmentDate as 'AppointmentDate'
		,	sc.SalesCodeDescription as 'ServiceProvided'
		,	sc.SalesCodeID as 'SalesCodeID'
		,	sc.SalesCodeSortOrder as 'SalesCodeSortOrder'
		,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		,	sc.SalesCodeDescription as 'SalesCodeDescription'
		,	sc.IsSalesCodeKitFlag as 'IsKitFlag'
		,	MAX(case when apptphoto.PhotoCaptionID = 1 then apptphoto.PhotoCaptionID else null end) as 'HeadScan'
		,	MAX(case when apptphoto.PhotoCaptionID = 2 then apptphoto.PhotoCaptionID else null end) as 'MicroScan'
	FROM datAppointment appt
		inner join datAppointmentDetail apptdet
			on appt.AppointmentGUID = apptdet.AppointmentGUID
		inner join datClientMembership clm
			on appt.ClientMembershipGUID = clm.ClientMembershipGUID
		inner join cfgSalesCode sc
			on apptdet.SalesCodeID = sc.SalesCodeID
		left outer join datAppointmentPhoto apptphoto
			on appt.AppointmentGUID = apptphoto.AppointmentGUID
		left outer join lkpPhotoCaption photocaption
			on apptphoto.PhotoCaptionID = photocaption.PhotoCaptionID
	WHERE
		appt.CenterID = @CenterID
		and appt.ClientGUID = @clientguid
		and appt.CheckoutTime < GETDATE()
	GROUP BY
			appt.ClientGUID
		,	appt.AppointmentGUID
		,	appt.AppointmentDate
		,	sc.SalesCodeDescription
		,	sc.SalesCodeID
		,	sc.SalesCodeSortOrder
		,	sc.SalesCodeDescriptionShort
		,	sc.SalesCodeDescription
		,	sc.IsSalesCodeKitFlag

	order by appt.AppointmentDate,sc.IsSalesCodeKitFlag desc,sc.SalesCodeDescription
END
GO
