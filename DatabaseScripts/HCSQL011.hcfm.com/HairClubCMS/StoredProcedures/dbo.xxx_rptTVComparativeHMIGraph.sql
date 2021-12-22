/* CreateDate: 10/10/2014 10:50:14.410 , ModifyDate: 01/02/2015 15:58:34.633 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:				[rptTVComparativeHMIGraph]
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
REMEMBER TO CHANGE THE DEV TO NON_DEV
================================================================================================

Sample Execution:

EXEC [rptTVComparativeHMIGraph] '8CB6378D-1452-49AB-83FD-61CAC9EE207F' ,'F79E28FB-583D-4948-B09B-3930C893A09F','M'

================================================================================================*/

CREATE PROCEDURE [dbo].[xxx_rptTVComparativeHMIGraph]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

/*********************** Comparative One ****************************************************/
	DECLARE @setID INT
	DECLARE @ComparisonSet INT


	CREATE TABLE #calculations(AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	ComparisonSet INT
		,	PhotoTypeID INT
		,	PhotoTypeDescription NVARCHAR(100)
		,	ScalpAreaID INT
		,	ScalpAreaDescription NVARCHAR(100)
		,	DensityInMMSquared FLOAT
		,	DiameterInMicrons FLOAT
		,	AverageWidth FLOAT
		)

	CREATE TABLE #comparisonset(
		ID INT IDENTITY (1,1)
		,	ComparisonSet INT
		)

	CREATE TABLE #hcmi(
		AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	ComparisonSet INT
		,	HMIC FLOAT
		,	HMIT FLOAT
		)


		INSERT INTO #calculations
			(AppointmentGUID
			,	AppointmentDate
			,	ComparisonSet
			,	PhotoTypeID
			,	PhotoTypeDescription
			,	ScalpAreaID
			,	ScalpAreaDescription
			,	DensityInMMSquared
			,	DiameterInMicrons
			,	AverageWidth )

		SELECT  dap.AppointmentGUID
				,	appt.AppointmentDate
			,	dap.ComparisonSet
			,	dap.PhotoTypeID
			,	lpt.PhotoTypeDescription
			,	dap.ScalpAreaID
			,	lsa.ScalpAreaDescription
			,	DensityInMMSquared
			,	DiameterInMicrons
			,	AverageWidth

		FROM    dbo.datAppointmentPhoto dap (NOLOCK)
			INNER JOIN datAppointment appt (NOLOCK)
				ON dap.AppointmentGUID = appt.AppointmentGUID
			LEFT JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
				ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
			INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
				ON dap.PhotoTypeID = lpt.PhotoTypeID
			INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
				ON dap.ScalpAreaID = lsa.ScalpAreaID
		WHERE   dap.AppointmentGUID = @AppointmentGUID


		--SELECT * FROM #calculations



	/*************** Find the Comparison Sets ******************************************/

	INSERT INTO #comparisonset
		    (ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #calculations
	WHERE ComparisonSet = 1 --Added 11/11/2014 RH per Andre

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

		INSERT INTO #hcmi

		SELECT AppointmentGUID
		,	AppointmentDate
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
		,	AppointmentDate
		,	ComparisonSet



		/************************Then at the end of the loop *****************/
		SELECT @setID = MIN(ID)
			FROM #comparisonset
			WHERE ID > @setID

	END

	--SELECT * FROM #hcmi

	/*******************************  Comparative Two ********************************************/

	DECLARE @setID2 INT
	DECLARE @ComparisonSet2 INT


	CREATE TABLE #calculations2(AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	ComparisonSet INT
		,	PhotoTypeID INT
		,	PhotoTypeDescription NVARCHAR(100)
		,	ScalpAreaID INT
		,	ScalpAreaDescription NVARCHAR(100)
		,	DensityInMMSquared FLOAT
		,	DiameterInMicrons FLOAT
		,	AverageWidth FLOAT
		)

	CREATE TABLE #comparisonset2(
		ID INT IDENTITY (1,1)
		,	ComparisonSet INT
		)

	CREATE TABLE #hcmi2(
		AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	ComparisonSet INT
		,	HMIC FLOAT
		,	HMIT FLOAT
		)

		INSERT INTO #calculations2
			(AppointmentGUID
			,	AppointmentDate
			,	ComparisonSet
			,	PhotoTypeID
			,	PhotoTypeDescription
			,	ScalpAreaID
			,	ScalpAreaDescription
			,	DensityInMMSquared
			,	DiameterInMicrons
			,	AverageWidth )

		SELECT  dap.AppointmentGUID
				,	appt.AppointmentDate
			,	dap.ComparisonSet
			,	dap.PhotoTypeID
			,	lpt.PhotoTypeDescription
			,	dap.ScalpAreaID
			,	lsa.ScalpAreaDescription
			,	DensityInMMSquared
			,	DiameterInMicrons
			,	AverageWidth

		FROM    dbo.datAppointmentPhoto dap (NOLOCK)
			INNER JOIN dbo.datAppointment appt (NOLOCK)
				ON dap.AppointmentGUID = appt.AppointmentGUID
			LEFT JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
				ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
			INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
				ON dap.PhotoTypeID = lpt.PhotoTypeID
			INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
				ON dap.ScalpAreaID = lsa.ScalpAreaID
		WHERE   dap.AppointmentGUID = @AppointmentGUID2


		--SELECT * FROM #calculations2



	/*************** Find the Comparison Sets ******************************************/

	INSERT INTO #comparisonset2
		    (ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #calculations2
	WHERE ComparisonSet = 1 --Added 11/11/2014 RH per Andre

	--SELECT * FROM #comparisonset2

	--Set the @setID Variable for first iteration
	SELECT @setID2 = MIN(ID)
	FROM #comparisonset2

	--Loop through each comparison set
	WHILE @setID2 IS NOT NULL
	BEGIN
		SET @ComparisonSet2 = (SELECT ComparisonSet FROM #comparisonset2 WHERE ID = @setID2)

						/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			DECLARE @Width_C2 FLOAT
			DECLARE @Width_T2 FLOAT

			DECLARE @Density_C2 FLOAT
			DECLARE @Density_T2 FLOAT

			SET @Width_C2 = (SELECT SUM(AverageWidth)
							FROM #calculations2
							WHERE ScalpAreaID = 1
							AND PhotoTypeID = 5
							AND ComparisonSet = @ComparisonSet2)  --Width

			SET @Width_T2 = (SELECT SUM(AverageWidth)
							FROM #calculations2
							WHERE ScalpAreaID = 2
							AND PhotoTypeID = 5
							AND ComparisonSet = @ComparisonSet2)  --Width


			SET @Density_C2 = (SELECT SUM(DensityInMMSquared)
							FROM #calculations2
							WHERE ScalpAreaID = 1
							AND PhotoTypeID = 4
							AND ComparisonSet = @ComparisonSet2 )  --Density

			SET @Density_T2 = (SELECT SUM(DensityInMMSquared)
							FROM #calculations2
							WHERE ScalpAreaID = 2
							AND PhotoTypeID = 4
							AND ComparisonSet = @ComparisonSet2 )  --Density


				PRINT @Width_C2
				PRINT @Width_T2

				PRINT @Density_C2
				PRINT @Density_T2

		INSERT INTO #hcmi2

		SELECT AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
				--HMI = (PI() x SQUARE(width/2) x density/0.01) x 100
			,	HMIC = (SELECT TOP 1 (PI()*SQUARE(@Width_C2/2)*@Density_C2/0.01)*.0001
							FROM #calculations2
							WHERE ScalpAreaID = 1
							AND ComparisonSet = @ComparisonSet2)


			,	HMIT = (SELECT TOP 1 (PI()*SQUARE(@Width_T2/2)*@Density_T2/0.01)*.0001
							FROM #calculations2
							WHERE ScalpAreaID = 2
							AND ComparisonSet = @ComparisonSet2)
		FROM #calculations2
		GROUP BY AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet



		/************************Then at the end of the loop *****************/
		SELECT @setID2 = MIN(ID)
			FROM #comparisonset2
			WHERE ID > @setID2

	END

	--SELECT * FROM #hcmi2


	/************************** Final Select ******************************************/

	SELECT AppointmentGUID
	,	AppointmentDate
	,	ComparisonSet
	,	HMIC
	,	HMIT
	,	CASE WHEN HMIC = 0  THEN 0 ELSE (HMIT/HMIC)*100 END AS 'AverageHMI_Diff'
	FROM

		(SELECT AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
		,	HMIC
		,	HMIT
		FROM #hcmi
		UNION
		SELECT AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
		,	HMIC
		,	HMIT
		FROM #hcmi2)q

	GROUP BY AppointmentGUID
	,	AppointmentDate
	,	ComparisonSet
	,	HMIC
	,	HMIT



END
GO
