/* CreateDate: 08/21/2014 14:57:29.053 , ModifyDate: 09/17/2019 10:27:39.020 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
Procedure Name:				rptTVHairandScalp
Procedure Description:			This stored procedure provides the data for the Scalp Health grids.
Created By:					Rachelen Hut
Date Created:					08/04/2014
Destination Server.Database:   SQL01.HairclubCMS
Related Application:			TrichoView
================================================================================================
Notes: This stored procedure is used for the Hair and Scalp screen in TrichoView.
================================================================================================
Change History:
05/07/2015 - RH - Changed OnContact_cstd_activity_demographic_TABLE to datClientDemographic
03/04/2016 - RH - Changed to find the Ethnicity first from onContact, then update if they are a client
07/18/2016 - RH - (#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC rptTVHairandScalp '82B7B8C6-ECC0-45A6-B751-A5C543A8352B', 'M'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVHairandScalp]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@Gender  NVARCHAR(1)

AS
BEGIN

	DECLARE @ID INT
	DECLARE @ComparisonSet INT

	CREATE TABLE #hairscalp(
			AppointmentPhotoID INT
			,	AppointmentGUID UNIQUEIDENTIFIER
			,	ClientGUID UNIQUEIDENTIFIER
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

INSERT INTO #hairscalp
SELECT ap.AppointmentPhotoID
			,	ap.AppointmentGUID
			,	clt.ClientGUID
			,	ap.ComparisonSet
			,	LOWER(@Gender) AS 'Gender'
			,	ISNULL(eth.EthnicityID,4) AS 'EthnicityID'
			,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
			,	ap.PhotoTypeID
			,	pt.PhotoTypeDescription
			,	ap.ScalpAreaID
			,	ap.ScalpRegionID
			,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
			,	ap.AppointmentPhoto
			,	sa.ScalpAreaDescription
			--,	sr.ScalpRegionDescription
			,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
			,	ap.PhotoLightTypeID
			,	plt.PhotoLightTypeDescription
			,	ap.PhotoLensID
			--,	pl.PhotoLensDescription
			,	pl.DescriptionResourceKey AS 'PhotoLensDescription'
			,	NULL AS 'ReportResourceImageName'
			,	NULL AS ReportResourceImage
			,	NoteForClient

	 FROM   datAppointmentPhoto ap
		INNER JOIN dbo.datAppointment appt
			ON ap.AppointmentGUID = appt.AppointmentGUID
		LEFT OUTER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic onc
			ON clt.ClientGUID = onc.ClientGUID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON onc.EthnicityID = eth.EthnicityID
			AND eth.IsActiveFlag = 1
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
			AND ComparisonSet = 1  --Added 11/11/2014 RH per Andre


	/************* If the ethnicity and scale do not populate and there is a client record, get the information from datClient ******/

	IF (SELECT TOP 1 ClientGUID FROM #hairscalp) IS NOT NULL
	BEGIN
	UPDATE i
	SET i.EthnicityID = CD.EthnicityID
	,	i.EthnicityDescriptionShort = eth.EthnicityDescriptionShort
	FROM #hairscalp i
	INNER JOIN dbo.datClientDemographic CD
		ON i.ClientGUID = CD.ClientGUID
	INNER JOIN lkpEthnicity eth
		ON CD.EthnicityID = eth.EthnicityID
	END

	/***********UPDATE #Hairscalp with the ReportResourceImageName ******************************/

	UPDATE #hairscalp
	SET ReportResourceImageName = CASE WHEN @Gender = 'F' THEN 'm'+'_'+ISNULL(LOWER(EthnicityDescriptionShort),'as')+'_x'+LOWER(ScalpRegionDescriptionShort) --Default for now
			ELSE LOWER(@Gender)+'_'+ISNULL(LOWER(EthnicityDescriptionShort),'as')+'_x'+LOWER(ScalpRegionDescriptionShort) END
	FROM #hairscalp
	WHERE ReportResourceImageName IS NULL

	/*********Get the ReportResourceImage *******************************************************************/

	UPDATE #hairscalp
	SET #hairscalp.ReportResourceImage = rri.ReportResourceImage
	FROM #hairscalp
	INNER JOIN lkpReportResourceImage rri
		ON #hairscalp.ReportResourceImageName = rri.ReportResourceImageName
	WHERE PhotoLightTypeID IN(1,2)


	/*********** ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison(ID INT IDENTITY(1,1),	ComparisonSet INT)

	INSERT INTO #comparison(ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #hairscalp
	WHERE ComparisonSet = 1  --Added 11/11/2014 RH per Andre
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
									   WHERE    PhotoTypeID = 2	  --Scalp
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


	/************************** Final Select ******************************************/

	SELECT  AppointmentGUID
	,	ComparisonSet
      , Gender
      , EthnicityDescriptionShort
      , ControlNormalPhoto
      , ControlPolarizedPhoto
      , ThinningNormalPhoto
      , ThinningPolarizedPhoto
	        , ControlNormalPhotoNote
      , ControlPolarizedPhotoNote
      , ThinningNormalPhotoNote
      , ThinningPolarizedPhotoNote
      , CN_ScalpRegionDescription
      , CP_ScalpRegionDescription
      , TN_ScalpRegionDescription
      , TP_ScalpRegionDescription
      , CN_PhotoLensDescription
      , CP_PhotoLensDescription
      , TN_PhotoLensDescription
      , TP_PhotoLensDescription
      , ScalpControlImage
      , ScalpThinningImage
	FROM #comphairnscalp

	GROUP BY AppointmentGUID
	,	ComparisonSet
      , Gender
      , EthnicityDescriptionShort
      , ControlNormalPhoto
      , ControlPolarizedPhoto
      , ThinningNormalPhoto
      , ThinningPolarizedPhoto
	  , ControlNormalPhotoNote
      , ControlPolarizedPhotoNote
      , ThinningNormalPhotoNote
      , ThinningPolarizedPhotoNote
      , CN_ScalpRegionDescription
      , CP_ScalpRegionDescription
      , TN_ScalpRegionDescription
      , TP_ScalpRegionDescription
      , CN_PhotoLensDescription
      , CP_PhotoLensDescription
      , TN_PhotoLensDescription
      , TP_PhotoLensDescription
      , ScalpControlImage
      , ScalpThinningImage

END
GO
