/*===============================================================================================
 Procedure Name:				rptTVDensityandWidthScreen
 Procedure Description:			This stored procedure provides the data for the Density and Width grids.
 Created By:					Rachelen Hut
 Date Created:					08/04/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView
================================================================================================
CHANGE HISTORY:
07/18/2016 - RH - (#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC rptTVDensityandWidthScreen '358BF9C1-1884-4E4A-848F-06412548B54E'

EXEC rptTVDensityandWidthScreen '041574FA-1152-40D8-863B-32F95AB8DB91'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVDensityandWidthScreen]
	@AppointmentGUID UNIQUEIDENTIFIER

AS
BEGIN

	(SELECT ap.AppointmentPhotoID
		  , ap.AppointmentGUID
		  , ap.PhotoTypeID
		  , pt.DescriptionResourceKey AS 'PhotoTypeDescription'
		  , ap.ScalpAreaID
		  , ap.ScalpRegionID
		  , ap.ComparisonSet
		  , ap.AppointmentPhoto
		  , sa.DescriptionResourceKey AS 'ScalpAreaDescription'
		  , sr.DescriptionResourceKey AS 'ScalpRegionDescription'
		  ,	ap.PhotoLightTypeID
		  , plt.DescriptionResourceKey AS 'PhotoLightTypeDescription'
		  ,	ap.PhotoLensID
		  ,	pl.DescriptionResourceKey AS 'PhotoLensDescription'
	 INTO   #densitywidth
	 FROM   datAppointmentPhoto ap
			INNER JOIN dbo.lkpPhotoType pt
				ON ap.PhotoTypeID = pt.PhotoTypeID
			INNER JOIN dbo.lkpScalpArea sa
				ON ap.ScalpAreaID = sa.ScalpAreaID
			INNER JOIN dbo.lkpScalpRegion sr
				ON ap.ScalpRegionID = sr.ScalpRegionID
			INNER JOIN dbo.lkpPhotoLightType plt
				ON ap.PhotoLightTypeID = plt.PhotoLightTypeID
			INNER JOIN dbo.lkpPhotoLens pl
				ON ap.PhotoLensID = pl.PhotoLensID
	 WHERE  AppointmentGUID = @AppointmentGUID
			AND ap.PhotoTypeID IN (4 ,5)
	)

	SELECT  AppointmentGUID
		  ,	DensityControlPhoto
		  , DensityThinningPhoto
		  , DensityControlCaption
		  , DensityThinningCaption
		  ,	WidthControlPhoto
		  , WidthThinningPhoto
		  , WidthControlCaption
		  , WidthThinningCaption
		  , DCPhotoLightTypeDescription
		  		  , DTPhotoLightTypeDescription
		  		  		  , WCPhotoLightTypeDescription
		  		  		  		  , WTPhotoLightTypeDescription
		  ,	DCPhotoLensDescription
		  		  ,	DTPhotoLensDescription
		  		  		  ,	WCPhotoLensDescription
		  		  		  		  ,	WTPhotoLensDescription
	FROM    (SELECT dw.AppointmentGUID
		--These values are from the Density screen
				  ,	DensityControlPhoto = (SELECT   AppointmentPhoto
										   FROM     #densitywidth
										   WHERE    PhotoTypeID = 4	--Density
													AND ScalpAreaID = 1  --Control
										  )
				  , DensityThinningPhoto = (SELECT  AppointmentPhoto
											FROM    #densitywidth
											WHERE   PhotoTypeID = 4
													AND ScalpAreaID = 2	--Thinning
										   )
				  , DensityControlCaption = (SELECT ScalpRegionDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 4
													AND ScalpAreaID = 1
											)
				  , DensityThinningCaption = (SELECT    ScalpRegionDescription
											  FROM      #densitywidth
											  WHERE     PhotoTypeID = 4
													  AND ScalpAreaID = 2
											)

				, DCPhotoLightTypeDescription = (SELECT #densitywidth.PhotoLightTypeDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 4
													AND ScalpAreaID = 1
											)
				  , DTPhotoLightTypeDescription = (SELECT    #densitywidth.PhotoLightTypeDescription
											  FROM      #densitywidth
											  WHERE     PhotoTypeID = 4
													  AND ScalpAreaID = 2
											)
				,	DCPhotoLensDescription = (SELECT #densitywidth.PhotoLensDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 4
													AND ScalpAreaID = 1
											)
		  		  ,	DTPhotoLensDescription = (SELECT    #densitywidth.PhotoLensDescription
											  FROM      #densitywidth
											  WHERE     PhotoTypeID = 4
													  AND ScalpAreaID = 2
											)

			--These values are from the Width screen
				  ,	WidthControlPhoto = (SELECT   AppointmentPhoto
										   FROM     #densitywidth
										   WHERE    PhotoTypeID = 5	--Width
													AND ScalpAreaID = 1  --Control
										  )
				  , WidthThinningPhoto = (SELECT  AppointmentPhoto
											FROM    #densitywidth
											WHERE   PhotoTypeID = 5
													AND ScalpAreaID = 2	--Thinning
										   )
				  , WidthControlCaption = (SELECT ScalpRegionDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 1
											)
				  , WidthThinningCaption = (SELECT    ScalpRegionDescription
											  FROM      #densitywidth
											  WHERE     PhotoTypeID = 5
														AND ScalpAreaID = 2
											 )
				, WCPhotoLightTypeDescription = (SELECT #densitywidth.PhotoLightTypeDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 1
											)
		  		, WTPhotoLightTypeDescription = (SELECT #densitywidth.PhotoLightTypeDescription
											  FROM      #densitywidth
											  WHERE     PhotoTypeID = 5
													  AND ScalpAreaID = 2
											)
				,	WCPhotoLensDescription = (SELECT #densitywidth.PhotoLensDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 1
											)
		  		,	WTPhotoLensDescription = (SELECT #densitywidth.PhotoLensDescription
											 FROM   #densitywidth
											 WHERE  PhotoTypeID = 5
													AND ScalpAreaID = 2
											)

			 FROM   #densitywidth dw
				INNER JOIN dbo.datAppointmentPhoto dap ON dw.AppointmentGUID = dap.AppointmentGUID
			) q
	GROUP BY AppointmentGUID
		  ,	DensityControlPhoto
		  , DensityThinningPhoto
		  , DensityControlCaption
		  , DensityThinningCaption
		  ,	WidthControlPhoto
		  , WidthThinningPhoto
		  , WidthControlCaption
		  , WidthThinningCaption
		  , DCPhotoLightTypeDescription
		  		  , DTPhotoLightTypeDescription
		  		  		  , WCPhotoLightTypeDescription
		  		  		  		  , WTPhotoLightTypeDescription
		  ,	DCPhotoLensDescription
		  		  ,	DTPhotoLensDescription
		  		  		  ,	WCPhotoLensDescription
		  		  		  		  ,	WTPhotoLensDescription

END
