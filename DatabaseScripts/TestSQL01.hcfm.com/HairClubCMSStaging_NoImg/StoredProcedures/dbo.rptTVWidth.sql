/* CreateDate: 09/05/2014 09:20:33.397 , ModifyDate: 09/17/2019 10:27:38.850 */
GO
/*===============================================================================================
Procedure Name:				[rptTVWidth]
Procedure Description:			This stored procedure provides the data for the Width grids.
Created By:					Rachelen Hut
Date Created:					08/04/2014
Destination Server.Database:   SQL01.HairclubCMS
Related Application:			TrichoView
================================================================================================
Change History:
05/07/2015 - RH - Changed OnContact_cstd_activity_demographic_TABLE to datClientDemographic
02/12/2016 - RH - Changed to pull first from OnContact_cstd_activity_demographic_TABLE and then update
					if there is a client record; Also removed the default for Female ReportResourceImage
07/18/2016 - RH - (#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC [rptTVWidth] 'BFC0C229-0BD1-4D5F-91E6-92F1ACBD8095', 'M'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVWidth]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

	DECLARE @ID INT
	DECLARE @ComparisonSet INT

	CREATE TABLE #width(
		AppointmentPhotoID INT
		,	AppointmentGUID UNIQUEIDENTIFIER
		,	ClientGUID UNIQUEIDENTIFIER
		,	ComparisonSet INT
		,	Gender NVARCHAR(1)
		,	EthnicityID INT
		,	ethnicity_code INT
		,	EthnicityDescriptionShort NVARCHAR(10)
		,	PhotoTypeID INT
		,	PhotoTypeDescription NVARCHAR(100)
		,	ScalpAreaID INT
		,	ScalpRegionID INT
		,	ScalpRegionDescriptionShort NVARCHAR(10)
		,	AppointmentPhotoModified VARBINARY(MAX)
		,	ScalpAreaDescription NVARCHAR(100)
		,	ScalpRegionDescription NVARCHAR(100)
		,	PhotoLightTypeID INT
		,	PhotoLightTypeDescription NVARCHAR(100)
		,	PhotoLensID INT
		,	PhotoLensDescription NVARCHAR(100)
		,	ReportResourceImageName NVARCHAR(50)
		,	ReportResourceImage VARBINARY(MAX)
		,	NoteForClient NVARCHAR(500)

	)

		CREATE TABLE #compwidth(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	Gender NVARCHAR(1)
			,	EthnicityDescriptionShort NVARCHAR(10)
			,	WidthControlPhoto VARBINARY(MAX)
			,	WidthThinningPhoto VARBINARY(MAX)
			,	WidthControlPhotoNote NVARCHAR(500)
			,	WidthThinningPhotoNote NVARCHAR(500)
			,	WidthControlCaption NVARCHAR(100)
			,	WidthThinningCaption NVARCHAR(100)
			,	WCPhotoLightTypeDescription NVARCHAR(100)
			,	WTPhotoLightTypeDescription NVARCHAR(100)
			,	WCPhotoLensDescription NVARCHAR(100)
			,	WTPhotoLensDescription NVARCHAR(100)
			,	WCScalpRegionDescription NVARCHAR(100)
			,	WTScalpRegionDescription NVARCHAR(100)
			,	WidthControlImage VARBINARY(MAX)
			,	WidthThinningImage VARBINARY(MAX)
			)


	INSERT INTO #width

	SELECT ap.AppointmentPhotoID
			,	ap.AppointmentGUID
			,	clt.ClientGUID
			,	ap.ComparisonSet
			,	LOWER(@Gender) AS 'Gender'
			,	eth.EthnicityID
			,	eth.BOSEthnicityCode
			,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
			,	ap.PhotoTypeID
			,	pt.PhotoTypeDescription
			,	ap.ScalpAreaID
			,	ap.ScalpRegionID
			,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
			,	ap.AppointmentPhotoModified
			,	sa.ScalpAreaDescription
			--,	sr.ScalpRegionDescription
			,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
			,	ap.PhotoLightTypeID
			--,	plt.PhotoLightTypeDescription
			,	plt.DescriptionResourceKey AS 'PhotoLightTypeDescription'
			,	ap.PhotoLensID
			,	pl.PhotoLensDescription
			,	NULL AS 'ReportResourceImageName'
			,	NULL AS ReportResourceImage
			,	NoteForClient
	 FROM   datAppointmentPhoto ap
		INNER JOIN dbo.datAppointment appt
			ON ap.AppointmentGUID = appt.AppointmentGUID
		LEFT OUTER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT OUTER JOIN dbo.datClientDemographic cd
			ON clt.ClientGUID = cd.ClientGUID
		LEFT OUTER JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT OUTER JOIN dbo.lkpEthnicity eth
			ON cd.EthnicityID = eth.EthnicityID AND eth.IsActiveFlag = 1
		LEFT OUTER JOIN dbo.lkpPhotoType pt
			ON ap.PhotoTypeID = pt.PhotoTypeID
		LEFT OUTER JOIN dbo.lkpPhotoCaption pc
			ON ap.PhotoCaptionID = pc.PhotoCaptionID
		LEFT OUTER JOIN dbo.lkpScalpArea sa
			ON ap.ScalpAreaID = sa.ScalpAreaID
		LEFT OUTER JOIN dbo.lkpScalpRegion sr
			ON ap.ScalpRegionID = sr.ScalpRegionID
		LEFT JOIN dbo.lkpPhotoLens pl
			ON ap.PhotoLensID = pl.PhotoLensID
		LEFT OUTER JOIN dbo.lkpPhotoLightType plt
			ON ap.PhotoLightTypeID = plt.PhotoLightTypeID
	 WHERE  ap.AppointmentGUID = @AppointmentGUID
			AND ap.PhotoTypeID IN (5)  -- 5 is Width


/************* If there is a client record, update ethnicity and NorwoodScale from datClientDemographic ***********************/

		IF (SELECT TOP 1 ClientGUID FROM #width) IS NOT NULL
		BEGIN
			UPDATE w
			SET w.EthnicityID = CD.EthnicityID
			FROM #width w
			INNER JOIN dbo.datClientDemographic CD
				ON w.ClientGUID = CD.ClientGUID
		END

/**************** Find the ReportResourceImageName and ReportResourceImage ****************************************************/
UPDATE #width
	SET #width.ReportResourceImageName = LOWER(@Gender)+'_'+ISNULL(LOWER(ISNULL(eth.EthnicityDescriptionShort,cd.EthnicityDescriptionShort)),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort)
	FROM #width
	LEFT OUTER JOIN dbo.lkpEthnicity eth
			ON #width.ethnicity_code = eth.BOSEthnicityCode AND eth.IsActiveFlag = 1
	LEFT OUTER JOIN lkpEthnicity cd
			ON #width.EthnicityID = cd.EthnicityID
	LEFT OUTER JOIN dbo.lkpScalpRegion sr
			ON #width.ScalpRegionID = sr.ScalpRegionID

UPDATE #width
	SET #width.ReportResourceImage = rri.ReportResourceImage
	FROM #width
	INNER JOIN lkpReportResourceImage rri
		ON #width.ReportResourceImageName = rri.ReportResourceImageName

	/*********** ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison(ID INT IDENTITY(1,1),	ComparisonSet INT)

	INSERT INTO #comparison(ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #width
	--WHERE #width.ComparisonSet IN(1,2,3)
	WHERE #width.ComparisonSet = 1  --Added 11/11/2014 RH per Andre
	ORDER BY #width.ComparisonSet


	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID = (SELECT MIN(ID) FROM #comparison)
	PRINT @ID
	--Loop through each ComparisonSet
	WHILE @ID IS NOT NULL
	BEGIN

	SET @ComparisonSet = (SELECT ComparisonSet FROM #comparison WHERE ID = @ID)
	PRINT @ComparisonSet

	INSERT INTO #compwidth

    SELECT dw.AppointmentGUID
				,	dw.ComparisonSet
				,	Gender
				,	EthnicityDescriptionShort

			--These values are from the Width screen
				  ,	WidthControlPhoto = (SELECT   AppointmentPhotoModified
										   FROM     #width
										   WHERE    PhotoTypeID = 5	--Width
													AND ScalpAreaID = 1  --Control
													AND ComparisonSet = @ComparisonSet
										  )
				  , WidthThinningPhoto = (SELECT  AppointmentPhotoModified
											FROM    #width
											WHERE   PhotoTypeID = 5
													AND ScalpAreaID = 2	--Thinning
													AND ComparisonSet = @ComparisonSet
										   )
				,	WidthControlPhotoNote = (SELECT   NoteForClient
										   FROM     #width
										   WHERE    PhotoTypeID = 5	--Width
													AND ScalpAreaID = 1  --Control
													AND ComparisonSet = @ComparisonSet
										  )
				  , WidthThinningPhotoNote = (SELECT  NoteForClient
											FROM    #width
											WHERE   PhotoTypeID = 5
													AND ScalpAreaID = 2	--Thinning
													AND ComparisonSet = @ComparisonSet
										   )
				  , WidthControlCaption = (SELECT ScalpRegionDescription
											 FROM   #width
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 1
													AND ComparisonSet = @ComparisonSet
											)
				  , WidthThinningCaption = (SELECT    ScalpRegionDescription
											  FROM      #width
											  WHERE     PhotoTypeID = 5
														AND ScalpAreaID = 2
														AND ComparisonSet = @ComparisonSet
											 )
				, WCPhotoLightTypeDescription = (SELECT #width.PhotoLightTypeDescription
											 FROM   #width
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 1
													AND ComparisonSet = @ComparisonSet
											)
		  		, WTPhotoLightTypeDescription = (SELECT #width.PhotoLightTypeDescription
											  FROM      #width
											  WHERE     PhotoTypeID = 5
													  AND ScalpAreaID = 2
													  AND ComparisonSet = @ComparisonSet
											)
				,	WCPhotoLensDescription = (SELECT #width.PhotoLensDescription
											 FROM   #width
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 1
													AND ComparisonSet = @ComparisonSet
											)
		  		,	WTPhotoLensDescription = (SELECT #width.PhotoLensDescription
											 FROM   #width
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 2
													AND ComparisonSet = @ComparisonSet
											)
				,	WCScalpRegionDescription = (SELECT  #width.ScalpRegionDescription
												FROM    #width
												WHERE   PhotoTypeID = 5
														AND ScalpAreaID = 1
														AND ComparisonSet = @ComparisonSet
											)
				,	WTScalpRegionDescription = (SELECT  #width.ScalpRegionDescription
												FROM    #width
												WHERE   PhotoTypeID = 5
														AND ScalpAreaID = 2
														AND ComparisonSet = @ComparisonSet
											)
				  ,	WidthControlImage = (SELECT   ReportResourceImage
										   FROM     #width
										   WHERE    PhotoTypeID = 5	--Width
													AND ScalpAreaID = 1  --Control
													AND ComparisonSet = @ComparisonSet
											)
				  , WidthThinningImage = (SELECT  ReportResourceImage
											FROM    #width
											WHERE   PhotoTypeID = 5
													AND ScalpAreaID = 2	--Thinning
													AND ComparisonSet = @ComparisonSet
											)
			FROM   #width dw
				INNER JOIN #comparison c ON dw.ComparisonSet = c.ComparisonSet
			WHERE c.ID = @ID


		--Then at the end of the loop
		SET @ID = (SELECT MIN(ID)
				FROM #comparison
				WHERE ID > @ID)
	END

		/************************** Final Select ******************************************/

	SELECT  AppointmentGUID
		,	ComparisonSet
		,	Gender
		,	EthnicityDescriptionShort
		,	WidthControlPhoto
		,	WidthThinningPhoto
		,	WidthControlPhotoNote
		,	WidthThinningPhotoNote
		,	WidthControlCaption
		,	WidthThinningCaption
		,	WCPhotoLightTypeDescription
		,	WTPhotoLightTypeDescription
  		,	WCPhotoLensDescription
		,	WTPhotoLensDescription
		,	WCScalpRegionDescription
		,	WTScalpRegionDescription
		,	WidthControlImage
		,	WidthThinningImage
	FROM #compwidth

	GROUP BY AppointmentGUID
		,	ComparisonSet
		,	Gender
		,	EthnicityDescriptionShort
		,	WidthControlPhoto
		,	WidthThinningPhoto
		,	WidthControlPhotoNote
		,	WidthThinningPhotoNote
		,	WidthControlCaption
		,	WidthThinningCaption
		,	WCPhotoLightTypeDescription
		,	WTPhotoLightTypeDescription
		,	WCPhotoLensDescription
		,	WTPhotoLensDescription
		,	WCScalpRegionDescription
		,	WTScalpRegionDescription
		,	WidthControlImage
		,	WidthThinningImage

END
GO
