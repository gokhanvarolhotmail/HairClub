/* CreateDate: 10/07/2014 10:34:40.420 , ModifyDate: 11/16/2017 13:18:40.423 */
GO
/*===============================================================================================
 Procedure Name:				[rptTVComparativeDensity]
 Procedure Description:			This stored procedure provides the data for the Density grids.
 Created By:					Rachelen Hut
 Date Created:					09/22/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView Comparative Analysis
================================================================================================
Change History:
05/07/2015	RH	Changed OnContact_cstd_activity_demographic_TABLE to datClientDemographic
07/18/2016	RH	(#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC [rptTVComparativeDensity] 'EC452657-C50C-48F9-80EF-2F4936EC88B2', 'EC452657-C50C-48F9-80EF-2F4936EC88B2','M'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVComparativeDensity]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @Notes NVARCHAR(MAX)
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT
	DECLARE @Notes2 NVARCHAR(MAX)

	CREATE TABLE #density(
			AppointmentPhotoID INT
			,	AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	ComparisonSet INT
			,	Gender NVARCHAR(1)
			,	EthnicityID INT
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
	CREATE TABLE #density2(
			AppointmentPhotoID INT
			,	AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	ComparisonSet INT
			,	Gender NVARCHAR(1)
			,	EthnicityID INT
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

CREATE TABLE #compdensity(AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	ComparisonSet INT
			,	Gender NVARCHAR(1)
			,	EthnicityDescriptionShort NVARCHAR(10)
			,	ControlNormalPhoto VARBINARY(MAX)
			,	ControlPolarizedPhoto VARBINARY(MAX)
			,	ThinningNormalPhoto VARBINARY(MAX)
			,	ThinningPolarizedPhoto VARBINARY(MAX)
			,	ControlNormalPhotoNote NVARCHAR(500)
			,	ControlPolarizedPhotoNote NVARCHAR(500)
			,	ThinningNormalPhotoNote NVARCHAR(500)
			,	ThinningPolarizedPhotoNote NVARCHAR(500)
			,	CN_ScalpRegionDescription NVARCHAR(100)
			,	CP_ScalpRegionDescription NVARCHAR(100)
			,	TN_ScalpRegionDescription NVARCHAR(100)
			,	TP_ScalpRegionDescription NVARCHAR(100)
			,	CN_PhotoLensDescription NVARCHAR(100)
			,	CP_PhotoLensDescription NVARCHAR(100)
			,	TN_PhotoLensDescription NVARCHAR(100)
			,	TP_PhotoLensDescription NVARCHAR(100)
			,	DensityControlImage VARBINARY(MAX)
			,	DensityThinningImage VARBINARY(MAX)
			)

			CREATE TABLE #compdensity2(
				AppointmentGUID2 UNIQUEIDENTIFIER
			,	AppointmentDate2 DATETIME
			,	ComparisonSet2 INT
			,	Gender2 NVARCHAR(1)
			,	EthnicityDescriptionShort2 NVARCHAR(10)
			,	ControlNormalPhoto2 VARBINARY(MAX)
			,	ControlPolarizedPhoto2 VARBINARY(MAX)
			,	ThinningNormalPhoto2 VARBINARY(MAX)
			,	ThinningPolarizedPhoto2 VARBINARY(MAX)
			,	ControlNormalPhotoNote2 NVARCHAR(500)
			,	ControlPolarizedPhotoNote2 NVARCHAR(500)
			,	ThinningNormalPhotoNote2 NVARCHAR(500)
			,	ThinningPolarizedPhotoNote2 NVARCHAR(500)
			,	CN_ScalpRegionDescription2 NVARCHAR(100)
			,	CP_ScalpRegionDescription2 NVARCHAR(100)
			,	TN_ScalpRegionDescription2 NVARCHAR(100)
			,	TP_ScalpRegionDescription2 NVARCHAR(100)
			,	CN_PhotoLensDescription2 NVARCHAR(100)
			,	CP_PhotoLensDescription2 NVARCHAR(100)
			,	TN_PhotoLensDescription2 NVARCHAR(100)
			,	TP_PhotoLensDescription2 NVARCHAR(100)
			,	DensityControlImage2 VARBINARY(MAX)
			,	DensityThinningImage2 VARBINARY(MAX)
			)

/************************ Comparative 1 ********************************************/

INSERT INTO #density
SELECT ap.AppointmentPhotoID
			,	ap.AppointmentGUID
			,	appt.AppointmentDate
			,	ap.ComparisonSet
			,	LOWER(@Gender) AS 'Gender'
			,	cd.EthnicityID
			,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
			,	ap.PhotoTypeID
			,	pt.DescriptionResourceKey AS 'PhotoTypeDescription'
			,	ap.ScalpAreaID
			,	ap.ScalpRegionID
			,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
			,	ap.AppointmentPhotoModified
			,	sa.DescriptionResourceKey AS 'ScalpAreaDescription'
			,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
			,	ap.PhotoLightTypeID
			,	plt.DescriptionResourceKey AS 'PhotoLightTypeDescription'
			,	ap.PhotoLensID
			,	pl.DescriptionResourceKey AS 'PhotoLensDescription'
			,	CASE WHEN @Gender = 'F' THEN 'm'+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) --Default for now
			ELSE LOWER(@Gender)+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) END AS 'ReportResourceImageName'
			,	NULL AS ReportResourceImage
			,	NoteForClient

	 FROM   datAppointmentPhoto ap
		INNER JOIN dbo.datAppointment appt
			ON ap.AppointmentGUID = appt.AppointmentGUID
		INNER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON appt.ClientGUID = cd.ClientGUID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON cd.EthnicityID = eth.EthnicityID AND eth.IsActiveFlag = 1
		LEFT JOIN dbo.lkpPhotoType pt
			ON ap.PhotoTypeID = pt.PhotoTypeID
		LEFT JOIN dbo.lkpPhotoCaption pc
			ON ap.PhotoCaptionID = pc.PhotoCaptionID
		LEFT JOIN dbo.lkpScalpArea sa
			ON ap.ScalpAreaID = sa.ScalpAreaID
		LEFT JOIN dbo.lkpScalpRegion sr
			ON ap.ScalpRegionID = sr.ScalpRegionID
		LEFT JOIN dbo.lkpPhotoLens pl
			ON ap.PhotoLensID = pl.PhotoLensID
		LEFT JOIN dbo.lkpPhotoLightType plt
			ON ap.PhotoLightTypeID = plt.PhotoLightTypeID
	 WHERE  ap.AppointmentGUID = @AppointmentGUID
			AND ap.PhotoTypeID IN (4)

	UPDATE #density
	SET #density.ReportResourceImage = rri.ReportResourceImage
	FROM #density
	INNER JOIN lkpReportResourceImage rri
		ON #density.ReportResourceImageName = rri.ReportResourceImageName

	/*********** ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison(ID INT IDENTITY(1,1),	ComparisonSet INT)

	INSERT INTO #comparison(ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #density
	WHERE ComparisonSet = 1  --Added 11/11/2014 RH per Andre
	ORDER BY #density.ComparisonSet

	--SELECT * FROM #density
	--SELECT * FROM #comparison

	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID = (SELECT MIN(ID) FROM #comparison)
	PRINT @ID
	--Loop through each ComparisonSet
	WHILE @ID IS NOT NULL
	BEGIN

	SET @ComparisonSet = (SELECT ComparisonSet FROM #comparison WHERE ID = @ID)
	PRINT @ComparisonSet

	INSERT INTO #compdensity
	SELECT dw.AppointmentGUID
			,	dw.AppointmentDate
			,	dw.ComparisonSet
			,	Gender
			,	EthnicityDescriptionShort
			--These values are from the Density screen
			,	ControlNormalPhoto = (SELECT   AppointmentPhotoModified
											   FROM     #density
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1 --Normal
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ControlPolarizedPhoto = (SELECT   AppointmentPhotoModified
											   FROM     #density
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2  --Polarized
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	ThinningNormalPhoto = (SELECT   AppointmentPhotoModified
											   FROM     #density
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ThinningPolarizedPhoto = (SELECT   AppointmentPhotoModified
											   FROM     #density
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	ControlNormalPhotoNote = (SELECT   NoteForClient
											   FROM     #density
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ControlPolarizedPhotoNote = (SELECT   NoteForClient
											   FROM     #density
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	ThinningNormalPhotoNote = (SELECT   NoteForClient
											   FROM     #density
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ThinningPolarizedPhotoNote = (SELECT   NoteForClient
											   FROM     #density
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized


			,	CN_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #density
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	CP_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #density
												WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	TN_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #density
												WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	TP_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #density
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized

			,	CN_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #density
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	CP_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #density
												WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	TN_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #density
												WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	TP_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #density
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized


					  ,	DensityControlImage = (SELECT   ReportResourceImage
											   FROM     #density
											   WHERE    PhotoTypeID = 4	--Density
														AND ScalpAreaID = 1  --Control
														AND ComparisonSet = @ComparisonSet
											  )
					  , DensityThinningImage = (SELECT  ReportResourceImage
												FROM    #density
												WHERE   PhotoTypeID = 4
														AND ScalpAreaID = 2	--Thinning
														AND ComparisonSet = @ComparisonSet
											  )
				 FROM   #density dw
					INNER JOIN #comparison c ON dw.ComparisonSet = c.ComparisonSet
				WHERE c.ID = @ID



		--Then at the end of the loop
		SET @ID = (SELECT MIN(ID)
				FROM #comparison
				WHERE ID > @ID)
	END

	/************************************************************************************/

INSERT INTO #density2
SELECT ap.AppointmentPhotoID
			,	ap.AppointmentGUID
			,	appt.AppointmentDate
			,	ap.ComparisonSet
			,	LOWER(@Gender) AS 'Gender'
			,	cd.EthnicityID
			,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
			,	ap.PhotoTypeID
			,	pt.DescriptionResourceKey AS 'PhotoTypeDescription'
			,	ap.ScalpAreaID
			,	ap.ScalpRegionID
			,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
			,	ap.AppointmentPhotoModified
			,	sa.DescriptionResourceKey AS 'ScalpAreaDescription'
			,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
			,	ap.PhotoLightTypeID
			,	plt.DescriptionResourceKey AS 'PhotoLightTypeDescription'
			,	ap.PhotoLensID
			,	pl.DescriptionResourceKey AS 'PhotoLensDescription'
			,	CASE WHEN @Gender = 'F' THEN 'm'+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) --Default for now
			ELSE LOWER(@Gender)+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) END AS 'ReportResourceImageName'
			,	NULL AS ReportResourceImage
			,	NoteForClient

	 FROM   datAppointmentPhoto ap
		INNER JOIN dbo.datAppointment appt
			ON ap.AppointmentGUID = appt.AppointmentGUID
		INNER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON appt.ClientGUID = cd.ClientGUID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON cd.EthnicityID = eth.EthnicityID AND eth.IsActiveFlag = 1
		LEFT JOIN dbo.lkpPhotoType pt
			ON ap.PhotoTypeID = pt.PhotoTypeID
		LEFT JOIN dbo.lkpPhotoCaption pc
			ON ap.PhotoCaptionID = pc.PhotoCaptionID
		LEFT JOIN dbo.lkpScalpArea sa
			ON ap.ScalpAreaID = sa.ScalpAreaID
		LEFT JOIN dbo.lkpScalpRegion sr
			ON ap.ScalpRegionID = sr.ScalpRegionID
		LEFT JOIN dbo.lkpPhotoLens pl
			ON ap.PhotoLensID = pl.PhotoLensID
		LEFT JOIN dbo.lkpPhotoLightType plt
			ON ap.PhotoLightTypeID = plt.PhotoLightTypeID
	 WHERE  ap.AppointmentGUID = @AppointmentGUID2
			AND ap.PhotoTypeID IN (4)

	UPDATE #density2
	SET #density2.ReportResourceImage = rri.ReportResourceImage
	FROM #density2
	INNER JOIN lkpReportResourceImage rri
		ON #density2.ReportResourceImageName = rri.ReportResourceImageName

	/*********** Comparative 2: ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison2(ID2 INT IDENTITY(1,1),	ComparisonSet2 INT)

	INSERT INTO #comparison2(ComparisonSet2)
	SELECT DISTINCT ComparisonSet
	FROM #density2
	WHERE ComparisonSet = 1  --Added 11/11/2014 RH per Andre
	GROUP BY #density2.ComparisonSet
	ORDER BY #density2.ComparisonSet

	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID2 = (SELECT MIN(ID2) FROM #comparison2)
	PRINT @ID2
	--Loop through each ComparisonSet
	WHILE @ID2 IS NOT NULL
	BEGIN

	SET @ComparisonSet2 = (SELECT ComparisonSet2 FROM #comparison2 WHERE ID2 = @ID2)
	PRINT @ComparisonSet2

	INSERT INTO #compdensity2
	SELECT dw2.AppointmentGUID AS 'AppointmentGUID2'
					,	dw2.AppointmentDate AS 'AppointmentDate2'
					,	dw2.ComparisonSet AS 'ComparisonSet2'
					,	Gender AS 'Gender2'
					,	EthnicityDescriptionShort AS 'EthnicityDescriptionShort2'
			--These values are from the Density screen
			,	ControlNormalPhoto2 = (SELECT   AppointmentPhotoModified
											   FROM     #density2
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1 --Normal
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	ControlPolarizedPhoto2 = (SELECT   AppointmentPhotoModified
											   FROM     #density2
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2  --Polarized
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized
			,	ThinningNormalPhoto2 = (SELECT   AppointmentPhotoModified
											   FROM     #density2
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	ThinningPolarizedPhoto2 = (SELECT   AppointmentPhotoModified
											   FROM     #density2
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized
			,	ControlNormalPhotoNote2 = (SELECT   NoteForClient
											   FROM     #density2
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	ControlPolarizedPhotoNote2 = (SELECT   NoteForClient
											   FROM     #density2
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized
			,	ThinningNormalPhotoNote2 = (SELECT   NoteForClient
											   FROM     #density2
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	ThinningPolarizedPhotoNote2 = (SELECT   NoteForClient
											   FROM     #density2
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized
			,	CN_ScalpRegionDescription2 = (SELECT   ScalpRegionDescription
											   FROM     #density2
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	CP_ScalpRegionDescription2 = (SELECT   ScalpRegionDescription
											   FROM     #density2
												WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized
			,	TN_ScalpRegionDescription2 = (SELECT   ScalpRegionDescription
											   FROM     #density2
												WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	TP_ScalpRegionDescription2 = (SELECT   ScalpRegionDescription
											   FROM     #density2
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized

			,	CN_PhotoLensDescription2 = (SELECT   PhotoLensDescription
											   FROM     #density2
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	CP_PhotoLensDescription2 = (SELECT   PhotoLensDescription
											   FROM     #density2
												WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized
			,	TN_PhotoLensDescription2 = (SELECT   PhotoLensDescription
											   FROM     #density2
												WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet2
														)  --Normal
			,	TP_PhotoLensDescription2 = (SELECT   PhotoLensDescription
											   FROM     #density2
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet2
														)  --Polarized


				,	DensityControlImage2 = (SELECT   ReportResourceImage
											   FROM     #density2
											   WHERE    PhotoTypeID = 4	--Density
														AND ScalpAreaID = 1  --Control
														AND ComparisonSet = @ComparisonSet2
											  )
				, DensityThinningImage2 = (SELECT  ReportResourceImage
												FROM    #density2
												WHERE   PhotoTypeID = 4
														AND ScalpAreaID = 2	--Thinning
														AND ComparisonSet = @ComparisonSet2
											  )

				 FROM   #density2 dw2
					INNER JOIN #comparison2 c ON dw2.ComparisonSet = c.ComparisonSet2
				WHERE c.ID2 = @ID2



		--Then at the end of the loop
		SET @ID2 = (SELECT MIN(ID2)
				FROM #comparison2
				WHERE ID2 > @ID2)
	END


		/************************** Final Select ******************************************/

		SELECT  1 AS 'Comparative1'
	,	a.AppointmentGUID
	,	a.AppointmentDate
	,	a.ComparisonSet
      , a.Gender
      , a.EthnicityDescriptionShort
      , a.ControlNormalPhoto
      , a.ControlPolarizedPhoto
      , a.ThinningNormalPhoto
      , a.ThinningPolarizedPhoto
	        , a.ControlNormalPhotoNote
      , a.ControlPolarizedPhotoNote
      , a.ThinningNormalPhotoNote
      , a.ThinningPolarizedPhotoNote
      , a.CN_ScalpRegionDescription
      , a.CP_ScalpRegionDescription
      , a.TN_ScalpRegionDescription
      , a.TP_ScalpRegionDescription
      , a.CN_PhotoLensDescription
      , a.CP_PhotoLensDescription
      , a.TN_PhotoLensDescription
      , a.TP_PhotoLensDescription
      , a.DensityControlImage
      , a.DensityThinningImage
	,	b.AppointmentGUID2
	,	b.AppointmentDate2
	,	b.ComparisonSet2
      , b.Gender2
      , b.EthnicityDescriptionShort2
      , b.ControlNormalPhoto2
      , b.ControlPolarizedPhoto2
      , b.ThinningNormalPhoto2
      , b.ThinningPolarizedPhoto2
	        , b.ControlNormalPhotoNote2
      , b.ControlPolarizedPhotoNote2
      , b.ThinningNormalPhotoNote2
      , b.ThinningPolarizedPhotoNote2
      , b.CN_ScalpRegionDescription2
      , b.CP_ScalpRegionDescription2
      , b.TN_ScalpRegionDescription2
      , b.TP_ScalpRegionDescription2
      , b.CN_PhotoLensDescription2
      , b.CP_PhotoLensDescription2
      , b.TN_PhotoLensDescription2
      , b.TP_PhotoLensDescription2
      , b.DensityControlImage2
      , b.DensityThinningImage2
	FROM #compdensity a, #compdensity2 b
	GROUP BY
	a.AppointmentGUID
	,	a.AppointmentDate
	,	a.ComparisonSet
      , a.Gender
      , a.EthnicityDescriptionShort
      , a.ControlNormalPhoto
      , a.ControlPolarizedPhoto
      , a.ThinningNormalPhoto
      , a.ThinningPolarizedPhoto
	        , a.ControlNormalPhotoNote
      , a.ControlPolarizedPhotoNote
      , a.ThinningNormalPhotoNote
      , a.ThinningPolarizedPhotoNote
      , a.CN_ScalpRegionDescription
      , a.CP_ScalpRegionDescription
      , a.TN_ScalpRegionDescription
      , a.TP_ScalpRegionDescription
      , a.CN_PhotoLensDescription
      , a.CP_PhotoLensDescription
      , a.TN_PhotoLensDescription
      , a.TP_PhotoLensDescription
      , a.DensityControlImage
      , a.DensityThinningImage
	,	b.AppointmentGUID2
	,	b.AppointmentDate2
	,	b.ComparisonSet2
      , b.Gender2
      , b.EthnicityDescriptionShort2
      , b.ControlNormalPhoto2
      , b.ControlPolarizedPhoto2
      , b.ThinningNormalPhoto2
      , b.ThinningPolarizedPhoto2
	        , b.ControlNormalPhotoNote2
      , b.ControlPolarizedPhotoNote2
      , b.ThinningNormalPhotoNote2
      , b.ThinningPolarizedPhotoNote2
      , b.CN_ScalpRegionDescription2
      , b.CP_ScalpRegionDescription2
      , b.TN_ScalpRegionDescription2
      , b.TP_ScalpRegionDescription2
      , b.CN_PhotoLensDescription2
      , b.CP_PhotoLensDescription2
      , b.TN_PhotoLensDescription2
      , b.TP_PhotoLensDescription2
      , b.DensityControlImage2
      , b.DensityThinningImage2


END
GO
