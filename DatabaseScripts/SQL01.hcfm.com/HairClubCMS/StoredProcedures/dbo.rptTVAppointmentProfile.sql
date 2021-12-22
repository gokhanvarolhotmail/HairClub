/***********************************************************************

PROCEDURE:				rptTVAppointmentProfile

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Rachelen Hut

--------------------------------------------------------------------------------------------------------
NOTES: 	Used for the images in the TrichoView Summary report.

--------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
07/11/2016  RH	(#122874) Added code for Localized Lookups using resource keys
10/30/2017	RH	Added parameters @FirstName and @LastName (per Salesforce integration)
10/02/2019  SL	Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)
-------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptTVAppointmentProfile '52EE6482-A768-410E-897E-43A5FF4F17C8' , 'Luz','Logan'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptTVAppointmentProfile]
	(@AppointmentGUID UNIQUEIDENTIFIER
	,	@FirstName NVARCHAR(50)
	,	@LastName NVARCHAR(50)
	)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @OnContactContactID NCHAR(10)
	DECLARE @Notes NVARCHAR(MAX)


	--CREATE TABLE #comment
	--(	first_name NVARCHAR(50)
	--	, last_name  NVARCHAR(50)
	--)



	CREATE TABLE #ApptPhoto
	(
			AppointmentPhotoID	INT
		,	AppointmentGUID		UNIQUEIDENTIFIER
		,	ClientGUID			UNIQUEIDENTIFIER
		,	FirstName			NVARCHAR(50)
		,	LastName			NVARCHAR(50)
		,	ProfileNoteForClient	NVARCHAR(500)
		,	PhotoTypeID			INT
		,	PhotoCaptionID		INT
		,	PhotoCaptionDescription	NVARCHAR(100)
		,	AppointmentPhotoModified	VARBINARY(MAX)
		,	ScalpAreaID			INT
		,	ScalpRegionID		INT
		,	ScalpRegionDescription	NVARCHAR(100)
		,	PhotoLensID			INT
		,	PhotoLightTypeID	INT
		,	ComparisonSet		INT
		,	Camera				NVARCHAR(50)
		,	MimeType			NVARCHAR(50)

	)


	/*******************************Go to OnContact and get the First Name, Last Name and notes****************************/

	SET @OnContactContactID = (SELECT OnContactContactID FROM datAppointment
	WHERE AppointmentGUID = @AppointmentGUID)

	--PRINT @OnContactContactID

	SELECT @Notes = COALESCE(@Notes + ' ', '') +  CONVERT(NVARCHAR(500),NoteForClient)
	FROM dbo.datAppointmentPhoto photo
	WHERE photo.AppointmentGUID = @AppointmentGUID
	AND PhotoTypeID IN(1)  --Profile
	AND NoteForClient IS NOT NULL

	PRINT @Notes

	-------------Main Select into #ApptPhoto----------------------------------------------------

	INSERT INTO #ApptPhoto
	SELECT photo.AppointmentPhotoID
		,	photo.AppointmentGUID
		,	photo.ClientGUID
		,	ISNULL(clt.FirstName,@FirstName) AS 'FirstName'
		,	ISNULL(clt.LastName,@LastName) AS 'LastName'
		,	@Notes AS 'ProfileNoteForClient'
		,	photo.PhotoTypeID
		,	photo.PhotoCaptionID
		--,	pc.PhotoCaptionDescription
		,	pc.DescriptionResourceKey AS 'PhotoCaptionDescription'
		,	ISNULL(photo.AppointmentPhotoModified,photo.AppointmentPhoto) AS 'AppointmentPhotoModified'
		,	photo.ScalpAreaID
		,	photo.ScalpRegionID
		--,	sr.ScalpRegionDescription
		,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
		,	photo.PhotoLensID
		,	photo.PhotoLightTypeID
		,	photo.ComparisonSet
		,	photo.Camera
		,	photo.MimeType
	FROM dbo.datAppointmentPhoto photo
	INNER JOIN dbo.datAppointment ap
		ON ap.AppointmentGUID = photo.AppointmentGUID
	LEFT JOIN dbo.lkpPhotoCaption pc
		ON pc.PhotoCaptionID = photo.PhotoCaptionID
	LEFT JOIN dbo.lkpScalpRegion sr
		ON sr.ScalpRegionID = photo.ScalpRegionID
	LEFT JOIN dbo.datAppointmentEmployee ae
		ON ae.AppointmentGUID = ap.AppointmentGUID
	LEFT JOIN datEmployee sty
		ON sty.EmployeeGUID = ae.EmployeeGUID
	LEFT JOIN datClient clt
		ON clt.ClientGUID = ap.ClientGUID
	WHERE photo.AppointmentGUID = @AppointmentGUID

		--SELECT * FROM #apptPhoto


	-------------UPDATE with first_name, last_name and comment from OnContact---
	--IF (SELECT TOP 1 FirstName FROM #ApptPhoto) IS NULL
	--BEGIN
	--	UPDATE #ApptPhoto
	--	SET #ApptPhoto.FirstName = #comment.first_name
	--	,	#ApptPhoto.LastName = #comment.last_name
	--	FROM #comment
	--END


	--------------Final Select--------------------------------------------------


	SELECT 	AppointmentGUID
		,	ClientGUID
		,	FirstName
		,	LastName
		,	ProfileNoteForClient
		,	AppointmentPhotoMain = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 2) --Front Face
		,	AppointmentPhoto2 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 1) --Top Front
		,	AppointmentPhoto3 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 3) --Crown/Back
		,	AppointmentPhoto4 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 4)--Left Profile
		,	AppointmentPhoto5 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 5)	--Right Profile

		--Captions
		,	AppointmentPhotoMainCaption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 2)
		,	AppointmentPhoto2Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 1)
		,	AppointmentPhoto3Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 3)
		,	AppointmentPhoto4Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 4)
		,	AppointmentPhoto5Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 5)


	 FROM #ApptPhoto appt

	 GROUP BY appt.AppointmentGUID
	 ,	appt.ClientGUID
	 ,	appt.FirstName
	 ,	appt.LastName
	 ,	appt.ProfileNoteForClient

END
