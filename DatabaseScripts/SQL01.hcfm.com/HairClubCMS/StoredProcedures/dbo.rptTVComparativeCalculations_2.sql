/*===============================================================================================
 Procedure Name:				rptTVComparativeCalculations_2
 Procedure Description:			This stored procedure provides the data for the Density, Width and HMI grids in the Comparative Analysis report.
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
CHANGE HISTORY:
07/18/2016	RH	(#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC rptTVComparativeCalculations_2 '52EE6482-A768-410E-897E-43A5FF4F17C8','F7A7710A-B537-4C04-BF31-D0A6612C54E5' ,'F'


================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVComparativeCalculations_2]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

/***************************** Comparative ONE *******************************************************/

	CREATE TABLE #calculations(AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
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
			,	AppointmentDate DATETIME
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



		INSERT INTO #calculations
		        (AppointmentGUID
				,	AppointmentDate
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
		,	AppointmentDate
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
				,	appt.AppointmentDate
					,	dap.ComparisonSet
					,	dap.PhotoTypeID
					--,	lpt.PhotoTypeDescription
					,	lpt.DescriptionResourceKey AS 'PhotoTypeDescription'
					,	dap.ScalpAreaID
					--,	lsa.ScalpAreaDescription
					,	lsa.DescriptionResourceKey AS 'ScalpAreaDescription'
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
				INNER JOIN dbo.datAppointment appt
					ON dap.AppointmentGUID = appt.AppointmentGUID
						INNER JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
							ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
						INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
							ON dap.PhotoTypeID = lpt.PhotoTypeID
						INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
							ON dap.ScalpAreaID = lsa.ScalpAreaID
						INNER JOIN dbo.lkpPhotoLens lpl (NOLOCK)
							ON dap.PhotoLensID = lpl.PhotoLensID
				WHERE   dap.AppointmentGUID = @AppointmentGUID
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

		--SELECT * FROM #markers

		INSERT INTO #widths
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	MarkerWidth = (SELECT ABS(SQRT((Width * Width) + (Height * Height))))
		FROM #markers

		--SELECT 'Widths' AS TABLENAME, * FROM #widths

		/**********AverageWidth = Sum(MarkerWidths) / PhotoMarkups.count ******************/

		INSERT INTO #markerwidth
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	SUM(MarkerWidth)/COUNT(ScalpAreaID) AS AvgWidth
		FROM #widths
		GROUP BY AppointmentGUID
			,	PhotoTypeID
			,	ScalpAreaID
			,	ComparisonSet

			/*********************** ComparisonSet = 1 *************************************/
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
			,	AppointmentDate
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	@HMIC1 AS 'HMIC'
				,	@HMIT1 AS 'HMIT'
			FROM #calculations
			WHERE ComparisonSet = 1


			/*********************** ComparisonSet = 2 *************************************/
			/*
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
			,	AppointmentDate
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	@HMIC2 AS 'HMIC'
				,	@HMIT2 AS 'HMIT'
			FROM #calculations
			WHERE ComparisonSet = 2

			/*********************** ComparisonSet = 3 *************************************/

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
			,	AppointmentDate
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	@HMIC3 AS 'HMIC'
				,	@HMIT3 AS 'HMIT'
			FROM #calculations
			WHERE ComparisonSet = 3




	--SELECT 'hmic' AS Tablename, * FROM #hmic

	*/

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




/****************************************** Comparative TWO ********************************************/

	CREATE TABLE #calculations2(AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
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

	CREATE TABLE #dccount2(AppointmentGUID UNIQUEIDENTIFIER, ComparisonSet INT, DCArea FLOAT, DCCount FLOAT)

	CREATE TABLE #dtcount2(AppointmentGUID UNIQUEIDENTIFIER,  ComparisonSet INT, DTArea FLOAT, DTCount FLOAT)

	CREATE TABLE #wcdistance2(AppointmentGUID UNIQUEIDENTIFIER,  ComparisonSet INT, WCMarkerWidth FLOAT, WTMarkerWidth FLOAT)

	CREATE TABLE #hmic2(AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATETIME
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

	CREATE TABLE #markers2(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	ScalpAreaID INT
			,	fovWidth FLOAT
			,	fovHeight FLOAT
			,	run FLOAT
			,	rise FLOAT
			,	Width FLOAT
			,	Height FLOAT)

	CREATE TABLE #widths2(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	ScalpAreaID INT
			,	MarkerWidth FLOAT)

	CREATE TABLE #markerwidth2(AppointmentGUID UNIQUEIDENTIFIER
			,	ComparisonSet INT
			,	PhotoTypeID INT
			,	ScalpAreaID INT
			,	AvgWidth FLOAT)



		INSERT INTO #calculations2
		        (AppointmentGUID
				,	AppointmentDate
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
		,	AppointmentDate
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
				,	AppointmentDate
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
				INNER JOIN dbo.datAppointment appt
				ON dap.AppointmentGUID = appt.AppointmentGUID
						INNER JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
							ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
						INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
							ON dap.PhotoTypeID = lpt.PhotoTypeID
						INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
							ON dap.ScalpAreaID = lsa.ScalpAreaID
						INNER JOIN dbo.lkpPhotoLens lpl (NOLOCK)
							ON dap.PhotoLensID = lpl.PhotoLensID
				WHERE   dap.AppointmentGUID = @AppointmentGUID2
				)q

		--SELECT * FROM #calculations2

		 --DensityControl
		INSERT INTO #dccount2
		SELECT 	 AppointmentGUID
		,	ComparisonSet
		,	EstimatedArea AS 'DCArea'
		,	COUNT(PhotoTypeID) AS DCCount
		FROM #calculations2
		WHERE PhotoTypeID = 4
		AND ScalpAreaID = 1
		GROUP BY  EstimatedArea
		,	AppointmentGUID
		,	ComparisonSet

		--SELECT 'dccount' AS tablename, * FROM #dccount2


		--,	Density Thinning
		INSERT INTO #dtcount2
		SELECT 	 AppointmentGUID
		,	ComparisonSet
		,	EstimatedArea AS 'DTArea'
		,	COUNT(PhotoTypeID) AS DTCount
		FROM #calculations2
		WHERE PhotoTypeID = 4
		AND ScalpAreaID = 2
		GROUP BY  EstimatedArea
		,	AppointmentGUID
		,	ComparisonSet

		--SELECT 'dtcount' AS tablename, * FROM #dtcount2


		/*******************************************************************
		This section uses the BARTH formula for finding the average width.

		********************************************************************/
		--AVG Width


		INSERT INTO #markers2
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
		FROM #calculations2
		WHERE  PhotoTypeID = 5 --Width

		--SELECT * FROM #markers2

		INSERT INTO #widths2
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	MarkerWidth = (SELECT ABS(SQRT((Width * Width) + (Height * Height))))
		FROM #markers2

		--SELECT 'Widths' AS TABLENAME, * FROM #widths2

		/**********AverageWidth = Sum(MarkerWidths) / PhotoMarkups.count ******************/

		INSERT INTO #markerwidth2
		SELECT AppointmentGUID
			,	ComparisonSet
			,	PhotoTypeID
			,	ScalpAreaID
			,	SUM(MarkerWidth)/COUNT(ScalpAreaID) AS AvgWidth
		FROM #widths2
		GROUP BY AppointmentGUID
			,	PhotoTypeID
			,	ScalpAreaID
			,	ComparisonSet

			/*********************** ComparisonSet = 1 *************************************/
			DECLARE @HMIC1_2 FLOAT
			DECLARE @HMIT1_2 FLOAT

			DECLARE @WCMarkerWidth1_2 FLOAT
			DECLARE @WTMarkerWidth1_2 FLOAT

			SET @WCMarkerWidth1_2 = (SELECT TOP 1 AvgWidth
									FROM #markerwidth2
									WHERE PhotoTypeID = 5 AND ScalpAreaID = 1 AND  ComparisonSet = 1)
			SET @WTMarkerWidth1_2 = (SELECT TOP 1 AvgWidth
									FROM #markerwidth2
									WHERE PhotoTypeID = 5 AND ScalpAreaID = 2 AND  ComparisonSet = 1)

			PRINT @WCMarkerWidth1_2
			PRINT @WTMarkerWidth1_2

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance2
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@WCMarkerWidth1_2 AS 'WCMarkerWidth'
				,	@WTMarkerWidth1_2 AS 'WTMarkerWidth'
			FROM #calculations2
			WHERE ComparisonSet = 1


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC1_2 = (SELECT (PI()*SQUARE(@WCMarkerWidth1_2/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount2 dcc
							WHERE ComparisonSet = 1)

			SET @HMIT1_2 = (SELECT (PI()*SQUARE(@WTMarkerWidth1_2/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount2 dtc
							WHERE ComparisonSet = 1)


			--HMI Control and Thinning
			INSERT INTO #hmic2(AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	@HMIC1_2 AS 'HMIC'
				,	@HMIT1_2 AS 'HMIT'
			FROM #calculations2
			WHERE ComparisonSet = 1

			/*********************** ComparisonSet = 2 *************************************/
			/*

			DECLARE @HMIC2_2 FLOAT
			DECLARE @HMIT2_2 FLOAT

			DECLARE @WCMarkerWidth2_2 FLOAT
			DECLARE @WTMarkerWidth2_2 FLOAT

			SET @WCMarkerWidth2_2 = (SELECT AvgWidth
										FROM #markerwidth2
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 1 AND ComparisonSet = 2)
			SET @WTMarkerWidth2_2 = (SELECT AvgWidth
										FROM #markerwidth2
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 2 AND ComparisonSet = 2)

			PRINT @WCMarkerWidth2_2
			PRINT @WTMarkerWidth2_2

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance2
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@WCMarkerWidth2_2 AS 'WCMarkerWidth'
				,	@WTMarkerWidth2_2 AS 'WTMarkerWidth'
			FROM #calculations2
			WHERE ComparisonSet = 2


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC2_2 = (SELECT (PI()*SQUARE(@WCMarkerWidth2_2/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount2 dcc
							WHERE ComparisonSet = 2)

			SET @HMIT2_2 = (SELECT (PI()*SQUARE(@WTMarkerWidth2_2/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount2 dtc
							WHERE ComparisonSet = 2)


			--HMI Control and Thinning
			INSERT INTO #hmic2(AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	@HMIC2_2 AS 'HMIC'
				,	@HMIT2_2 AS 'HMIT'
			FROM #calculations2
			WHERE ComparisonSet = 2


		/*********************** ComparisonSet = 3 *************************************/

			DECLARE @HMIC3_2 FLOAT
			DECLARE @HMIT3_2 FLOAT

			DECLARE @WCMarkerWidth3_2 FLOAT
			DECLARE @WTMarkerWidth3_2 FLOAT

			SET @WCMarkerWidth3_2 = (SELECT AvgWidth
										FROM #markerwidth2
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 1 AND ComparisonSet = 3)
			SET @WTMarkerWidth3_2 = (SELECT AvgWidth
										FROM #markerwidth2
										WHERE PhotoTypeID = 5 AND ScalpAreaID = 2 AND ComparisonSet = 3)

			PRINT @WCMarkerWidth3_2
			PRINT @WTMarkerWidth3_2

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance2
			SELECT TOP 1 AppointmentGUID
				,	ComparisonSet
				,	@WCMarkerWidth3_2 AS 'WCMarkerWidth'
				,	@WTMarkerWidth3_2 AS 'WTMarkerWidth'
			FROM #calculations2
			WHERE ComparisonSet = 3


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC3_2 = (SELECT (PI()*SQUARE(@WCMarkerWidth3_2/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount2 dcc
							WHERE ComparisonSet = 3)

			SET @HMIT3_2 = (SELECT (PI()*SQUARE(@WTMarkerWidth3_2/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount2 dtc
							WHERE ComparisonSet = 3)


			--HMI Control and Thinning
			INSERT INTO #hmic2(AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	HMIC
				,	HMIT)
			SELECT TOP 1 AppointmentGUID
			,	AppointmentDate
				,	ComparisonSet
				,	@HMIC3_2 AS 'HMIC'
				,	@HMIT3_2 AS 'HMIT'
			FROM #calculations2
			WHERE ComparisonSet = 3
		--END

		/************************Then at the end of the loop *****************/
		--SELECT @setID2 = MIN(ID)
		--	FROM #comparisonset2
		--	WHERE ID > @setID2

	--END

	--SELECT 'hmic' AS Tablename, * FROM #hmic2
	*/
		/******************Final updates ***********************************/


		UPDATE c2
		SET c2.DCTerminals = dcc.DCCount
		,	c2.DCArea = dcc.DCArea
		,	c2.DensityControlRatio = (dcc.DCCount/dcc.DCArea)
		FROM #hmic2 c2
		INNER JOIN #dccount2 dcc
			ON c2.AppointmentGUID = dcc.AppointmentGUID
					AND c2.ComparisonSet = dcc.ComparisonSet


		UPDATE c2
		SET c2.DTTerminals = dtc.DTCount
		,	c2.DTArea = dtc.DTArea
		,	c2.DensityThinningRatio = (dtc.DTCount/dtc.DTArea)
		FROM #hmic2 c2
		INNER JOIN #dtcount2 dtc
			ON c2.AppointmentGUID = dtc.AppointmentGUID
					AND c2.ComparisonSet = dtc.ComparisonSet


		UPDATE c2
		SET c2.WCMarkerWidth = wcd.WCMarkerWidth
		,	c2.WTMarkerWidth = wcd.WTMarkerWidth
		FROM #hmic2 c2
		INNER JOIN #wcdistance2 wcd
			ON c2.AppointmentGUID = wcd.AppointmentGUID
				AND c2.ComparisonSet = wcd.ComparisonSet




	/*************************** Final Select ***********************************************/

	SELECT a.AppointmentGUID
			,	a.AppointmentDate
			,	a.ComparisonSet
			,	a.DCTerminals
			,	a.DCArea
			,	a.DensityControlRatio
			,	a.DTTerminals
			,	a.DTArea
			,	a.DensityThinningRatio
			,	CAST(a.WCMarkerWidth AS DECIMAL(18,2)) AS 'WCMarkerWidth'
			,	CAST(a.WTMarkerWidth AS DECIMAL(18,2)) AS 'WTMarkerWidth'
			,	a.HMIC AS 'HMIC'
			,	a.HMIT AS 'HMIT'
			,	b.AppointmentGUID AS 'AppointmentGUID2'
			,	b.AppointmentDate AS 'AppointmentDate2'
			,	b.ComparisonSet  AS 'ComparisonSet2'
			,	b.DCTerminals  AS 'DCTerminals2'
			,	b.DCArea  AS 'DCArea2'
			,	b.DensityControlRatio  AS 'DensityControlRatio2'
			,	b.DTTerminals AS 'DTTerminals2'
			,	b.DTArea AS 'DTArea2'
			,	b.DensityThinningRatio  AS 'DensityThinningRatio2'
			,	CAST(b.WCMarkerWidth AS DECIMAL(18,2)) AS 'WCMarkerWidth2'
			,	CAST(b.WTMarkerWidth AS DECIMAL(18,2)) AS 'WTMarkerWidth2'
			,	b.HMIC AS 'HMIC2'
			,	b.HMIT AS 'HMIT2'

	FROM #hmic a, #hmic2 b



END
