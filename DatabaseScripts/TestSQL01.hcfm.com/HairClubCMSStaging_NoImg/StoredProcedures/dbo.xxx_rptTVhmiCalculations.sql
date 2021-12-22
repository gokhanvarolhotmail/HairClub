/* CreateDate: 10/13/2014 15:36:03.903 , ModifyDate: 11/11/2014 17:33:17.703 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:				[rptTVhmiCalculations]
 Procedure Description:			This stored procedure provides the data for the Density and Width grids
									and the HMI page.
 Created By:					Rachelen Hut
 Date Created:					08/04/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView
================================================================================================
		PhotoTypeID = 4 is Density
		PhotoTypeID = 5 is Width
		ScalpAreaID = 1 is Control
		ScalpAreaID = 2 is Thinning
================================================================================================
CHANGE HISTORY:

================================================================================================

Sample Execution:

EXEC [rptTVhmiCalculations] '8CB6378D-1452-49AB-83FD-61CAC9EE207F'

================================================================================================*/

CREATE PROCEDURE [dbo].[xxx_rptTVhmiCalculations]
	@AppointmentGUID UNIQUEIDENTIFIER

AS
BEGIN
	DECLARE @setID INT
	DECLARE @ComparisonSet INT


	CREATE TABLE #calculations(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	PhotoTypeDescription NVARCHAR(100)
			,	ScalpAreaID INT
			,	ScalpAreaDescription NVARCHAR(100)
			,	DensityInMMSquared FLOAT
			,	DiameterInMicrons FLOAT
			,	AverageWidth FLOAT)

	CREATE TABLE #comparisonset(
	ID INT IDENTITY (1,1)
	,	ComparisonSet INT
	)


		INSERT INTO #calculations
			(AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	PhotoTypeDescription
			,	ScalpAreaID
			,	ScalpAreaDescription
			,	DensityInMMSquared
			,	DiameterInMicrons
			,	AverageWidth )

		SELECT  dap.AppointmentGUID
			,	dap.ComparisonSet
			,	dap.PhotoTypeID
			,	lpt.PhotoTypeDescription
			,	dap.ScalpAreaID
			,	lsa.ScalpAreaDescription
			,	DensityInMMSquared
			,	DiameterInMicrons
			,	AverageWidth

		FROM   datAppointmentPhoto dap (NOLOCK)
				LEFT JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
					ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
				INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
					ON dap.PhotoTypeID = lpt.PhotoTypeID
				INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
					ON dap.ScalpAreaID = lsa.ScalpAreaID

		WHERE   AppointmentGUID = @AppointmentGUID


		--SELECT * FROM #calculations



	/*************** Find the Comparison Sets ******************************************/

	INSERT INTO #comparisonset
		    (ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #calculations
	WHERE ComparisonSet = 1  --Added 11/11/2014 RH per Andre

	--SELECT * FROM #comparisonset

	--Set the @setID Variable for first iteration
	SELECT @setID = MIN(ID)
	FROM #comparisonset

	--Loop through each comparison set
	WHILE @setID IS NOT NULL
	BEGIN
		SET @ComparisonSet = (SELECT ComparisonSet FROM #comparisonset WHERE ID = @setID)

						/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			DECLARE @Width_C FLOAT
			DECLARE @Width_T FLOAT

			DECLARE @Density_C FLOAT
			DECLARE @Density_T FLOAT

			SET @Width_C = (SELECT SUM(AverageWidth)
							FROM #calculations
							WHERE ScalpAreaID = 1
							AND PhotoTypeID = 5
							AND ComparisonSet = @ComparisonSet)  --Width

			SET @Width_T = (SELECT SUM(AverageWidth)
							FROM #calculations
							WHERE ScalpAreaID = 2
							AND PhotoTypeID = 5
							AND ComparisonSet = @ComparisonSet)  --Width


			SET @Density_C = (SELECT SUM(DensityInMMSquared)
							FROM #calculations
							WHERE ScalpAreaID = 1
							AND PhotoTypeID = 4
							AND ComparisonSet = @ComparisonSet )  --Density

			SET @Density_T = (SELECT SUM(DensityInMMSquared)
							FROM #calculations
							WHERE ScalpAreaID = 2
							AND PhotoTypeID = 4
							AND ComparisonSet = @ComparisonSet )  --Density


				PRINT @Width_C
				PRINT @Width_T

				PRINT @Density_C
				PRINT @Density_T

		SELECT AppointmentGUID
		,	ComparisonSet
			,	HMIC = (SELECT TOP 1 (PI()*SQUARE(@Width_C/2)*(@Density_C)/0.01)*.0001
							FROM #calculations
							WHERE ScalpAreaID = 1
							AND ComparisonSet = @ComparisonSet)


			,	HMIT = (SELECT TOP 1 (PI()*SQUARE(@Width_T/2)*(@Density_T)/0.01)*.0001
							FROM #calculations
							WHERE ScalpAreaID = 2
							AND ComparisonSet = @ComparisonSet)
		FROM #calculations
		GROUP BY AppointmentGUID
		,	ComparisonSet



		/************************Then at the end of the loop *****************/
		SELECT @setID = MIN(ID)
			FROM #comparisonset
			WHERE ID > @setID

	END



END
GO
