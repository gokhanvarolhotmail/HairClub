/***********************************************************************

PROCEDURE:				rptAppointmentPhoto

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Rachelen Hut

--------------------------------------------------------------------------------------------------------
NOTES: 	Used for the images in the TrichoView Summary report.
--------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
06/04/2014	RH	Added NoteForClient from the datAppointmentPhoto table.
02/11/2015	RH	Added AppointmentDate
03/03/2015	RH	Changed PhotoCaptionDescription to 'Front' instead of 'Front Face'
07/11/2016  RH	(#122874) Added code for Localized Lookups using resource keys
10/30/2017	RH	Added parameters @FirstName and @LastName (per Salesforce integration)
10/02/2019  SL  Updated to removed commented out code that is referencing OnContact and synonyms
					being deleted (TFS #13144)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptAppointmentPhoto '9A6B8769-C745-460E-8474-8C3F169E7C9B' , 'Sarita', 'Mehta' --Sarita Mehta

EXEC rptAppointmentPhoto '98A5C23C-8036-4966-A521-83295970B480', 'Aman','Gebray'	--Aman Gebray

***********************************************************************/

CREATE PROCEDURE [dbo].[rptAppointmentPhoto]
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
		,	AppointmentDate		DATETIME
		,	ClientGUID			UNIQUEIDENTIFIER
		,	FirstName			NVARCHAR(50)
		,	LastName			NVARCHAR(50)
		,	NoteForClient		NVARCHAR(500)
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
		,	SequenceOrder		INT

	)

	CREATE TABLE #typeID3
	(
		ID INT IDENTITY(1,1)
		,	AppointmentPhotoID INT
	)

	/*******************************Go to OnContact and get the First Name, Last Name and notes****************************/

	--SET @OnContactContactID = (SELECT OnContactContactID FROM datAppointment
	--WHERE AppointmentGUID = @AppointmentGUID)

	--PRINT @OnContactContactID

	SELECT @Notes = COALESCE(@Notes + ', ', '') +  CONVERT(NVARCHAR(500),NoteForClient)
	FROM dbo.datAppointmentPhoto photo
	WHERE photo.AppointmentGUID = @AppointmentGUID
	AND PhotoTypeID BETWEEN 1 AND 3
	AND NoteForClient IS NOT NULL

	PRINT @Notes

	-------------Main Select into #ApptPhoto----------------------------------------------------

	INSERT INTO #ApptPhoto
	SELECT photo.AppointmentPhotoID
		,	photo.AppointmentGUID
		,	ap.AppointmentDate
		,	photo.ClientGUID
		,	ISNULL(clt.FirstName,@FirstName) AS 'FirstName'
		,	ISNULL(clt.LastName,@LastName) AS 'LastName'
		,	@Notes AS 'NoteForClient'
		,	photo.PhotoTypeID
		,	photo.PhotoCaptionID
		,	pc.DescriptionResourceKey AS 'PhotoCaptionDescription'
		,	ISNULL(photo.AppointmentPhotoModified,photo.AppointmentPhoto) AS 'AppointmentPhotoModified'
		,	photo.ScalpAreaID
		,	photo.ScalpRegionID
		,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
		,	photo.PhotoLensID
		,	photo.PhotoLightTypeID
		,	photo.ComparisonSet
		,	photo.Camera
		,	photo.MimeType
		,	photo.SequenceOrder
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

		--SELECT * FROM #apptPhoto WHERE PhotoTYpeID = 3

	--------------Scope Series--------------------------------------------------

	INSERT INTO #typeID3
	SELECT AppointmentPhotoID
	FROM #ApptPhoto
	WHERE PhotoTypeID = 3
	ORDER BY SequenceOrder

		--SELECT * FROM #typeID3

	---------------UPDATE with first_name, last_name and comment from OnContact---
	--IF (SELECT TOP 1 FirstName FROM #ApptPhoto) IS NULL
	--BEGIN
	--	UPDATE #ApptPhoto
	--	SET #ApptPhoto.FirstName = #comment.first_name
	--	,	#ApptPhoto.LastName = #comment.last_name
	--	FROM #comment
	--END


	--------------Final Select--------------------------------------------------


	SELECT 	AppointmentGUID
		,	AppointmentDate
		,	ClientGUID
		,	FirstName
		,	LastName
		,	NoteForClient
		,	AppointmentPhotoMain = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 2) --Front Face
		,	AppointmentPhoto2 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 1) --Top Front
		,	AppointmentPhoto3 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 3) --Crown/Back
		,	AppointmentPhoto4 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 4)--Left Profile
		,	AppointmentPhoto5 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 5)	--Right Profile
		--Scope
		,	AppointmentScope6 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 1)
		,	AppointmentScope7 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 2)
		,	AppointmentScope8 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 3)
		,	AppointmentScope9 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 4)
		,	AppointmentScope10 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 5)
		,	AppointmentScope11 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 6)
		,	AppointmentScope12 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 7)
		,	AppointmentScope13 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID  AND PhotoTypeID = 3 AND #typeID3.ID = 8)
		--Captions
		,	AppointmentPhotoMainCaption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 2)
		,	AppointmentPhoto2Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 1)
		,	AppointmentPhoto3Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 3)
		,	AppointmentPhoto4Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 4)
		,	AppointmentPhoto5Caption = (SELECT TOP 1 PhotoCaptionDescription FROM #ApptPhoto WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 1 AND PhotoCaptionID = 5)

		,	AppointmentScope6Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 1)
		,	AppointmentScope7Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 2)
		,	AppointmentScope8Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 3)
		,	AppointmentScope9Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 4)
		,	AppointmentScope10Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 5)
		,	AppointmentScope11Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 6)
		,	AppointmentScope12Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 7)
		,	AppointmentScope13Caption = (SELECT TOP 1 ScalpRegionDescription FROM #ApptPhoto INNER JOIN #typeID3 ON #typeID3.AppointmentPhotoID = #ApptPhoto.AppointmentPhotoID WHERE AppointmentGUID = @AppointmentGUID AND PhotoTypeID = 3 AND #typeID3.ID = 8)

	 FROM #ApptPhoto appt

	 GROUP BY appt.AppointmentGUID
	 ,	appt.AppointmentDate
	 ,	appt.ClientGUID
	 ,	appt.FirstName
	 ,	appt.LastName
	 ,	appt.NoteForClient

END
