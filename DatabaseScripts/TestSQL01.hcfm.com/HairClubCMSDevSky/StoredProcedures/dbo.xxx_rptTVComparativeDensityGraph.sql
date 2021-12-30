/* CreateDate: 10/09/2014 17:01:26.633 , ModifyDate: 01/02/2015 15:58:27.570 */
GO
/*===============================================================================================
 Procedure Name:				[rptTVComparativeDensityGraph]
 Procedure Description:			This stored procedure provides the data for the Density grids.
 Created By:					Rachelen Hut
 Date Created:					09/22/2014`
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView Comparative report
================================================================================================

================================================================================================
Sample Execution:

EXEC [rptTVComparativeDensityGraph] 'E261C739-1978-4E23-8941-6059F3B56A6A', 'E9E5DE78-AFE1-4883-9B22-262B8D5638AA','M'

================================================================================================*/

CREATE PROCEDURE [dbo].[xxx_rptTVComparativeDensityGraph]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN
	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT

	CREATE TABLE #Densitygraph(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	DensityInMMSquared DECIMAL(18,5)
		,	ComparisonSet INT
		,	ScalpAreaID INT
		,	PhotoTypeID INT
	)


	CREATE TABLE #Densitygraph2(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	DensityInMMSquared DECIMAL(18,5)
		,	ComparisonSet INT
		,	ScalpAreaID INT
		,	PhotoTypeID INT
	)



	CREATE TABLE #compDensitygraph(
			AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	AverageDensity_Control DECIMAL(18,2)
			,	AverageDensity_Thinning DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT
			,	PhotoTypeID INT
			)


	CREATE TABLE #compDensitygraph2(
			AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	AverageDensity_Control DECIMAL(18,2)
			,	AverageDensity_Thinning DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT
			,	PhotoTypeID INT
			)

/********************* Comparative 1 *********************************/


	INSERT INTO #Densitygraph

	SELECT 	ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.DensityInMMSquared
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID
	FROM   datAppointmentPhoto ap
	INNER JOIN dbo.datAppointment appt
		ON ap.AppointmentGUID = appt.AppointmentGUID
	WHERE  ap.AppointmentGUID = @AppointmentGUID
		AND ap.PhotoTypeID IN (4)  -- 4 is Density
		AND ap.ComparisonSet = 1  --Added 11/11/2014 RH per Andre
	GROUP BY ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.DensityInMMSquared
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID


	--SELECT * FROM #Densitygraph

	INSERT INTO #compDensitygraph

	SELECT AppointmentGUID
		,	AppointmentDate
		,	NULL AS AverageDensity_Control
		,	NULL AS AverageDensity_Thinning
		,	ComparisonSet
		,	ScalpAreaID
		,	PhotoTypeID
	FROM   #Densitygraph
	GROUP BY  AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
		,	ScalpAreaID
		,	PhotoTypeID

	--SELECT * FROM #compDensitygraph

	UPDATE comp
	SET comp.AverageDensity_Control = w.DensityInMMSquared
	FROM #compDensitygraph comp
	INNER JOIN #Densitygraph w
		ON w.AppointmentGUID = comp.AppointmentGUID
	WHERE w.ComparisonSet = comp.ComparisonSet
	AND w.ScalpAreaID = 1
	AND w.PhotoTypeID = comp.PhotoTypeID

	UPDATE comp
	SET comp.AverageDensity_Thinning = w.DensityInMMSquared
	FROM #compDensitygraph comp
	INNER JOIN #Densitygraph w
		ON w.AppointmentGUID = comp.AppointmentGUID
	WHERE w.ComparisonSet = comp.ComparisonSet
	AND w.ScalpAreaID = 2
	AND w.PhotoTypeID = comp.PhotoTypeID

	--SELECT * FROM #compDensitygraph

	/********************* Comparative 2 *********************************/

	INSERT INTO #Densitygraph2

	SELECT 	ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.DensityInMMSquared
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID
	FROM   datAppointmentPhoto ap
	INNER JOIN dbo.datAppointment appt
		ON ap.AppointmentGUID = appt.AppointmentGUID
	WHERE  ap.AppointmentGUID = @AppointmentGUID2
		AND ap.PhotoTypeID IN (5)  -- 5 is Density
		AND ap.ComparisonSet = 1  --Added 11/11/2014 RH per Andre
	GROUP BY ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.DensityInMMSquared
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID


	--SELECT * FROM #Densitygraph2

	INSERT INTO #compDensitygraph2

	SELECT AppointmentGUID
		,	AppointmentDate
		,	NULL AS AverageDensity_Control
		,	NULL AS AverageDensity_Thinning
		,	ComparisonSet
		,	ScalpAreaID
		,	PhotoTypeID
	FROM   #Densitygraph2
	GROUP BY  AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
		,	ScalpAreaID
		,	PhotoTypeID

	--SELECT * FROM #compDensitygraph2

	UPDATE comp2
	SET comp2.AverageDensity_Control = w2.DensityInMMSquared
	FROM #compDensitygraph2 comp2
	INNER JOIN #Densitygraph2 w2
		ON w2.AppointmentGUID = comp2.AppointmentGUID
	WHERE w2.ComparisonSet = comp2.ComparisonSet
	AND w2.ScalpAreaID = 1
	AND w2.PhotoTypeID = comp2.PhotoTypeID

	UPDATE comp2
	SET comp2.AverageDensity_Thinning = w2.DensityInMMSquared
	FROM #compDensitygraph2 comp2
	INNER JOIN #Densitygraph2 w2
		ON w2.AppointmentGUID = comp2.AppointmentGUID
	WHERE w2.ComparisonSet = comp2.ComparisonSet
	AND w2.ScalpAreaID = 2
	AND w2.PhotoTypeID = comp2.PhotoTypeID

	--SELECT * FROM #compDensitygraph2

		/************************** Final Select ******************************************/

	SELECT AppointmentGUID
	,	AppointmentDate
	,	AverageDensity_Control
	,	AverageDensity_Thinning
	,	ComparisonSet
	,	CASE WHEN AverageDensity_Control = 0  THEN 0 ELSE (AverageDensity_Thinning/AverageDensity_Control)*100 END AS 'AverageDensity_Diff'
	FROM

		(SELECT AppointmentGUID
		, AppointmentDate
		, AverageDensity_Control
		, AverageDensity_Thinning
		, ComparisonSet
		FROM #compDensitygraph
		UNION
		SELECT AppointmentGUID
		, AppointmentDate
		, AverageDensity_Control
		, AverageDensity_Thinning
		, ComparisonSet
		FROM #compDensitygraph2)q

	GROUP BY AppointmentGUID
	,	AppointmentDate
	,	AverageDensity_Control
	,	AverageDensity_Thinning
	,	ComparisonSet


END
GO
