/*
==============================================================================
PROCEDURE:                  mtnCleanupTrichoViewAppointments

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           09/30/2014

LAST REVISION DATE:			09/30/2014

==============================================================================
DESCRIPTION:   If appointment does not have any photos attached,
					it is reverted back to regular appointment

==============================================================================
NOTES:
            * 09/30/2014 MVT - Created Stored Proc
			* 11/06/2014 MVT - Added logic to flag appointments as TrichoView
								if appointment has a photo.
			* 11/15/2014 MVT - Added a check for NULL appointment Type when checking for
								TrichoView appointments
			* 09/14/2016 PRM - Added logic to determine if TrichoView appointment is a
								FULL TrichoView, if it is, set the datAppointment.IsFullTrichoView
								column to 1
			* 12/13/2016 PRM - Completed the query to determine if an appointment was a Full TrichoView
			* 10/30/2017 SAL - Updated the update appointment statement to check for SalesForceTaskID
								when setting the AppointmentTypeID for a Sales Consultation Appt Type.
==============================================================================
SAMPLE EXECUTION:
EXEC [mtnCleanupTrichoViewAppointments]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnCleanupTrichoViewAppointments]
AS
BEGIN

	DECLARE @TrichoViewAppointmentTypeID int, @SalesConsultationAppointmentTypeID int
	DECLARE @TrichoViewAppointmentTypeDescriptionShort nvarchar(10) = 'TrichoView'
	DECLARE @SalesConsultationAppointmentTypeDescriptionShort nvarchar(10) = 'SlsCon'

	SELECT @TrichoViewAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = @TrichoViewAppointmentTypeDescriptionShort
	SELECT @SalesConsultationAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = @SalesConsultationAppointmentTypeDescriptionShort
	--PRINT @SalesConsultationAppointmentTypeID

	UPDATE appt SET
		appt.AppointmentTypeID = CASE WHEN appt.OnContactActivityID IS NOT NULL OR appt.SalesForceTaskID IS NOT NULL THEN @SalesConsultationAppointmentTypeID ELSE NULL END,
		appt.LastUpdate = GETUTCDATE(),
		appt.LastUpdateUser = 'Nightly_TVCleanup'
	FROM datAppointment appt
		INNER JOIN lkpAppointmentType at ON at.AppointmentTypeID = appt.AppointmentTypeID
		OUTER APPLY
		(
			SELECT TOP(1) oa_ap.AppointmentPhotoID
				FROM datAppointmentPhoto oa_ap
				WHERE oa_ap.AppointmentGUID = appt.AppointmentGUID
		) ap
	WHERE at.AppointmentTypeDescriptionShort = @TrichoViewAppointmentTypeDescriptionShort
		AND ap.AppointmentPhotoID IS NULL


	-- Set appointment as TrichoView if contains a photo.
	UPDATE a SET
		a.AppointmentTypeID = @TrichoViewAppointmentTypeID,
		a.LastUpdate = GETUTCDATE(),
		a.LastUpdateUser = 'Nightly_TVAsgn'
	FROM datAppointment a
		CROSS APPLY (
			SELECT TOP(1) *
			FROM datAppointmentPhoto ap
			WHERE ap.AppointmentGUID = a.AppointmentGUID
		) photo
	WHERE a.AppointmentTypeID IS NULL OR a.AppointmentTypeID <> @TrichoViewAppointmentTypeID



	-- Set IsFullTrichoView = true on appointments that contain HMI data (NOTE: this logic doesn't care if a photo has Markups like the HMI screen does)
	--   This logic has also been added to the application so in theory, there should never be an appointment to update in this nightly job, if any records
	--   get through to the nightly process we're logging them below so the application can be fixed, in the future once all records are being updated through
	--   the application, this section of the nightly process can be removed
	CREATE TABLE #TempFullTrichoView
	(
		AppointmentGUID uniqueidentifier
	)

	DECLARE @PhotoType_Width int
	SELECT @PhotoType_Width = PhotoTypeID FROM lkpPhotoType WHERE PhotoTypeDescriptionShort = 'Width'

	DECLARE @PhotoType_Density int
	SELECT @PhotoType_Density = PhotoTypeID FROM lkpPhotoType WHERE PhotoTypeDescriptionShort = 'Density'

	DECLARE @ScalpArea_Control int, @ScalpArea_Thin int
	SELECT @ScalpArea_Control = ScalpAreaID FROM lkpScalpArea WHERE ScalpAreaDescriptionShort = 'Control'
	SELECT @ScalpArea_Thin = ScalpAreaID FROM lkpScalpArea WHERE ScalpAreaDescriptionShort = 'Thinning'

	DECLARE @StartDate datetime = DATEADD(MONTH, -1, GETDATE())

	INSERT INTO #TempFullTrichoView

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

		WHERE a.IsFullTrichoView = 0 AND a.AppointmentTypeID = @TrichoViewAppointmentTypeID AND a.AppointmentDate > @StartDate


	UPDATE datAppointment
	SET IsFullTrichoView = 1,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'Nightly_TVAsgn'

	WHERE AppointmentGUID IN (
		SELECT AppointmentGUID
		FROM #TempFullTrichoView
	)

	--Log any records in the Log4Net database so we can fix the application for any records that slipped through the cracks
	INSERT INTO Log4Net..FullTrichoViewNightlyProcess
		SELECT AppointmentGUID, GETUTCDATE()
		FROM #TempFullTrichoView


	IF(OBJECT_ID('tempdb..#TempFullTrichoView') IS NOT NULL)
	  BEGIN
		DROP TABLE #TempFullTrichoView
	  END

END
