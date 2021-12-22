/*===============================================================================================
 Procedure Name:				rptTVDensityandWidthCalculations
 Procedure Description:			This stored procedure provides the data for the Density and Width grids.
 Created By:					Rachelen Hut
 Date Created:					08/04/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView
================================================================================================
 NOTES:  DensityMM = photoMarkups.Count / EstimatedArea    where EstimatedArea = (PhotoLens.FOVX * PhotoLens.FOVY)
 To get the photoLens record from the Database (for the FOVX and FOVY data):
	Read the lkpPhotoLens table using the PhotoLensID from the datAppointmentPhoto record.
		PhotoTypeID = 4 is Density
		PhotoTypeID = 5 is Width
		ScalpAreaID = 1 is Control
		ScalpAreaID = 2 is Thinning
================================================================================================
Sample Execution:

EXEC rptTVDensityandWidthCalculations 'F79E28FB-583D-4948-B09B-3930C893A09F'

EXEC rptTVDensityandWidthCalculations '962144FA-41DD-41E0-80AC-9DBC2C1746E0'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVDensityandWidthCalculations]
	@AppointmentGUID UNIQUEIDENTIFIER


AS
BEGIN

	DECLARE @setID INT

	CREATE TABLE #comparisonset(ID INT IDENTITY(1,1), AppointmentGUID UNIQUEIDENTIFIER, ComparisonSet INT)

	CREATE TABLE #calculations(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	PhotoTypeDescription NVARCHAR(100)
			,	ScalpAreaID INT
			,	ScalpAreaDescription NVARCHAR(100)
			,	PhotoLensID INT
			,	FOVX FLOAT
			,	fovWidth FLOAT
			,	FOVY FLOAT
			,	fovHeight FLOAT
			,	EstimatedArea FLOAT
			,	Distance FLOAT
			,	COS_Rotation FLOAT
			,	SIN_Rotation FLOAT
			,	run FLOAT
			,	rise FLOAT)

	CREATE TABLE #dccount(AppointmentGUID UNIQUEIDENTIFIER, ComparisonSet INT, DCArea FLOAT, DCCount FLOAT)

	CREATE TABLE #dtcount(AppointmentGUID UNIQUEIDENTIFIER,  ComparisonSet INT, DTArea FLOAT, DTCount FLOAT)

	CREATE TABLE #wcdistance(AppointmentGUID UNIQUEIDENTIFIER,  ComparisonSet INT, WCMarkerWidth FLOAT, WTMarkerWidth FLOAT)

	CREATE TABLE #hmic(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	DCTerminals FLOAT
			,	DCArea FLOAT
			,	DensityControlRatio FLOAT
			,	DTTerminals FLOAT
			,	DTArea FLOAT
			,	DensityThinningRatio FLOAT
			,	WCMarkerWidth FLOAT
			,	WTMarkerWidth FLOAT
			,	HMIC FLOAT
			,	HMIT FLOAT)

	CREATE TABLE #markers(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	ScalpAreaID INT
			,	fovWidth FLOAT
			,	fovHeight FLOAT
			,	run FLOAT
			,	rise FLOAT
			,	Width FLOAT
			,	Height FLOAT)

	CREATE TABLE #widths(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	ScalpAreaID INT
			,	MarkerWidth FLOAT)

	CREATE TABLE #markerwidth(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	ScalpAreaID INT
			,	AvgWidth FLOAT)


	--Find Comparison Sets
	INSERT INTO #comparisonset
	SELECT AppointmentGUID
		,	ComparisonSet
	FROM datAppointmentPhoto
	WHERE AppointmentGUID = @AppointmentGUID
	--AND ComparisonSet < 4  --Only 3 comparison sets will be reported
	AND ComparisonSet = 1  --Added 11/11/2014 RH per Andre
	GROUP BY AppointmentGUID
		,	ComparisonSet

		--SELECT * FROM #comparisonset

	--Set the @setID Variable for first iteration
	SELECT @setID = MIN(ID)
	FROM #comparisonset

	--Loop through each comparison set
	WHILE @setID IS NOT NULL
	BEGIN

		INSERT INTO #calculations
		        (AppointmentGUID
		       , ComparisonSet
		       , PhotoTypeID
		       , PhotoTypeDescription
		       , ScalpAreaID
		       , ScalpAreaDescription
		       , PhotoLensID
		       , FOVX
		       , fovWidth
		       , FOVY
		       , fovHeight
		       , EstimatedArea
		       , Distance
		       , COS_Rotation
		       , SIN_Rotation
		       , run
		       , rise
		        )
		SELECT q.AppointmentGUID
			,	q.ComparisonSet
			,	q.PhotoTypeID
			,	q.PhotoTypeDescription
			,	q.ScalpAreaID
			,	q.ScalpAreaDescription
			,	q.PhotoLensID
			,	q.FOVX
			,	q.fovWidth
			,	q.FOVY
			,	q.fovHeight
			,	q.EstimatedArea
			,	q.Distance
			,	q.COS_Rotation
			,	q.SIN_Rotation
			,	(q.Distance * q.COS_Rotation) AS run
			,	(q.Distance * q.SIN_Rotation) AS rise

		FROM
				(SELECT  dap.AppointmentGUID
					,	dap.ComparisonSet
					,	dap.PhotoTypeID
					,	lpt.PhotoTypeDescription
					,	dap.ScalpAreaID
					,	lsa.ScalpAreaDescription
					,	dap.PhotoLensID
					,	lpl.FOVX
					,	(lpl.FOVX*1000) AS 'fovWidth'
					,	lpl.FOVY
					,	(lpl.FOVY*1000) AS 'fovHeight'
					,	(lpl.FOVX*lpl.FOVY) AS 'EstimatedArea'
					,	dapm.Distance
					,	dapm.Rotation
					,	COS(dapm.Rotation) AS COS_Rotation
					,	SIN(dapm.Rotation) AS SIN_Rotation
				FROM    datAppointmentPhoto dap (NOLOCK)
						INNER JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
							ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
						INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
							ON dap.PhotoTypeID = lpt.PhotoTypeID
						INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
							ON dap.ScalpAreaID = lsa.ScalpAreaID
						INNER JOIN dbo.lkpPhotoLens lpl (NOLOCK)
							ON dap.PhotoLensID = lpl.PhotoLensID
				WHERE   AppointmentGUID = @AppointmentGUID
				AND ComparisonSet = @setID
				)q

		--SELECT * FROM #calculations

		 --DensityControl
		INSERT INTO #dccount
		SELECT 	 AppointmentGUID
		,	ComparisonSet
		,	EstimatedArea AS 'DCArea'
		,	COUNT(PhotoTypeID) AS DCCount
		FROM #calculations
		WHERE PhotoTypeID = 4
		AND ScalpAreaID = 1
		GROUP BY  EstimatedArea
		,	AppointmentGUID
		,	ComparisonSet

		--SELECT 'dccount' AS tablename, * FROM #dccount


		--,	Density Thinning
		INSERT INTO #dtcount
		SELECT 	 AppointmentGUID
		,	ComparisonSet
		,	EstimatedArea AS 'DTArea'
		,	COUNT(PhotoTypeID) AS DTCount
		FROM #calculations
		WHERE PhotoTypeID = 4
		AND ScalpAreaID = 2
		GROUP BY  EstimatedArea
		,	AppointmentGUID
		,	ComparisonSet

		--SELECT 'dtcount' AS tablename, * FROM #dtcount


		/*******************************************************************
		This section uses the BARTH formula for finding the average width.

		********************************************************************/
		--AVG Width


		INSERT INTO #markers
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	fovWidth
			,	fovHeight
			,	run
			,	rise
			,	CAST(((fovWidth * run)/640) AS FLOAT) AS 'Width'
			,	CAST(((FovHeight * rise)/480) AS FLOAT) AS 'Height'
		FROM #calculations
		WHERE  PhotoTypeID = 5 --Width
			AND ComparisonSet = @setID

		--SELECT * FROM #markers

		INSERT INTO #widths
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	MarkerWidth = (SELECT ABS(SQRT((Width * Width) + (Height * Height))))
		FROM #markers
		WHERE ComparisonSet = @setID

		--SELECT 'Widths' AS TABLENAME, * FROM #widths

		/**********AverageWidth = Sum(MarkerWidths) / PhotoMarkups.count ******************/

		INSERT INTO #markerwidth
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	SUM(MarkerWidth)/COUNT(ScalpAreaID) AS AvgWidth
		FROM #widths
		WHERE ComparisonSet = @setID
		GROUP BY AppointmentGUID
			,	PhotoTypeID
			,	ScalpAreaID
			,	ComparisonSet

		--SELECT 'MarkerWidths' AS TABLENAME, * FROM #markerwidth

		/**************************************************************************************/
		IF @setID = 1
		BEGIN
			DECLARE @HMIC1 FLOAT
			DECLARE @HMIT1 FLOAT

			DECLARE @WCMarkerWidth1 FLOAT
			DECLARE @WTMarkerWidth1 FLOAT

			SET @WCMarkerWidth1 = (SELECT TOP 1 AvgWidth
									FROM #markerwidth
									WHERE PhotoTypeID = 5 AND ScalpAreaID = 1 AND  ComparisonSet = 1)
			SET @WTMarkerWidth1 = (SELECT TOP 1 AvgWidth
									FROM #markerwidth
									WHERE PhotoTypeID = 5 AND ScalpAreaID = 2 AND  ComparisonSet = 1)

			PRINT @WCMarkerWidth1
			PRINT @WTMarkerWidth1

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@WCMarkerWidth1 AS 'WCMarkerWidth'
				,	@WTMarkerWidth1 AS 'WTMarkerWidth'
			FROM #calculations
			WHERE ComparisonSet = 1


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC1 = (SELECT (PI()*SQUARE(@WCMarkerWidth1/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount dcc
							WHERE ComparisonSet = 1)

			SET @HMIT1 = (SELECT (PI()*SQUARE(@WTMarkerWidth1/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount dtc
							WHERE ComparisonSet = 1)


			--HMI Control and Thinning
			INSERT INTO #hmic(AppointmentGUID
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@HMIC1 AS 'HMIC'
				,	@HMIT1 AS 'HMIT'
			FROM #calculations
			WHERE ComparisonSet = 1
		END
		/*********************** @setID = 2 *************************************/
		/*ELSE IF @setID = 2
		BEGIN
			DECLARE @HMIC2 FLOAT
			DECLARE @HMIT2 FLOAT

			DECLARE @WCMarkerWidth2 FLOAT
			DECLARE @WTMarkerWidth2 FLOAT

			SET @WCMarkerWidth2 = (SELECT AvgWidth
										FROM #markerwidth
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 1 AND ComparisonSet = 2)
			SET @WTMarkerWidth2 = (SELECT AvgWidth
										FROM #markerwidth
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 2 AND ComparisonSet = 2)

			PRINT @WCMarkerWidth2
			PRINT @WTMarkerWidth2

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@WCMarkerWidth2 AS 'WCMarkerWidth'
				,	@WTMarkerWidth2 AS 'WTMarkerWidth'
			FROM #calculations
			WHERE ComparisonSet = 2


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC2 = (SELECT (PI()*SQUARE(@WCMarkerWidth2/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount dcc
							WHERE ComparisonSet = 2)

			SET @HMIT2 = (SELECT (PI()*SQUARE(@WTMarkerWidth2/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount dtc
							WHERE ComparisonSet = 2)


			--HMI Control and Thinning
			INSERT INTO #hmic(AppointmentGUID
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@HMIC2 AS 'HMIC'
				,	@HMIT2 AS 'HMIT'
			FROM #calculations
			WHERE ComparisonSet = 2
		END
		/*********************** @setID = 3 *************************************/
		ELSE IF @setID = 3
		BEGIN
			DECLARE @HMIC3 FLOAT
			DECLARE @HMIT3 FLOAT

			DECLARE @WCMarkerWidth3 FLOAT
			DECLARE @WTMarkerWidth3 FLOAT

			SET @WCMarkerWidth3 = (SELECT AvgWidth
										FROM #markerwidth
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 1 AND ComparisonSet = 3)
			SET @WTMarkerWidth3 = (SELECT AvgWidth
										FROM #markerwidth
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 2 AND ComparisonSet = 3)

			PRINT @WCMarkerWidth3
			PRINT @WTMarkerWidth3

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@WCMarkerWidth3 AS 'WCMarkerWidth'
				,	@WTMarkerWidth3 AS 'WTMarkerWidth'
			FROM #calculations
			WHERE ComparisonSet = 3


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC3 = (SELECT (PI()*SQUARE(@WCMarkerWidth3/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount dcc
							WHERE ComparisonSet = 3)

			SET @HMIT3 = (SELECT (PI()*SQUARE(@WTMarkerWidth3/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount dtc
							WHERE ComparisonSet = 3)


			--HMI Control and Thinning
			INSERT INTO #hmic(AppointmentGUID
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@HMIC3 AS 'HMIC'
				,	@HMIT3 AS 'HMIT'
			FROM #calculations
			WHERE ComparisonSet = 3
		END
		*/

		/************************Then at the end of the loop *****************/
		SELECT @setID = MIN(ID)
			FROM #comparisonset
			WHERE ID > @setID

	END

	--SELECT 'hmic' AS Tablename, * FROM #hmic

		/******************Final updates ***********************************/


		UPDATE hmic
		SET hmic.DCTerminals = dcc.DCCount
		,	hmic.DCArea = dcc.DCArea
		,	hmic.DensityControlRatio = (dcc.DCCount/dcc.DCArea)
		FROM #hmic hmic
		INNER JOIN #dccount dcc
			ON hmic.AppointmentGUID = dcc.AppointmentGUID
					AND hmic.ComparisonSet = dcc.ComparisonSet


		UPDATE hmic
		SET hmic.DTTerminals = dtc.DTCount
		,	hmic.DTArea = dtc.DTArea
		,	hmic.DensityThinningRatio = (dtc.DTCount/dtc.DTArea)
		FROM #hmic hmic
		INNER JOIN #dtcount dtc
			ON hmic.AppointmentGUID = dtc.AppointmentGUID
					AND hmic.ComparisonSet = dtc.ComparisonSet


		UPDATE hmic
		SET hmic.WCMarkerWidth = wcd.WCMarkerWidth
		,	hmic.WTMarkerWidth = wcd.WTMarkerWidth
		FROM #hmic hmic
		INNER JOIN #wcdistance wcd
			ON hmic.AppointmentGUID = wcd.AppointmentGUID
				AND hmic.ComparisonSet = wcd.ComparisonSet




	SELECT AppointmentGUID
			,	ComparisonSet
			,	DCTerminals
			,	DCArea
			,	DensityControlRatio
			,	DTTerminals
			,	DTArea
			,	DensityThinningRatio
			,	CAST(WCMarkerWidth AS DECIMAL(18,2)) AS 'WCMarkerWidth'
			,	CAST(WTMarkerWidth AS DECIMAL(18,2)) AS 'WTMarkerWidth'
			,	ROUND(HMIC,0,0) AS 'HMIC'
			,	ROUND(HMIT,0,0) AS 'HMIT'
			,	CASE WHEN HMIC < 15 THEN 'severe hair loss'
					WHEN HMIC BETWEEN 15 AND 30 THEN 'mild hair loss'
					WHEN HMIC BETWEEN 31 AND 50 THEN 'medium hair loss'
					WHEN HMIC BETWEEN 51 AND 70 THEN 'minimal hair loss'
					WHEN HMIC > 70 THEN 'no hair loss' END AS 'HMIC_HairLoss'
			,	CASE WHEN HMIT < 15 THEN 'severe hair loss'
					WHEN HMIT BETWEEN 15 AND 30 THEN 'mild hair loss'
					WHEN HMIT BETWEEN 31 AND 50 THEN 'medium hair loss'
					WHEN HMIT BETWEEN 51 AND 70 THEN 'minimal hair loss'
					WHEN HMIT > 70 THEN 'no hair loss' END AS 'HMIT_HairLoss'
			,	CASE WHEN WCMarkerWidth < 61 THEN 'very fine hair'
					WHEN WCMarkerWidth BETWEEN 61 AND 65 THEN 'fine hair'
					WHEN WCMarkerWidth BETWEEN 66 AND 70 THEN 'medium-fine hair'
					WHEN WCMarkerWidth BETWEEN 71 AND 75 THEN 'medium hair'
					WHEN WCMarkerWidth BETWEEN 76 AND 80 THEN 'medium-coarse hair'
					WHEN WCMarkerWidth > 80 THEN 'coarse hair' END AS 'HMIC_Thickness'
			,	CASE WHEN WTMarkerWidth < 61 THEN 'very fine hair'
					WHEN WTMarkerWidth BETWEEN 61 AND 65 THEN 'fine hair'
					WHEN WTMarkerWidth BETWEEN 66 AND 70 THEN 'medium-fine hair'
					WHEN WTMarkerWidth BETWEEN 71 AND 75 THEN 'medium hair'
					WHEN WTMarkerWidth BETWEEN 76 AND 80 THEN 'medium-coarse hair'
					WHEN WTMarkerWidth > 80 THEN 'coarse hair' END AS 'HMIT_Thickness'
	FROM #hmic

END
