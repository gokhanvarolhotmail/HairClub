/* CreateDate: 09/05/2014 09:12:43.827 , ModifyDate: 09/25/2018 15:35:08.420 */
GO
/*===============================================================================================
Procedure Name:				[rptTVDensity]
Procedure Description:			This stored procedure provides the data for the Density grids.
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
11/30/2017 - RH - (#144445) Changed logic to join on datClientDemographic for ethnicity, removed join on OnContact_cstd_activity_demographic_TABLE
================================================================================================
Sample Execution:

EXEC [rptTVDensity] '42420209-854D-4E89-85E3-39FE064CF40F', 'M'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVDensity]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

	DECLARE @ID INT
	DECLARE @ComparisonSet INT

	CREATE TABLE #density(
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


	CREATE TABLE #compdensity(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	Gender NVARCHAR(1)
			,	EthnicityDescriptionShort NVARCHAR(10)
			,	DensityControlPhoto VARBINARY(MAX)
			,	DensityThinningPhoto VARBINARY(MAX)
			,	DensityControlPhotoNote NVARCHAR(500)
			,	DensityThinningPhotoNote NVARCHAR(500)
			,	DensityControlCaption NVARCHAR(100)
			,	DensityThinningCaption NVARCHAR(100)
			,	DCPhotoLightTypeDescription NVARCHAR(100)
			,	DTPhotoLightTypeDescription NVARCHAR(100)
			,	DCPhotoLensDescription NVARCHAR(100)
			,	DTPhotoLensDescription NVARCHAR(100)
			,	DCScalpRegionDescription NVARCHAR(100)
			,	DTScalpRegionDescription NVARCHAR(100)
			,	DensityControlImage VARBINARY(MAX)
			,	DensityThinningImage VARBINARY(MAX)
			)

INSERT INTO #density
SELECT ap.AppointmentPhotoID
			,	ap.AppointmentGUID
			,	clt.ClientGUID
			,	ap.ComparisonSet
			,	LOWER(@Gender) AS 'Gender'
			,	eth.EthnicityID
			,	eth.BOSEthnicityCode AS 'ethnicity_code'
			,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
			,	ap.PhotoTypeID
			,	pt.PhotoTypeDescription
			,	ap.ScalpAreaID
			,	ap.ScalpRegionID
			,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
			,	ap.AppointmentPhotoModified
			,	sa.ScalpAreaDescription
			,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
			,	ap.PhotoLightTypeID
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
			ON cd.ClientGUID = appt.ClientGUID
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
		LEFT OUTER JOIN dbo.lkpPhotoLens pl
			ON ap.PhotoLensID = pl.PhotoLensID
		LEFT OUTER JOIN dbo.lkpPhotoLightType plt
			ON ap.PhotoLightTypeID = plt.PhotoLightTypeID
	 WHERE  ap.AppointmentGUID = @AppointmentGUID
			AND ap.PhotoTypeID IN (4)



/**************** Find the ReportResourceImageName and ReportResourceImage  *****************************************************/
UPDATE #density
	SET #density.ReportResourceImageName = LOWER(@Gender)+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort)
	FROM #density
	LEFT OUTER JOIN lkpEthnicity eth
			ON #density.EthnicityID = eth.EthnicityID
	LEFT OUTER JOIN dbo.lkpScalpRegion sr
			ON #density.ScalpRegionID = sr.ScalpRegionID


	UPDATE #density
	SET #density.ReportResourceImage = rri.ReportResourceImage
	FROM #density
	INNER JOIN dbo.lkpReportResourceImage rri
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
					,	dw.ComparisonSet
					,	Gender
					,	EthnicityDescriptionShort
			--These values are from the Density screen
					  ,	DensityControlPhoto = (SELECT   AppointmentPhotoModified
											   FROM     #density
											   WHERE    PhotoTypeID = 4	--Density
														AND ScalpAreaID = 1  --Control
														AND ComparisonSet = @ComparisonSet
											  )
					  , DensityThinningPhoto = (SELECT  AppointmentPhotoModified
												FROM    #density
												WHERE   PhotoTypeID = 4
														AND ScalpAreaID = 2	--Thinning
														AND ComparisonSet = @ComparisonSet
											   )

					,	DensityControlPhotoNote = (SELECT   NoteForClient
											   FROM     #density
											   WHERE    PhotoTypeID = 4	--Density
														AND ScalpAreaID = 1  --Control
														AND ComparisonSet = @ComparisonSet
											  )
					  , DensityThinningPhotoNote  = (SELECT  NoteForClient
												FROM    #density
												WHERE   PhotoTypeID = 4
														AND ScalpAreaID = 2	--Thinning
														AND ComparisonSet = @ComparisonSet
												)
					  , DensityControlCaption = (SELECT ScalpRegionDescription
												 FROM   #density
												 WHERE  PhotoTypeID = 4
														AND ScalpAreaID = 1
														AND ComparisonSet = @ComparisonSet
												)
					  , DensityThinningCaption = (SELECT    ScalpRegionDescription
												  FROM      #density
												  WHERE     PhotoTypeID = 4
														  AND ScalpAreaID = 2
														  AND ComparisonSet = @ComparisonSet
												)

						, DCPhotoLightTypeDescription = (SELECT #density.PhotoLightTypeDescription
												 FROM   #density
												 WHERE  PhotoTypeID = 4
														AND ScalpAreaID = 1
														AND ComparisonSet = @ComparisonSet
												)
					  , DTPhotoLightTypeDescription = (SELECT    #density.PhotoLightTypeDescription
												  FROM      #density
												  WHERE     PhotoTypeID = 4
														  AND ScalpAreaID = 2
														  AND ComparisonSet = @ComparisonSet
												)
					,	DCPhotoLensDescription = (SELECT #density.PhotoLensDescription
												 FROM   #density
												 WHERE  PhotoTypeID = 4
														AND ScalpAreaID = 1
														AND ComparisonSet = @ComparisonSet
												)
		  			,	DTPhotoLensDescription = (SELECT    #density.PhotoLensDescription
												  FROM      #density
												  WHERE     PhotoTypeID = 4
														  AND ScalpAreaID = 2
														  AND ComparisonSet = @ComparisonSet
												)
					,	DCScalpRegionDescription = (SELECT    #density.ScalpRegionDescription
													FROM      #density
													WHERE     PhotoTypeID = 4
															AND ScalpAreaID = 1
															AND ComparisonSet = @ComparisonSet
												)
					,	DTScalpRegionDescription = (SELECT    #density.ScalpRegionDescription
													FROM      #density
													WHERE     PhotoTypeID = 4
															AND ScalpAreaID = 2
															AND ComparisonSet = @ComparisonSet
												)
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
					--INNER JOIN dbo.datAppointmentPhoto dap ON dw.AppointmentGUID = dap.AppointmentGUID
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
			,	DensityControlPhoto
			,	DensityThinningPhoto
					,	DensityControlPhotoNote
			,	DensityThinningPhotoNote
			,	DensityControlCaption
			,	DensityThinningCaption
			,	DCPhotoLightTypeDescription
			,	DTPhotoLightTypeDescription
			,	DCPhotoLensDescription
			,	DTPhotoLensDescription
			,	DCScalpRegionDescription
			,	DTScalpRegionDescription
			,	DensityControlImage
			,	DensityThinningImage
		FROM    #compdensity

		GROUP BY AppointmentGUID
		,	ComparisonSet
			,	Gender
			,	EthnicityDescriptionShort
			,	DensityControlPhoto
			,	DensityThinningPhoto
					,	DensityControlPhotoNote
			,	DensityThinningPhotoNote
			,	DensityControlCaption
			,	DensityThinningCaption
			,	DCPhotoLightTypeDescription
			,	DTPhotoLightTypeDescription
			,	DCPhotoLensDescription
			,	DTPhotoLensDescription
			,	DCScalpRegionDescription
			,	DTScalpRegionDescription
			,	DensityControlImage
			,	DensityThinningImage


END
GO
