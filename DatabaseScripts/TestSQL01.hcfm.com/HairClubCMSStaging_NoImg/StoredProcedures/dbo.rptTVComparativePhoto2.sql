/* CreateDate: 10/07/2014 10:36:40.370 , ModifyDate: 11/04/2019 08:17:08.750 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				[rptTVComparativePhoto2]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Rachelen Hut

--------------------------------------------------------------------------------------------------------
NOTES: 	Used for the images in the TrichoView Comparative Analysis report.

06/04/2014	RH	Added NoteForClient from the datAppointmentPhoto table.
03/03/2015	RH	Changed PhotoCaptionDescription to 'Front' instead of 'Front Face'
10/30/2017	RH	Added parameters @FirstName and @LastName (per Salesforce integration)
10/02/2019  SL	Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptTVComparativePhoto2] '52EE6482-A768-410E-897E-43A5FF4F17C8' , 'Luz','Logan'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptTVComparativePhoto2]
	(@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@FirstName NVARCHAR(50)
	,	@LastName NVARCHAR(50)
	)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @OnContactContactID2 NCHAR(10)
	DECLARE @Notes2 NVARCHAR(MAX)


	--CREATE TABLE #comment2
	--(	 firstname2 NVARCHAR(50)
	--	, lastname2  NVARCHAR(50)
	--)



	CREATE TABLE #ApptPhoto2
	(	Comparative2 INT
	,	AppointmentPhotoID2	INT
		,	AppointmentGUID2		UNIQUEIDENTIFIER
		,	AppointmentDate2	 DATETIME
		,	ClientGUID2			UNIQUEIDENTIFIER
		,	FirstName2			NVARCHAR(50)
		,	LastName2			NVARCHAR(50)
		,	NoteForClient2		NVARCHAR(500)
		,	PhotoTypeID2			INT
		,	PhotoCaptionID2		INT
		,	PhotoCaptionDescription2	NVARCHAR(100)
		,	AppointmentPhotoModified2	VARBINARY(MAX)
		,	ScalpAreaID2			INT
		,	ScalpRegionID2		INT
		,	ScalpRegionDescription2	NVARCHAR(100)
		,	PhotoLensID2			INT
		,	PhotoLightTypeID2	INT
		,	ComparisonSet2		INT
		,	Camera2				NVARCHAR(50)
		,	MimeType2			NVARCHAR(50)

	)

	CREATE TABLE #typeID3_2
	(
		ID INT IDENTITY(1,1)
		,	AppointmentPhotoID2 INT
	)

	/*******************************Go to OnContact and get the First Name, Last Name and notes****************************/


	SET @OnContactContactID2 = (SELECT OnContactContactID FROM datAppointment
	WHERE AppointmentGUID = @AppointmentGUID2)

	--PRINT @OnContactContactID2

	SELECT @Notes2 = COALESCE(@Notes2 + ', ', '') +  CONVERT(NVARCHAR(500),NoteForClient)
	FROM dbo.datAppointmentPhoto photo
	WHERE photo.AppointmentGUID = @AppointmentGUID2
	AND PhotoTypeID BETWEEN 1 AND 3
	AND NoteForClient IS NOT NULL

	--PRINT @Notes2

	-------------Main Select into #ApptPhoto----------------------------------------------------

	INSERT INTO #ApptPhoto2
	SELECT 	2 AS 'Comparative'
	,	photo.AppointmentPhotoID AS 'AppointmentPhotoID2'
		,	photo.AppointmentGUID AS 'AppointmentGUID2'
		,	ap.AppointmentDate AS 'AppointmentDate2'
		,	photo.ClientGUID AS 'ClientGUID2'
		,	ISNULL(clt.FirstName,@FirstName) AS 'FirstName2'
		,	ISNULL(clt.LastName,@LastName) AS 'LastName2'
		,	@Notes2 AS 'NoteForClient2'
		,	photo.PhotoTypeID AS 'PhotoTypeID2'
		,	photo.PhotoCaptionID AS 'PhotoCaptionID2'
		--,	pc.PhotoCaptionDescription AS 'PhotoCaptionDescription2'
		,	CASE WHEN photo.PhotoCaptionID = 2 THEN 'Front' ELSE pc.DescriptionResourceKey END AS 'PhotoCaptionDescription2'
		,	ISNULL(photo.AppointmentPhotoModified,photo.AppointmentPhoto) AS 'AppointmentPhotoModified2'
		,	photo.ScalpAreaID AS 'ScalpAreaID2'
		,	photo.ScalpRegionID AS 'ScalpRegionID2'
		,	sr.DescriptionResourceKey AS 'ScalpRegionDescription2'
		,	photo.PhotoLensID AS 'PhotoLensID2'
		,	photo.PhotoLightTypeID AS 'PhotoLightTypeID2'
		,	photo.ComparisonSet AS 'ComparisonSet2'
		,	photo.Camera AS 'Camera2'
		,	photo.MimeType AS 'MimeType2'
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
	WHERE photo.AppointmentGUID = @AppointmentGUID2

		--SELECT * FROM #apptPhoto2

	--------------Scope Series--------------------------------------------------

	INSERT INTO #typeID3_2
	SELECT AppointmentPhotoID2
	FROM #apptPhoto2
	WHERE PhotoTypeID2 = 3

		--SELECT * FROM #typeID3_2

	-------------UPDATE with first_name, last_name and comment from OnContact---
	--IF (SELECT TOP 1 FirstName2 FROM #apptPhoto2 WHERE Comparative2 = 2) IS NULL
	--BEGIN
	--	UPDATE #apptPhoto2
	--	SET #apptPhoto2.FirstName2 = #comment2.firstname2
	--	,	#apptPhoto2.LastName2 = #comment2.lastname2
	--	FROM #comment2
	--END


	--------------Final Select--------------------------------------------------


	SELECT 	Comparative2
	,	AppointmentGUID2
	,	AppointmentDate2
		,	ClientGUID2
		,	FirstName2
		,	LastName2
		,	NoteForClient2
		,	AppointmentPhotoMain_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 2) --Front Face
		,	AppointmentPhoto2_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 1) --Top Front
		,	AppointmentPhoto3_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 3) --Crown/Back
		,	AppointmentPhoto4_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 4)--Left Profile
		,	AppointmentPhoto5_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 5)	--Right Profile
		--Scope
		,	AppointmentScope6_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 1)
		,	AppointmentScope7_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 2)
		,	AppointmentScope8_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 3)
		,	AppointmentScope9_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 4)
		,	AppointmentScope10_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 5)
		,	AppointmentScope11_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 6)
		,	AppointmentScope12_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 7)
		,	AppointmentScope13_2 = (SELECT TOP 1 AppointmentPhotoModified2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2  AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 8)
		--Captions
		,	AppointmentPhotoMainCaption2 = (SELECT TOP 1 PhotoCaptionDescription2
											FROM #apptPhoto2
											WHERE AppointmentGUID2 = @AppointmentGUID2
											AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 2)
		,	AppointmentPhoto2Caption2 = (SELECT TOP 1 PhotoCaptionDescription2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 1)
		,	AppointmentPhoto3Caption2 = (SELECT TOP 1 PhotoCaptionDescription2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 3)
		,	AppointmentPhoto4Caption2 = (SELECT TOP 1 PhotoCaptionDescription2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 4)
		,	AppointmentPhoto5Caption2 = (SELECT TOP 1 PhotoCaptionDescription2 FROM #apptPhoto2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 1 AND PhotoCaptionID2 = 5)
		,	AppointmentScope6Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 1)
		,	AppointmentScope7Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 2)
		,	AppointmentScope8Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 3)
		,	AppointmentScope9Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 4)
		,	AppointmentScope10Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 5)
		,	AppointmentScope11Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 6)
		,	AppointmentScope12Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 7)
		,	AppointmentScope13Caption2 = (SELECT TOP 1 ScalpRegionDescription2 FROM #apptPhoto2 INNER JOIN #typeID3_2 ON #typeID3_2.AppointmentPhotoID2 = #apptPhoto2.AppointmentPhotoID2 WHERE AppointmentGUID2 = @AppointmentGUID2 AND PhotoTypeID2 = 3 AND #typeID3_2.ID = 8)


	 FROM #apptPhoto2 appt

	 GROUP BY appt.Comparative2
	,	appt.AppointmentGUID2
	,	appt.AppointmentDate2
	 ,	appt.ClientGUID2
	 ,	appt.FirstName2
	 ,	appt.LastName2
	 ,	appt.NoteForClient2

END
GO
