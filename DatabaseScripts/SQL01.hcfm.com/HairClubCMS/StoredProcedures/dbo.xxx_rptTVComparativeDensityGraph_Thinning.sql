/*===============================================================================================
 Procedure Name:				[rptTVComparativeDensityGraph_Thinning]
 Procedure Description:			This stored procedure provides the data for the Density grids.
 Created By:					Rachelen Hut
 Date Created:					09/22/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView Comparative report
================================================================================================
Change History:
09/29/2014	RH	Added AppointmentDate and AvgWidth in micrometers.
================================================================================================
Sample Execution:

EXEC [rptTVComparativeDensityGraph_Thinning] '2A29410B-45DB-48BA-8BCC-89B69C37AE7C', '29788281-DB63-4D3B-B9D6-F90782293A29'

================================================================================================*/

CREATE PROCEDURE [dbo].[xxx_rptTVComparativeDensityGraph_Thinning]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER


AS
BEGIN
	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT


	CREATE TABLE #Densitygraph(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	DiameterInMicrons DECIMAL(18,2)
		,	AverageWidth DECIMAL(18,2)
		,	ComparisonSet INT
		,	ScalpAreaID INT
	)


	CREATE TABLE #Densitygraph2(
			AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	DiameterInMicrons DECIMAL(18,2)
		,	AverageWidth DECIMAL(18,2)
		,	ComparisonSet INT
		,	ScalpAreaID INT
	)



	CREATE TABLE #compDensitygraph(AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	DiameterInMicrons DECIMAL(18,2)
			,	AverageWidth DECIMAL(18,2)
			,	ComparisonSet INT
			,	ScalpAreaID INT
			)


	CREATE TABLE #compDensitygraph2(AppointmentGUID2 UNIQUEIDENTIFIER
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

	INSERT INTO #Densitygraph

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
			AND ap.PhotoTypeID IN (4)  -- 4 is Density
			AND ScalpAreaID = 2

	/*********** ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison(ID INT IDENTITY(1,1),	ComparisonSet INT)

	INSERT INTO #comparison(ComparisonSet)
	SELECT DISTINCT ComparisonSet
	FROM #Densitygraph
	ORDER BY #Densitygraph.ComparisonSet


	--Set the @ID Variable for first iteration for ComparisonSet
	SET @ID = (SELECT MIN(ID) FROM #comparison)
	PRINT @ID
	--Loop through each ComparisonSet
	WHILE @ID IS NOT NULL
	BEGIN

	SET @ComparisonSet = (SELECT ComparisonSet FROM #comparison WHERE ID = @ID)
	PRINT @ComparisonSet

	INSERT INTO #compDensitygraph

    SELECT dw.AppointmentGUID
				,	dw.AppointmentDate
				,	dw.DiameterInMicrons
				,	dw.AverageWidth
				,	dw.ComparisonSet
				,	dw.ScalpAreaID
			FROM   #Densitygraph dw
				INNER JOIN #comparison c ON dw.ComparisonSet = c.ComparisonSet
			WHERE c.ID = @ID


		--Then at the end of the loop
		SET @ID = (SELECT MIN(ID)
				FROM #comparison
				WHERE ID > @ID)
	END

	/********************* Comparative 2 *********************************/

	INSERT INTO #Densitygraph2

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
			AND ap.PhotoTypeID IN (4)  -- 4 is Density
			AND ScalpAreaID = 2



	/*********** Comparative 2: ComparisonSet LOOP ***************************/

	CREATE TABLE #comparison2(ID2 INT IDENTITY(1,1),	ComparisonSet2 INT)

	INSERT INTO #comparison2(ComparisonSet2)
	SELECT DISTINCT ComparisonSet
	FROM #Densitygraph2
	GROUP BY #Densitygraph2.ComparisonSet
	ORDER BY #Densitygraph2.ComparisonSet


	--Set the @ID Variable for first iteration for ComparisonSet2
	SET @ID2 = (SELECT MIN(ID2) FROM #comparison2)
	PRINT @ID2
	--Loop through each ComparisonSet2
	WHILE @ID2 IS NOT NULL
	BEGIN

	SET @ComparisonSet2 = (SELECT ComparisonSet2 FROM #comparison2 WHERE ID2 = @ID2)
	PRINT @ComparisonSet2

	INSERT INTO #compDensitygraph2
    SELECT dw.AppointmentGUID AS 'AppointmentGUID2'
				,	dw.AppointmentDate AS 'AppointmentDate2'
				,	dw.DiameterInMicrons AS 'DiameterInMicrons2'
				,	dw.AverageWidth AS 'AverageWidth2'
				,	dw.ComparisonSet AS 'ComparisonSet2'
				,	dw.ScalpAreaID AS 'ScalpAreaID2'
			FROM   #Densitygraph2 dw
				INNER JOIN #comparison2 c ON dw.ComparisonSet = c.ComparisonSet2
			WHERE c.ID2 = @ID2


		--Then at the end of the loop
		SET @ID2 = (SELECT MIN(ID2)
				FROM #comparison2
				WHERE ID2 > @ID2)
	END

		/************************** Final Select ******************************************/

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

		FROM #compDensitygraph a
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

		FROM #compDensitygraph2
		WHERE ComparisonSet2 = 1
		GROUP BY AppointmentGUID2
			,	AppointmentDate2
			,	DiameterInMicrons2
			,	AverageWidth2
			,	ComparisonSet2
			,	ScalpAreaID2


SELECT * FROM #final

END
