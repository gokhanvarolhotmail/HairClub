/* CreateDate: 10/07/2014 10:39:21.093 , ModifyDate: 11/11/2014 17:20:17.303 */
GO
/*===============================================================================================
 Procedure Name:				[rptTVComparativeWidthGraph_Control]
 Procedure Description:			This stored procedure provides the data for the Width grids.
 Created By:					Rachelen Hut
 Date Created:					09/22/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView Comparative report
================================================================================================
Change History:
09/29/2014	RH	Added AppointmentDate and AvgWidth in micrometers.
================================================================================================
Sample Execution:

EXEC [rptTVComparativeWidthGraph_Control] '2A29410B-45DB-48BA-8BCC-89B69C37AE7C', '29788281-DB63-4D3B-B9D6-F90782293A29'

================================================================================================*/

CREATE PROCEDURE [dbo].[xxx_rptTVComparativeWidthGraph_Control]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER

AS
BEGIN
	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT


	CREATE TABLE #widthgraph(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	DiameterInMicrons DECIMAL(18,2)
		,	AverageWidth DECIMAL(18,2)
		,	ComparisonSet INT
		,	ScalpAreaID INT
	)


	CREATE TABLE #widthgraph2(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	DiameterInMicrons DECIMAL(18,2)
		,	AverageWidth DECIMAL(18,2)
		,	ComparisonSet INT
		,	ScalpAreaID INT
	)



	CREATE TABLE #compwidthgraph(AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	DiameterInMicrons DECIMAL(18,2)
			,	AverageWidth DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT
			)


	CREATE TABLE #compwidthgraph2(AppointmentGUID2 UNIQUEIDENTIFIER
			,	AppointmentDate2 DATETIME
			,	DiameterInMicrons2 DECIMAL(18,2)
			,	AverageWidth2 DECIMAL(18,2)
			,	ComparisonSet2 INT
			,	ScalpAreaID2 INT
			)


	CREATE TABLE #final(
	Comparative INT
			,	AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	AverageWidth DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT)



/********************* Comparative 1 *********************************/

	INSERT INTO #widthgraph

	SELECT 	ap.AppointmentGUID
			,	appt.AppointmentDate
			,	ap.DiameterInMicrons
			,	ap.AverageWidth
			,	ap.ComparisonSet
			,	ap.ScalpAreaID
	 FROM   datAppointmentPhoto ap
		INNER JOIN dbo.datAppointment appt
			ON ap.AppointmentGUID = appt.AppointmentGUID
	 WHERE  ap.AppointmentGUID = @AppointmentGUID
			AND ap.PhotoTypeID IN (5)  -- 5 is Width
			AND ScalpAreaID = 1

	/*********** ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison(ID INT IDENTITY(1,1),	ComparisonSet INT)

	INSERT INTO #comparison(ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #widthgraph
	ORDER BY #widthgraph.ComparisonSet


	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID = (SELECT MIN(ID) FROM #comparison)
	PRINT @ID
	--Loop through each ComparisonSet
	WHILE @ID IS NOT NULL
	BEGIN

	SET @ComparisonSet = (SELECT ComparisonSet FROM #comparison WHERE ID = @ID)
	PRINT @ComparisonSet

	INSERT INTO #compwidthgraph

    SELECT dw.AppointmentGUID
				,	dw.AppointmentDate
				,	dw.DiameterInMicrons
				,	dw.AverageWidth
				,	dw.ComparisonSet
				,	dw.ScalpAreaID
			FROM   #widthgraph dw
				INNER JOIN #comparison c ON dw.ComparisonSet = c.ComparisonSet
			WHERE c.ID = @ID


		--Then at the end of the loop
		SET @ID = (SELECT MIN(ID)
				FROM #comparison
				WHERE ID > @ID)
	END

	/********************* Comparative 2 *********************************/

	INSERT INTO #widthgraph2

	SELECT		ap.AppointmentGUID
			,	appt.AppointmentDate
			,	ap.DiameterInMicrons
			,	ap.AverageWidth
			,	ap.ComparisonSet
			,	ap.ScalpAreaID
	 FROM   datAppointmentPhoto ap
		INNER JOIN dbo.datAppointment appt
			ON ap.AppointmentGUID = appt.AppointmentGUID
	 WHERE  ap.AppointmentGUID = @AppointmentGUID2
			AND ap.PhotoTypeID IN (5)  -- 5 is Width
			AND ScalpAreaID = 1



	/*********** Comparative 2: ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison2(ID2 INT IDENTITY(1,1),	ComparisonSet2 INT)

	INSERT INTO #comparison2(ComparisonSet2)
	SELECT DISTINCT ComparisonSet
	FROM #widthgraph2
	GROUP BY #widthgraph2.ComparisonSet
	ORDER BY #widthgraph2.ComparisonSet


	--Set the @ID Variable for first iteration for ComparisonSet2
	SET @ID2 = (SELECT MIN(ID2) FROM #comparison2)
	PRINT @ID2
	--Loop through each ComparisonSet2
	WHILE @ID2 IS NOT NULL
	BEGIN

	SET @ComparisonSet2 = (SELECT ComparisonSet2 FROM #comparison2 WHERE ID2 = @ID2)
	PRINT @ComparisonSet2

	INSERT INTO #compwidthgraph2
    SELECT dw.AppointmentGUID AS 'AppointmentGUID2'
				,	dw.AppointmentDate AS 'AppointmentDate2'
				,	dw.DiameterInMicrons AS 'DiameterInMicrons2'
				,	dw.AverageWidth AS 'AverageWidth2'
				,	dw.ComparisonSet AS 'ComparisonSet2'
				,	dw.ScalpAreaID AS 'ScalpAreaID2'
			FROM   #widthgraph2 dw
				INNER JOIN #comparison2 c ON dw.ComparisonSet = c.ComparisonSet2
			WHERE c.ID2 = @ID2


		--Then at the end of the loop
		SET @ID2 = (SELECT MIN(ID2)
				FROM #comparison2
				WHERE ID2 > @ID2)
	END

		/************************** Final Select ******************************************/

	--SELECT AppointmentGUID
	--	,	AppointmentDate
	--	,	CASE WHEN COUNT(AverageWidth) = 0 THEN 0 ELSE  ISNULL((SUM(AverageWidth)/COUNT(AverageWidth)),0) END AS 'AverageWidth'
	--	,	ComparisonSet
	--	,	ScalpAreaID
	--	,	AppointmentGUID2
	--	,	AppointmentDate2
	--	,	CASE WHEN COUNT(AverageWidth2) = 0 THEN 0 ELSE  ISNULL((SUM(AverageWidth2)/COUNT(AverageWidth2)),0) END AS 'AverageWidth2'
	--	,	ComparisonSet2
	--	,	ScalpAreaID2
	--FROM
	--	(SELECT    1 AS 'Comparative1'
	--		,	a.AppointmentGUID
	--		,	a.AppointmentDate
	--		,	a.DiameterInMicrons
	--		,	a.AverageWidth
	--		,	a.ComparisonSet
	--		,	a.ScalpAreaID
	--		,	b.AppointmentGUID2
	--		,	b.AppointmentDate2
	--		,	b.DiameterInMicrons2
	--		,	b.AverageWidth2
	--		,	b.ComparisonSet2
	--		,	b.ScalpAreaID2

	--	FROM #compwidthgraph a, #compwidthgraph2 b
	--	WHERE ComparisonSet = 1
	--	AND ComparisonSet2 = 1

	--	GROUP BY a.AppointmentGUID
	--		,	a.AppointmentDate
	--		,	a.DiameterInMicrons
	--		,	a.AverageWidth
	--		,	a.ComparisonSet
	--		,	a.ScalpAreaID
	--		,	b.AppointmentGUID2
	--		,	b.AppointmentDate2
	--		,	b.DiameterInMicrons2
	--		,	b.AverageWidth2
	--		,	b.ComparisonSet2
	--		,	b.ScalpAreaID2
	--		)r
	--GROUP BY AppointmentGUID
	--	,	AppointmentDate
	--	,	ComparisonSet
	--	,	ScalpAreaID
	--	,	AppointmentGUID2
	--	,	AppointmentDate2
	--	,	ComparisonSet2
	--	,	ScalpAreaID2

	INSERT INTO #final(
	Comparative
			,	AppointmentGUID
			,	AppointmentDate
			,	AverageWidth
			,	ComparisonSet
			,	ScalpAreaID)

	SELECT    1 AS 'Comparative'
			,	a.AppointmentGUID
			,	a.AppointmentDate
			,	a.AverageWidth
			,	a.ComparisonSet
			,	a.ScalpAreaID

		FROM #compwidthgraph a
		WHERE ComparisonSet = 1
		GROUP BY a.AppointmentGUID
			,	a.AppointmentDate
			,	a.DiameterInMicrons
			,	a.AverageWidth
			,	a.ComparisonSet
			,	a.ScalpAreaID
		UNION
		SELECT    2 AS 'Comparative'
			,	AppointmentGUID2 AS 'AppointmentGUID'
			,	AppointmentDate2 AS 'AppointmentDate'
			,	AverageWidth2 AS 'AverageWidth'
			,	ComparisonSet2 AS 'ComparisonSet'
			,	ScalpAreaID2 AS 'ScalpAreaID'

		FROM #compwidthgraph2
		WHERE ComparisonSet2 = 1
		GROUP BY AppointmentGUID2
			,	AppointmentDate2
			,	DiameterInMicrons2
			,	AverageWidth2
			,	ComparisonSet2
			,	ScalpAreaID2


SELECT * FROM #final


END
GO
