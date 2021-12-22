/* CreateDate: 12/28/2016 07:03:47.130 , ModifyDate: 03/07/2017 11:06:41.810 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnUpdateAppointmentFullTrichoView

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		12/13/16

LAST REVISION DATE: 	03/06/17

--------------------------------------------------------------------------------------------------------
NOTES: 	Sets appointments "IsFullTrichoView" flag when the appointment has HMI data. Also sets the Appointment.AppointmentTypeID to TrichoView
             when AppointmentPhoto records are associated with the appointment

		* 12/13/2016 PRM - Created.
		* 03/06/2017 PRM - Set the appointment type to trichoview if the appointment has any photos associated with it

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnUpdateAppointmentFullTrichoView 'AF8ADF37-6381-44D5-89A0-28242E0ED426', 'skyline.pmadary'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnUpdateAppointmentFullTrichoView]
	  @AppointmentGUID uniqueidentifier
	  ,@Username nvarchar(25)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Current_AppointmentTypeID int
	DECLARE @AppointmentPhotoCount int

	DECLARE @AppointmentType_TrichoView int
	SELECT @AppointmentType_TrichoView = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'TrichoView'

	DECLARE @Current_IsFullTrichoView bit
	DECLARE @New_IsFullTrichoView bit

	-- Set IsFullTrichoView = true on appointments that contain HMI data (NOTE: this logic doesn't care if a photo has Markups like the HMI screen does)
	DECLARE @PhotoType_Width int
	SELECT @PhotoType_Width = PhotoTypeID FROM lkpPhotoType WHERE PhotoTypeDescriptionShort = 'Width'

	DECLARE @PhotoType_Density int
	SELECT @PhotoType_Density = PhotoTypeID FROM lkpPhotoType WHERE PhotoTypeDescriptionShort = 'Density'

	DECLARE @ScalpArea_Control int, @ScalpArea_Thin int
	SELECT @ScalpArea_Control = ScalpAreaID FROM lkpScalpArea WHERE ScalpAreaDescriptionShort = 'Control'
	SELECT @ScalpArea_Thin = ScalpAreaID FROM lkpScalpArea WHERE ScalpAreaDescriptionShort = 'Thinning'

	--Get CURRENT Appointment values
	SELECT @Current_IsFullTrichoView = IsFullTrichoView,
		@Current_AppointmentTypeID = CASE WHEN AppointmentTypeID IS NULL THEN 0 ELSE AppointmentTypeID END,
		@AppointmentPhotoCount = COUNT(ap.AppointmentPhotoID)
	FROM datAppointment a
		LEFT JOIN datAppointmentPhoto ap ON a.AppointmentGUID = ap.AppointmentGUID
	WHERE a.AppointmentGUID = @AppointmentGUID
	GROUP BY IsFullTrichoView, AppointmentTypeID

	--Set the Appointment Type to TrichoView if it has any Appointment Photos associated with it
	IF ((@Current_AppointmentTypeID <> @AppointmentType_TrichoView AND @AppointmentPhotoCount > 0) OR
			(@Current_AppointmentTypeID = @AppointmentType_TrichoView AND @AppointmentPhotoCount = 0))
	  BEGIN
		UPDATE datAppointment
		SET AppointmentTypeID = CASE WHEN @AppointmentPhotoCount > 0 THEN @AppointmentType_TrichoView ELSE NULL END,
			LastUpdateUser = @Username,
			LastUpdate = GETDATE()
		WHERE AppointmentGUID = @AppointmentGUID
	  END

	--Get NEW IsFullTrichoView value
	SELECT @New_IsFullTrichoView = (CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END)
	FROM datAppointment
	WHERE AppointmentGUID IN (
		SELECT DISTINCT a.AppointmentGUID
		FROM datAppointment a
			INNER JOIN	datAppointmentPhoto apWidthControl ON a.AppointmentGUID = apWidthControl.AppointmentGUID
															AND apWidthControl.PhotoTypeID = @PhotoType_Width AND apWidthControl.ScalpAreaID = @ScalpArea_Control
															AND apWidthControl.AverageWidth <> 0 --Must have a Width set

			INNER JOIN	datAppointmentPhoto apWidthThin ON a.AppointmentGUID = apWidthThin.AppointmentGUID
															AND apWidthThin.PhotoTypeID = @PhotoType_Width AND apWidthThin.ScalpAreaID = @ScalpArea_Thin
															AND apWidthControl.ComparisonSet = apWidthThin.ComparisonSet --All ComparisonSets the same
															AND apWidthThin.AverageWidth <> 0 --Must have a Width set

			INNER JOIN	datAppointmentPhoto apDensityControl ON a.AppointmentGUID = apDensityControl.AppointmentGUID
															AND apDensityControl.PhotoTypeID = @PhotoType_Density AND apWidthControl.ScalpAreaID = @ScalpArea_Control
															AND apWidthControl.ComparisonSet = apDensityControl.ComparisonSet --All ComparisonSets the same
															AND apWidthControl.ScalpRegionID = apDensityControl.ScalpRegionID -- Control Width & Density Scalp Regions must match
															AND apDensityControl.DensityInMMSquared <> 0 --Must have a Density set

			INNER JOIN	datAppointmentPhoto apDensityThin ON a.AppointmentGUID = apDensityThin.AppointmentGUID
															AND apDensityThin.PhotoTypeID = @PhotoType_Density AND apDensityThin.ScalpAreaID = @ScalpArea_Thin
															AND apWidthControl.ComparisonSet = apDensityThin.ComparisonSet --All ComparisonSets the same
															AND apWidthThin.ScalpRegionID = apDensityThin.ScalpRegionID -- Thinning Width & Density Scalp Regions must match
															AND apDensityThin.DensityInMMSquared <> 0 --Must have a Density set
		WHERE a.AppointmentGUID = @AppointmentGUID
	)

	IF (@Current_IsFullTrichoView <> @New_IsFullTrichoView)
	  BEGIN
		UPDATE datAppointment
		SET IsFullTrichoView = @New_IsFullTrichoView,
			LastUpdateUser = @Username,
			LastUpdate = GETDATE()
		WHERE AppointmentGUID = @AppointmentGUID
	  END

	  SELECT @New_IsFullTrichoView AS IsFullTrichoView

END
GO
