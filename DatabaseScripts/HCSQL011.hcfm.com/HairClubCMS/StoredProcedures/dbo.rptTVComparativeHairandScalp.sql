/* CreateDate: 10/07/2014 10:35:30.440 , ModifyDate: 08/15/2016 23:35:57.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:				rptTVComparativeHairandScalp
 Procedure Description:			This stored procedure provides the data for the Scalp Health grids.
 Created By:					Rachelen Hut
 Date Created:					08/04/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView
================================================================================================
Notes: This stored procedure is used for the Hair and Scalp screen in TrichoView.
================================================================================================
Change History:
05/07/2015	RH	Changed OnContact_cstd_activity_demographic_TABLE to datClientDemographic
07/18/2016 - RH - (#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC rptTVComparativeHairandScalp '0D532C05-53AC-41FE-978A-5F1CD4CC7320', 'F79E28FB-583D-4948-B09B-3930C893A09F','M'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVComparativeHairandScalp]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender  NVARCHAR(1)

AS
BEGIN

	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT

	CREATE TABLE #hairscalp(
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
			,	AppointmentPhoto VARBINARY(MAX)
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

		CREATE TABLE #hairscalp2(
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
			,	AppointmentPhoto VARBINARY(MAX)
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

		CREATE TABLE #comphairnscalp(AppointmentGUID UNIQUEIDENTIFIER
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
			,	ScalpControlImage VARBINARY(MAX)
			,	ScalpThinningImage VARBINARY(MAX)
			)

			CREATE TABLE #comphairnscalp2(
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
			,	ScalpControlImage2 VARBINARY(MAX)
			,	ScalpThinningImage2 VARBINARY(MAX)
			)

INSERT INTO #hairscalp
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
			,	ap.AppointmentPhoto
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
			ON ap.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON ap.ClientGUID = cd.ClientGUID
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
			AND ap.PhotoTypeID IN (2) --Scalp

	UPDATE #hairscalp
	SET #hairscalp.ReportResourceImage = rri.ReportResourceImage
	FROM #hairscalp
	INNER JOIN lkpReportResourceImage rri
		ON #hairscalp.ReportResourceImageName = rri.ReportResourceImageName
	--WHERE PhotoLightTypeID IN(1,2)

	/*********** Comparative 1: ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison(ID INT IDENTITY(1,1),	ComparisonSet INT)

	INSERT INTO #comparison(ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #hairscalp
	WHERE ComparisonSet = 1 --Added 11/11/2014 RH per Andre
	ORDER BY #hairscalp.ComparisonSet

	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID = (SELECT MIN(ID) FROM #comparison)
	PRINT @ID
	--Loop through each ComparisonSet
	WHILE @ID IS NOT NULL
	BEGIN

	SET @ComparisonSet = (SELECT ComparisonSet FROM #comparison WHERE ID = @ID)
	PRINT @ComparisonSet

	INSERT INTO #comphairnscalp
	SELECT hs.AppointmentGUID
			,	hs.AppointmentDate
			,	hs.ComparisonSet
			,	Gender
			,	EthnicityDescriptionShort
			,	ControlNormalPhoto = (SELECT   AppointmentPhoto
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ControlPolarizedPhoto = (SELECT   AppointmentPhoto
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	ThinningNormalPhoto = (SELECT   AppointmentPhoto
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ThinningPolarizedPhoto = (SELECT   AppointmentPhoto
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
						,	ControlNormalPhotoNote = (SELECT   NoteForClient
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ControlPolarizedPhotoNote = (SELECT   NoteForClient
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	ThinningNormalPhotoNote = (SELECT   NoteForClient
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	ThinningPolarizedPhotoNote = (SELECT   NoteForClient
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized


			,	CN_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	CP_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #hairscalp
												WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	TN_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #hairscalp
												WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	TP_ScalpRegionDescription = (SELECT   ScalpRegionDescription
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized

			,	CN_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	CP_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #hairscalp
												WHERE    ScalpAreaID = 1	--Control
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			,	TN_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #hairscalp
												WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 1
														AND ComparisonSet = @ComparisonSet
														)  --Normal
			,	TP_PhotoLensDescription = (SELECT   PhotoLensDescription
											   FROM     #hairscalp
											   WHERE    ScalpAreaID = 2	--Thinning
														AND PhotoLightTypeID = 2
														AND ComparisonSet = @ComparisonSet
														)  --Polarized
			  ,	ScalpControlImage = (SELECT  TOP 1 ReportResourceImage
									   FROM     #hairscalp
									   WHERE    PhotoTypeID = 2	--Scalp
												AND ScalpAreaID = 1  --Control
												AND ComparisonSet = @ComparisonSet
										)
			  , ScalpThinningImage = (SELECT TOP 1 ReportResourceImage
										FROM    #hairscalp
										WHERE   PhotoTypeID = 2
												AND ScalpAreaID = 2	--Thinning
												AND ComparisonSet = @ComparisonSet

										)
		FROM #hairscalp hs
		INNER JOIN #comparison c ON hs.ComparisonSet = c.ComparisonSet
		WHERE c.ID = @ID

		--Then at the end of the loop
		SET @ID = (SELECT MIN(ID)
				FROM #comparison
				WHERE ID > @ID)
	END



	/****************************Comparative 2*****************************************/
	INSERT INTO #hairscalp2
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
			,	ap.AppointmentPhoto
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
			ON ap.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON ap.ClientGUID = cd.ClientGUID
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
			AND ap.PhotoTypeID IN (2) --Scalp

	UPDATE #hairscalp2
	SET #hairscalp2.ReportResourceImage = rri.ReportResourceImage
	FROM #hairscalp2
	INNER JOIN lkpReportResourceImage rri
		ON #hairscalp2.ReportResourceImageName = rri.ReportResourceImageName


	/*********** Comparative 2: ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison2(ID2 INT IDENTITY(1,1),	ComparisonSet2 INT)

	INSERT INTO #comparison2(ComparisonSet2)
	SELECT DISTINCT #hairscalp2.ComparisonSet AS 'ComparisonSet2'
	FROM #hairscalp2
	WHERE ComparisonSet = 1 --Added 11/11/2014 RH per Andre
	GROUP BY #hairscalp2.ComparisonSet
	ORDER BY #hairscalp2.ComparisonSet

	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID2 = (SELECT MIN(ID2) FROM #comparison2)
	PRINT @ID2
	--Loop through each ComparisonSet
	WHILE @ID2 IS NOT NULL
	BEGIN

		SET @ComparisonSet2 = (SELECT ComparisonSet2 FROM #comparison2 WHERE ID2 = @ID2)
		PRINT @ComparisonSet2

		INSERT INTO #comphairnscalp2
		SELECT hs2.AppointmentGUID AS 'AppointmentGUID2'
				,	hs2.AppointmentDate AS 'AppointmentDate2'
				,	hs2.ComparisonSet AS 'ComparisonSet2'
				,	Gender AS 'Gender2'
				,	EthnicityDescriptionShort  AS 'EthnicityDescriptionShort2'
				,	ControlNormalPhoto2 = (SELECT   TOP 1 AppointmentPhoto
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	ControlPolarizedPhoto2 = (SELECT   TOP 1  AppointmentPhoto
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized
				,	ThinningNormalPhoto2 = (SELECT   TOP 1  AppointmentPhoto
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	ThinningPolarizedPhoto2 = (SELECT   TOP 1  AppointmentPhoto
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized
							,	ControlNormalPhotoNote2 = (SELECT   TOP 1  NoteForClient
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	ControlPolarizedPhotoNote2 = (SELECT   TOP 1  NoteForClient
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized
				,	ThinningNormalPhotoNote2 = (SELECT   TOP 1  NoteForClient
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	ThinningPolarizedPhotoNote2 = (SELECT   TOP 1  NoteForClient
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized


				,	CN_ScalpRegionDescription2 = (SELECT   TOP 1  ScalpRegionDescription
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	CP_ScalpRegionDescription2 = (SELECT  TOP 1   ScalpRegionDescription
												   FROM     #hairscalp2
													WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized
				,	TN_ScalpRegionDescription2 = (SELECT   TOP 1  ScalpRegionDescription
												   FROM     #hairscalp2
													WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	TP_ScalpRegionDescription2 = (SELECT   TOP 1  ScalpRegionDescription
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized

				,	CN_PhotoLensDescription2 = (SELECT  TOP 1   PhotoLensDescription
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	CP_PhotoLensDescription2 = (SELECT   TOP 1  PhotoLensDescription
												   FROM     #hairscalp2
													WHERE    ScalpAreaID = 1	--Control
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized
				,	TN_PhotoLensDescription2 = (SELECT  TOP 1   PhotoLensDescription
												   FROM     #hairscalp2
													WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 1
															AND ComparisonSet = @ComparisonSet2
															)  --Normal
				,	TP_PhotoLensDescription2 = (SELECT  TOP 1   PhotoLensDescription
												   FROM     #hairscalp2
												   WHERE    ScalpAreaID = 2	--Thinning
															AND PhotoLightTypeID = 2
															AND ComparisonSet = @ComparisonSet2
															)  --Polarized
				  ,	ScalpControlImage2 = (SELECT  TOP 1 ReportResourceImage
										   FROM     #hairscalp2
										   WHERE    PhotoTypeID = 2	--Scalp
													AND ScalpAreaID = 1  --Control
													AND ComparisonSet = @ComparisonSet2
											)
				  , ScalpThinningImage2 = (SELECT TOP 1 ReportResourceImage
											FROM    #hairscalp2
											WHERE   PhotoTypeID = 2
													AND ScalpAreaID = 2	--Thinning
													AND ComparisonSet = @ComparisonSet2

											)
			FROM #hairscalp2 hs2
			INNER JOIN #comparison2 c2 ON hs2.ComparisonSet = c2.ComparisonSet2
			WHERE c2.ID2 = @ID2

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
      , a.ScalpControlImage
      , a.ScalpThinningImage
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
      , b.ScalpControlImage2
      , b.ScalpThinningImage2
	FROM #comphairnscalp a, #comphairnscalp2 b
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
      , a.ScalpControlImage
      , a.ScalpThinningImage
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
      , b.ScalpControlImage2
      , b.ScalpThinningImage2



END
GO
