/* CreateDate: 10/07/2014 10:38:25.980 , ModifyDate: 01/02/2015 15:58:46.303 */
GO
/*===============================================================================================
 Procedure Name:				[rptTVComparativeWidthGraph]
 Procedure Description:			This stored procedure provides the data for the Width grids.
 Created By:					Rachelen Hut
 Date Created:					09/22/2014`
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView Comparative report
================================================================================================

================================================================================================
Sample Execution:

EXEC [rptTVComparativeWidthGraph] 'E261C739-1978-4E23-8941-6059F3B56A6A', 'E9E5DE78-AFE1-4883-9B22-262B8D5638AA','M'

================================================================================================*/

CREATE PROCEDURE [dbo].[xxx_rptTVComparativeWidthGraph]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN
	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT

	CREATE TABLE #widthgraph(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	AverageWidth DECIMAL(18,5)
		,	ComparisonSet INT
		,	ScalpAreaID INT
		,	PhotoTypeID INT
	)


	CREATE TABLE #widthgraph2(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	AverageWidth DECIMAL(18,5)
		,	ComparisonSet INT
		,	ScalpAreaID INT
		,	PhotoTypeID INT
	)



	CREATE TABLE #compwidthgraph(
			AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	AverageWidth_Control DECIMAL(18,2)
			,	AverageWidth_Thinning DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT
			,	PhotoTypeID INT
			)


	CREATE TABLE #compwidthgraph2(
			AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	AverageWidth_Control DECIMAL(18,2)
			,	AverageWidth_Thinning DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT
			,	PhotoTypeID INT
			)

/********************* Comparative 1 *********************************/


	INSERT INTO #widthgraph

	SELECT 	ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.AverageWidth
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID
	FROM   datAppointmentPhoto ap
	INNER JOIN dbo.datAppointment appt
		ON ap.AppointmentGUID = appt.AppointmentGUID
	WHERE  ap.AppointmentGUID = @AppointmentGUID
		AND ap.PhotoTypeID IN (5)  -- 5 is Width
	GROUP BY ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.AverageWidth
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID


	--SELECT * FROM #widthgraph

	INSERT INTO #compwidthgraph

	SELECT AppointmentGUID
		,	AppointmentDate
		,	NULL AS AverageWidth_Control
		,	NULL AS AverageWidth_Thinning
		,	ComparisonSet
		,	ScalpAreaID
		,	#widthgraph.PhotoTypeID
	FROM   #widthgraph
	GROUP BY  AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
		,	ScalpAreaID
		,	#widthgraph.PhotoTypeID

	--SELECT * FROM #compwidthgraph

	UPDATE comp
	SET comp.AverageWidth_Control = w.AverageWidth
	FROM #compwidthgraph comp
	INNER JOIN #widthgraph w
		ON w.AppointmentGUID = comp.AppointmentGUID
	WHERE w.ComparisonSet = comp.ComparisonSet
	AND w.ScalpAreaID = 1
	AND w.PhotoTypeID = comp.PhotoTypeID

	UPDATE comp
	SET comp.AverageWidth_Thinning = w.AverageWidth
	FROM #compwidthgraph comp
	INNER JOIN #widthgraph w
		ON w.AppointmentGUID = comp.AppointmentGUID
	WHERE w.ComparisonSet = comp.ComparisonSet
	AND w.ScalpAreaID = 2
	AND w.PhotoTypeID = comp.PhotoTypeID

	--SELECT * FROM #compwidthgraph

	/********************* Comparative 2 *********************************/

	INSERT INTO #widthgraph2

	SELECT 	ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.AverageWidth
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID
	FROM   datAppointmentPhoto ap
	INNER JOIN dbo.datAppointment appt
		ON ap.AppointmentGUID = appt.AppointmentGUID
	WHERE  ap.AppointmentGUID = @AppointmentGUID2
		AND ap.PhotoTypeID IN (5)  -- 5 is Width
	GROUP BY ap.AppointmentGUID
	,	appt.AppointmentDate
	,	ap.AverageWidth
	,	ap.ComparisonSet
	,	ap.ScalpAreaID
	,	ap.PhotoTypeID


	--SELECT * FROM #widthgraph2

	INSERT INTO #compwidthgraph2

	SELECT AppointmentGUID
		,	AppointmentDate
		,	NULL AS AverageWidth_Control
		,	NULL AS AverageWidth_Thinning
		,	ComparisonSet
		,	ScalpAreaID
		,	PhotoTypeID
	FROM   #widthgraph2
	GROUP BY  AppointmentGUID
		,	AppointmentDate
		,	ComparisonSet
		,	ScalpAreaID
		,	PhotoTypeID

	--SELECT * FROM #compwidthgraph2

	UPDATE comp2
	SET comp2.AverageWidth_Control = w2.AverageWidth
	FROM #compwidthgraph2 comp2
	INNER JOIN #widthgraph2 w2
		ON w2.AppointmentGUID = comp2.AppointmentGUID
	WHERE w2.ComparisonSet = comp2.ComparisonSet
	AND w2.ScalpAreaID = 1
	AND w2.PhotoTypeID = comp2.PhotoTypeID

	UPDATE comp2
	SET comp2.AverageWidth_Thinning = w2.AverageWidth
	FROM #compwidthgraph2 comp2
	INNER JOIN #widthgraph2 w2
		ON w2.AppointmentGUID = comp2.AppointmentGUID
	WHERE w2.ComparisonSet = comp2.ComparisonSet
	AND w2.ScalpAreaID = 2
	AND w2.PhotoTypeID = comp2.PhotoTypeID

	--SELECT * FROM #compwidthgraph2

		/************************** Final Select ******************************************/

	SELECT AppointmentGUID
	,	AppointmentDate
	,	AverageWidth_Control
	,	AverageWidth_Thinning
	,	ComparisonSet
	,	CASE WHEN AverageWidth_Control = 0  THEN 0 ELSE (AverageWidth_Thinning/AverageWidth_Control)*100 END AS 'AverageWidth_Diff'
	FROM

		(SELECT AppointmentGUID
		, AppointmentDate
		, AverageWidth_Control
		, AverageWidth_Thinning
		, ComparisonSet
		FROM #compwidthgraph
		UNION
		SELECT AppointmentGUID
		, AppointmentDate
		, AverageWidth_Control
		, AverageWidth_Thinning
		, ComparisonSet
		FROM #compwidthgraph2)q

	GROUP BY AppointmentGUID
	,	AppointmentDate
	,	AverageWidth_Control
	,	AverageWidth_Thinning
	,	ComparisonSet


END
GO
