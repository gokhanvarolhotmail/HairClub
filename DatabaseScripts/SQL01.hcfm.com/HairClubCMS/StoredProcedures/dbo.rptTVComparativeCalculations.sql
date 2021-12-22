/*===============================================================================================
 Procedure Name:				rptTVComparativeCalculations
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
12/31/2014	RH	Changed number of appointments allowed to 12 (from 10)
07/18/2016	RH	(#122874) Added code for Localized Lookups using resource keys
================================================================================================
SAMPLE EXECUTION:

EXEC rptTVComparativeCalculations '52EE6482-A768-410E-897E-43A5FF4F17C8','F7A7710A-B537-4C04-BF31-D0A6612C54E5' ,'F'


================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVComparativeCalculations]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

/*************** Create temp tables ***************************************************************/

	CREATE TABLE #appt(ApptID INT IDENTITY(1,1)
		,	AppointmentDate DATETIME
		,	AppointmentGUID UNIQUEIDENTIFIER
		,	ClientGUID UNIQUEIDENTIFIER
		,	ClientIdentifier INT)

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

	CREATE TABLE #dccount(ID INT IDENTITY(1,1), AppointmentGUID UNIQUEIDENTIFIER, ComparisonSet INT, DCArea FLOAT, DCCount FLOAT)

	CREATE TABLE #dtcount(AppointmentGUID UNIQUEIDENTIFIER,  ComparisonSet INT, DTArea FLOAT, DTCount FLOAT)

	CREATE TABLE #wcdistance(AppointmentGUID UNIQUEIDENTIFIER,  ComparisonSet INT, WCMarkerWidth FLOAT, WTMarkerWidth FLOAT)

	CREATE TABLE #hmic(AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	ComparisonSet INT
		,	ClientGUID UNIQUEIDENTIFIER
		,	ClientIdentifier INT
		,	DCTerminals INT
		,	DCArea FLOAT
		,	DensityControlRatio FLOAT
		,	DTTerminals INT
		,	DTArea FLOAT
		,	DensityThinningRatio FLOAT
		,	WCMarkerWidth DECIMAL(18,2)
		,	WTMarkerWidth DECIMAL(18,2)
		,	HMIC FLOAT
		,	HMIT FLOAT
		,	CreateDate DATETIME
		,	CreateUser NVARCHAR(25)
		,	LastUpdate DATETIME
		,	LastUpdateUser NVARCHAR(25)
		,	UpdateStamp TIMESTAMP)

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


	INSERT INTO #appt
	SELECT TOP 12 appt.AppointmentDate   --Limit the appointments to 12 for the graphs
	,	dap.AppointmentGUID
	,	appt.ClientGUID
	,	clt.ClientIdentifier
	FROM datAppointmentPhoto dap (NOLOCK)
		INNER JOIN dbo.datAppointment appt
			ON dap.AppointmentGUID = appt.AppointmentGUID
		INNER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
	WHERE PhotoTypeID IN (4,5) -- 4 = Density, 5 = Width
		AND appt.ClientGUID IN(SELECT ClientGUID FROM datAppointment WHERE AppointmentGUID = @AppointmentGUID)
	GROUP BY appt.AppointmentDate
	,	dap.AppointmentGUID
	,	appt.ClientGUID
	,	clt.ClientIdentifier
	ORDER BY appt.AppointmentDate DESC


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
					INNER JOIN datAppointmentPhotoMarkup dapm (NOLOCK)
						ON dap.AppointmentPhotoID = dapm.AppointmentPhotoID
					INNER JOIN dbo.lkpPhotoType lpt (NOLOCK)
						ON dap.PhotoTypeID = lpt.PhotoTypeID
					INNER JOIN dbo.lkpScalpArea lsa (NOLOCK)
						ON dap.ScalpAreaID = lsa.ScalpAreaID
					INNER JOIN dbo.lkpPhotoLens lpl (NOLOCK)
						ON dap.PhotoLensID = lpl.PhotoLensID
			WHERE   AppointmentGUID IN(SELECT AppointmentGUID FROM #appt)
			AND dap.ComparisonSet = 1
			)q

	--SELECT 'calculations' AS tablename,* FROM #calculations

	 -- DensityControl
	INSERT INTO #dccount
	SELECT 	 AppointmentGUID
	,	ComparisonSet
	,	EstimatedArea AS 'DCArea'
	,	COUNT(PhotoTypeID) AS DCCount
	FROM #calculations
	WHERE PhotoTypeID = 4
	AND ScalpAreaID = 1
	AND ComparisonSet = 1
	GROUP BY  EstimatedArea
	,	AppointmentGUID
	,	ComparisonSet

	--SELECT 'dccount' AS tablename, * FROM #dccount


	-- Density Thinning
	INSERT INTO #dtcount
	SELECT 	 AppointmentGUID
		,	ComparisonSet
		,	EstimatedArea AS 'DTArea'
		,	COUNT(PhotoTypeID) AS DTCount
	FROM #calculations
	WHERE PhotoTypeID = 4
	AND ScalpAreaID = 2
	AND ComparisonSet = 1
	GROUP BY  EstimatedArea
		,	AppointmentGUID
		,	ComparisonSet

	--SELECT 'dtcount' AS tablename, * FROM #dtcount


	/*******************************************************************
	This section uses the BARTH formula for finding the average width.

	********************************************************************/
	-- AVG Width

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
	AND ComparisonSet = 1


	--SELECT 'markers' AS TABLENAME, * FROM #markers


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

		--SELECT 'MarkerWidths' AS TABLENAME, * FROM #markerwidth

	/**************************** Loop throgh AppointmentGUIDS ******************************/

	DECLARE @ID INT
	SELECT @ID = MIN(ID) FROM #dccount

	WHILE @ID IS NOT NULL
	BEGIN

			DECLARE @HMIC1 FLOAT
			DECLARE @HMIT1 FLOAT

			DECLARE @WCMarkerWidth1 FLOAT
			DECLARE @WTMarkerWidth1 FLOAT

			SET @WCMarkerWidth1 = (SELECT TOP 1 AvgWidth
									FROM #markerwidth mw
									INNER JOIN #dccount dcc
										ON mw.AppointmentGUID = dcc.AppointmentGUID
									WHERE PhotoTypeID = 5 AND ScalpAreaID = 1
									AND dcc.ID = @ID)
			SET @WTMarkerWidth1 = (SELECT TOP 1 AvgWidth
									FROM #markerwidth mw
									INNER JOIN #dccount dcc
										ON mw.AppointmentGUID = dcc.AppointmentGUID
									WHERE PhotoTypeID = 5 AND ScalpAreaID = 2
									AND dcc.ID = @ID )

			PRINT @WCMarkerWidth1
			PRINT @WTMarkerWidth1

			--Width Control and Thinning MarkerWidth
			INSERT INTO #wcdistance
			SELECT TOP 1 c.AppointmentGUID
				,	c.ComparisonSet
				,	@WCMarkerWidth1 AS 'WCMarkerWidth'
				,	@WTMarkerWidth1 AS 'WTMarkerWidth'
			FROM #calculations c
			INNER JOIN #dccount dcc
				ON c.AppointmentGUID = dcc.AppointmentGUID
			WHERE dcc.ID = @ID


					/*******************************************************************
					This section uses the BARTH formula for finding the hair mass index.

					-------------HMI = (PI() x SQUARE(width/2) x density/0.01) x 100

					********************************************************************/

			SET @HMIC1 = (SELECT (PI()*SQUARE(@WCMarkerWidth1/2)*(dcc.DCCount/dcc.DCArea)/0.01)*.0001
							FROM #dccount dcc
							WHERE ID = @ID)

			SET @HMIT1 = (SELECT (PI()*SQUARE(@WTMarkerWidth1/2)*(dtc.DTCount/dtc.DTArea)/0.01)*.0001
							FROM #dtcount dtc
							INNER JOIN #dccount dcc
								ON dtc.AppointmentGUID = dcc.AppointmentGUID
							WHERE dcc.ID = @ID)


			--HMI Control and Thinning
			INSERT INTO #hmic(AppointmentGUID
				,	AppointmentDate
				,	ComparisonSet
				,	ClientGUID
				,	ClientIdentifier
				,	DCTerminals
				,	DCArea
				,	DensityControlRatio
				,	DTTerminals
				,	DTArea
				,	DensityThinningRatio
				,	WCMarkerWidth
				,	WTMarkerWidth
				,	HMIC
				,	HMIT)
			SELECT TOP 1 c.AppointmentGUID
				,	appt.AppointmentDate
				,	c.ComparisonSet
				,	appt.ClientGUID
				,	appt.ClientIdentifier
				,	NULL AS DCTerminals
				,	NULL AS DCArea
				,	NULL AS DensityControlRatio
				,	NULL AS DTTerminals
				,	NULL AS DTArea
				,	NULL AS DensityThinningRatio
				,	NULL AS WCMarkerWidth
				,	NULL AS WTMarkerWidth
				,	@HMIC1 AS 'HMIC'
				,	@HMIT1 AS 'HMIT'
			FROM #calculations c
			INNER JOIN #dccount dcc
				ON c.AppointmentGUID = dcc.AppointmentGUID
			INNER JOIN #appt appt
				ON c.AppointmentGUID = appt.AppointmentGUID
			WHERE dcc.ID = @ID


		/************************Then at the end of the loop *****************/
		SELECT @ID = MIN(ID)
			FROM #dccount
			WHERE ID > @ID

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



	UPDATE hmic
	SET hmic.DTTerminals = dtc.DTCount
	,	hmic.DTArea = dtc.DTArea
	,	hmic.DensityThinningRatio = (dtc.DTCount/dtc.DTArea)
	FROM #hmic hmic
	INNER JOIN #dtcount dtc
		ON hmic.AppointmentGUID = dtc.AppointmentGUID



	UPDATE hmic
	SET hmic.WCMarkerWidth = wcd.WCMarkerWidth
	,	hmic.WTMarkerWidth = wcd.WTMarkerWidth
	FROM #hmic hmic
	INNER JOIN #wcdistance wcd
		ON hmic.AppointmentGUID = wcd.AppointmentGUID


	SELECT AppointmentGUID
			,	AppointmentDate
			,	ComparisonSet
			,	ClientGUID
			,	ClientIdentifier
			,	DCTerminals
			,	DCArea
			,	DensityControlRatio
			,	DTTerminals
			,	DTArea
			,	DensityThinningRatio
			,	CAST(WCMarkerWidth AS DECIMAL(18,2)) AS 'WCMarkerWidth'
			,	CAST(WTMarkerWidth AS DECIMAL(18,2)) AS 'WTMarkerWidth'
			,	HMIC
			,	HMIT

	FROM #hmic




END
