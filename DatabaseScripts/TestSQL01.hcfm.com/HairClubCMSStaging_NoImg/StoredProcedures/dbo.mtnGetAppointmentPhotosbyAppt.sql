/* CreateDate: 02/18/2013 06:45:39.280 , ModifyDate: 02/27/2017 09:49:20.013 */
GO
/***********************************************************************

PROCEDURE:				mtnGetAppointmentPhotosbyAppt	VERSION  1.0

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
	4/20/2012	KMurdoch	Add PhotoCaptionID to parameters
	3/28/2013   SHankermeyer	Replace PhotoCaptionId with PhotoDescShort

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetAppointmentPhotosbyAppt '201','041F673F-3B1B-49C2-80BF-AE38C6689B08', 'LP'

	CenterID = Logged in Center
	AppointmentGUID = From datAppointment - AppointmentGUID
	PhotoDescShort
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnGetAppointmentPhotosbyAppt] (
	@CenterID int
,	@AppointmentGUID UniqueIdentifier
,	@PhotoDescShort nvarchar(10)

) AS
	BEGIN


	SET NOCOUNT ON

	SELECT
			appt.ClientGUID as 'ClientGUID'
		,	appt.AppointmentGUID as 'AppointmentGUID'
		,	appt.AppointmentDate as 'AppointmentDate'
		,	apptphoto.AppointmentPhoto
		,	photocaption.PhotoCaptionDescription
		,	photocaption.PhotoCaptionID
		,	photocaption.PhotoCaptionSortOrder
	FROM datAppointment appt
		inner join datAppointmentDetail apptdet
			on appt.AppointmentGUID = apptdet.AppointmentGUID
		left outer join datAppointmentPhoto apptphoto
			on appt.AppointmentGUID = apptphoto.AppointmentGUID
		left outer join lkpPhotoCaption photocaption
			on apptphoto.PhotoCaptionID = photocaption.PhotoCaptionID

	WHERE
		appt.CenterID = @CenterID
		and appt.AppointmentGUID = @AppointmentGUID
		and photocaption.PhotoCaptionDescriptionShort = @PhotoDescShort
	order by appt.AppointmentDate
END
GO
