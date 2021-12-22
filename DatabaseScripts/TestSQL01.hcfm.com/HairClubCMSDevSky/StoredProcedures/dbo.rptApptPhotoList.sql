/* CreateDate: 05/09/2014 16:02:08.993 , ModifyDate: 11/17/2014 17:08:04.753 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptApptPhotoList
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Rachelen Hut

--------------------------------------------------------------------------------------------------------
NOTES: 	Used for an image report - that passes in a list of AppointmentPhotoID's.  There is a limit of eight photo's.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptApptPhotoList] '102,103,104,105,106,107,108'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptApptPhotoList]
	@AppointmentPhotoIDLIST NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

	CREATE TABLE #items(
	ID INT IDENTITY(1,1)
	,	item_AppointmentPhotoID NVARCHAR(50))

	CREATE TABLE #ApptPhotoList
	(	ID INT
		,	AppointmentPhotoID	INT
		,	AppointmentGUID		UNIQUEIDENTIFIER
		,	AppointmentPhotoGUID UNIQUEIDENTIFIER
		,	ClientGUID			UNIQUEIDENTIFIER
		,	FirstName			NVARCHAR(50)
		,	LastName			NVARCHAR(50)
		,	PhotoTypeID			INT
		,	PhotoCaptionID		INT
		,	PhotoCaptionDescription NVARCHAR(100)
		,	AppointmentPhotoModified	VARBINARY(MAX)
		,	ScalpAreaID			INT
		,	ScalpRegionID		INT
		,	ScalpRegionDescription NVARCHAR(100)
		,	PhotoLensID			INT
		,	PhotoLightTypeID	INT
		,	ComparisonSet		INT
		,	Camera				NVARCHAR(50)
		,	MimeType			NVARCHAR(50)
	)

	INSERT INTO #items
	SELECT item AS 'item_AppointmentPhotoID' FROM dbo.fnSplit(@AppointmentPhotoIDLIST,',')

	--SELECT * FROM #items

	INSERT INTO #ApptPhotoList
	SELECT it.ID
	,	photo.AppointmentPhotoID
		,	photo.AppointmentGUID
		,	photo.AppointmentPhotoGUID
		,	apt.ClientGUID
		,	clt.FirstName
		,	clt.LastName
		,	photo.PhotoTypeID
		,	photo.PhotoCaptionID
		,	pc.PhotoCaptionDescription
		,	ISNULL(photo.AppointmentPhotoModified,photo.AppointmentPhoto) AS 'AppointmentPhotoModified'
		,	photo.ScalpAreaID
		,	photo.ScalpRegionID
		,	sr.ScalpRegionDescription
		,	photo.PhotoLensID
		,	PhotoLightTypeID
		,	photo.ComparisonSet
		,	photo.Camera
		,	photo.MimeType
	FROM dbo.datAppointmentPhoto photo
	INNER JOIN dbo.datAppointment apt
		ON apt.AppointmentGUID = photo.AppointmentGUID
	INNER JOIN #items it
		ON photo.AppointmentPhotoID = it.item_AppointmentPhotoID
	LEFT JOIN dbo.lkpPhotoCaption pc
		ON pc.PhotoCaptionID = photo.PhotoCaptionID
	LEFT JOIN dbo.datClient clt
		ON clt.ClientGUID = apt.ClientGUID
	LEFT JOIN dbo.lkpScalpRegion sr
		ON sr.ScalpRegionID = photo.ScalpRegionID

	SELECT 	AppointmentGUID
		,	ClientGUID
		,	FirstName
		,	LastName
		,	AppointmentPhoto1 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 1)
		,	AppointmentPhoto2 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 2)
		,	AppointmentPhoto3 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 3)
		,	AppointmentPhoto4 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 4)
		,	AppointmentPhoto5 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 5)
		,	AppointmentPhoto6 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 6)
		,	AppointmentPhoto7 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 7)
		,	AppointmentPhoto8 = (SELECT TOP 1 AppointmentPhotoModified FROM #ApptPhotoList WHERE ID = 8)
		,	AppointmentPhoto1Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END FROM #ApptPhotoList WHERE ID = 1)
		,	AppointmentPhoto2Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END FROM #ApptPhotoList WHERE ID = 2)
		,	AppointmentPhoto3Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END FROM #ApptPhotoList WHERE ID = 3)
		,	AppointmentPhoto4Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END  FROM #ApptPhotoList WHERE ID = 4)
		,	AppointmentPhoto5Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END  FROM #ApptPhotoList WHERE ID = 5)
		,	AppointmentPhoto6Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END  FROM #ApptPhotoList WHERE ID = 6)
		,	AppointmentPhoto7Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END  FROM #ApptPhotoList WHERE ID = 7)
		,	AppointmentPhoto8Caption = (SELECT CASE WHEN PhotoTypeID = 1 THEN PhotoCaptionDescription
													WHEN PhotoTypeID = 3 THEN ScalpRegionDescription END  FROM #ApptPhotoList WHERE ID = 8)

	 FROM #ApptPhotoList
	 GROUP BY #ApptPhotoList.AppointmentGUID
	 , #ApptPhotoList.ClientGUID
	 , #ApptPhotoList.FirstName
	 , #ApptPhotoList.LastName

END
GO
