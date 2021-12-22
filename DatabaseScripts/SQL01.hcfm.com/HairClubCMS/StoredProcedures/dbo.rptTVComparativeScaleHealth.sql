/*===============================================================================================
 Procedure Name:				rptTVComparativeScaleHealth
 Procedure Description:			This stored procedure provides the data for the Scalp Health grids.
 Created By:					Rachelen Hut
 Date Created:					09/22/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView Comparative
================================================================================================
Notes: This stored procedure is used for the Scale and Health screen in TrichoView Comparative.

Change History:
12/12/2014 - RH - Changed to the new table datClientDemographic for EthnicityID
01/02/2014 - RH - Removed the #ludwig table (WO#110161)
07/18/2016 - RH - (#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC [rptTVComparativeScaleHealth] 'F2CA8A03-271C-4356-AF30-049BDE3FADB8', 'F2CA8A03-271C-4356-AF30-049BDE3FADB8','M'


================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVComparativeScaleHealth]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender  NVARCHAR(1)

AS
BEGIN

	DECLARE @ID INT
	DECLARE @ComparisonSet INT
	DECLARE @ID2 INT
	DECLARE @ComparisonSet2 INT


/**************************Create temp tables****************************************************/


	CREATE TABLE #image(AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATETIME
	,	ClientGUID UNIQUEIDENTIFIER
	,	Gender NVARCHAR(1)
	,	GenderID INT
		,	ScalpHealthID INT
		,	ScalpHealthDescription NVARCHAR(100)
		,	ScalpHealthDetail NVARCHAR(500)
		,	EthnicityID INT
		,	EthnicityDescription  NVARCHAR(100)
		,	NorwoodScaleID INT
		,	NorwoodScaleDescription  NVARCHAR(100)
		,	NorwoodScaleDescriptionLong  NVARCHAR(200)
		,	LudwigScaleID INT
		,	LudwigScaleDescription  NVARCHAR(100)
		,	LudwigScaleDescriptionLong  NVARCHAR(200)
		,	ComparisonSet INT
		,	ScaleImage VARBINARY(MAX)
		,	HealthImage VARBINARY(MAX)
		)


	CREATE TABLE #image2(AppointmentGUID2 UNIQUEIDENTIFIER
	,	AppointmentDate2 DATETIME
	,	ClientGUID2 UNIQUEIDENTIFIER
	,	Gender2 NVARCHAR(1)
	,	GenderID2 INT
		,	ScalpHealthID2 INT
		,	ScalpHealthDescription2 NVARCHAR(100)
		,	ScalpHealthDetail2 NVARCHAR(500)
		,	EthnicityID2 INT
		,	EthnicityDescription2  NVARCHAR(100)
		,	NorwoodScaleID2 INT
		,	NorwoodScaleDescription2  NVARCHAR(100)
		,	NorwoodScaleDescriptionLong2  NVARCHAR(200)
		,	LudwigScaleID2 INT
		,	LudwigScaleDescription2  NVARCHAR(100)
		,	LudwigScaleDescriptionLong2  NVARCHAR(200)
		,	ComparisonSet2 INT
		,	ScaleImage2 VARBINARY(MAX)
		,	HealthImage2 VARBINARY(MAX)
		)

/**********************************Male*******************************************************/

	IF @Gender = 'M'
	BEGIN

		INSERT INTO #image
		SELECT TOP 1 appt.AppointmentGUID
		,	appt.AppointmentDate
			,	appt.ClientGUID
			,	@Gender AS 'Gender'
			,	g.GenderID
			,	appt.ScalpHealthID
			,	CASE WHEN ISNULL(appt.ScalpHealthID,0) = 0 THEN 'Unknown' ELSE sh.DescriptionResourceKey END AS 'ScalpHealthDescription'
			,	sh.DetailResourceKey AS 'ScalpHealthDetail'
			,	eth.EthnicityID
			,	eth.DescriptionResourceKey AS 'EthnicityDescription'
			,	ns.NorwoodScaleID
			,	ns.NorwoodScaleDescription
			,	ns.DescriptionLongResourceKey AS 'NorwoodScaleDescriptionLong'
			,	NULL AS LudwigScaleID
			,	NULL AS LudwigScaleDescription
			,	NULL AS LudwigScaleDescriptionLong
			,	ISNULL(ap.ComparisonSet,1) AS 'ComparisonSet'
			,	NULL AS ScaleImage
			,	NULL AS HealthImage

		FROM  datAppointment appt
		LEFT JOIN dbo.datAppointmentPhoto ap
			ON ap.AppointmentGUID = appt.AppointmentGUID
		LEFT JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic CD
			ON appt.ClientGUID = CD.ClientGUID
		LEFT JOIN dbo.lkpScalpHealth sh
			ON appt.ScalpHealthID = sh.ScalpHealthID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON CD.EthnicityID = eth.EthnicityID
		LEFT JOIN dbo.lkpNorwoodScale ns
			ON CD.NorwoodScaleID = ns.NorwoodScaleID
		WHERE  appt.AppointmentGUID = @AppointmentGUID


		/******* If EthnicityID is still null update with a 1 so that an image will appear for Scale ***********/

		UPDATE #image
		SET EthnicityID = 1
		WHERE EthnicityID IS NULL


		/********************* Find image for Scale for Male *************************/

		UPDATE i
		SET i.ScaleImage = rri.ReportResourceImage
		FROM #image i
		INNER JOIN lkpReportResourceImage rri
			ON i.GenderID =  rri.GenderID
		AND i.EthnicityID = rri.EthnicityID
		AND i.NorwoodScaleID = rri.NorwoodScaleID
		WHERE rri.NorwoodScaleID IS NOT NULL
			AND i.NorwoodScaleID IS NOT NULL
	END

	/********************************Comparative 2****************************************************/

	/**********************************Male*******************************************************/

	IF @Gender = 'M'
	BEGIN

		INSERT INTO #image2
		SELECT TOP 1 appt.AppointmentGUID AS 'AppointmentGUID2'
		,	appt.AppointmentDate AS 'AppointmentDate2'
			,	appt.ClientGUID  AS 'ClientGUID2'
			,	@Gender AS 'Gender2'
			,	g.GenderID AS 'GenderID2'
			,	appt.ScalpHealthID AS 'ScalpHealthID2'
			,	CASE WHEN ISNULL(appt.ScalpHealthID,0) = 0 THEN 'Unknown' ELSE sh.DescriptionResourceKey END AS 'ScalpHealthDescription2'
			,	sh.DetailResourceKey AS 'ScalpHealthDetail2'
			,	eth.EthnicityID AS 'EthnicityID2'
			,	eth.DescriptionResourceKey AS 'EthnicityDescription2'
			,	ns.NorwoodScaleID 'NorwoodScaleID2'
			,	ns.NorwoodScaleDescription AS 'NorwoodScaleDescription2'
			,	ns.DescriptionLongResourceKey AS 'NorwoodScaleDescriptionLong2'
			,	NULL AS 'LudwigScaleID2'
			,	NULL AS 'LudwigScaleDescription2'
			,	NULL AS 'LudwigScaleDescriptionLong2'
			,	ISNULL(ap.ComparisonSet,1) AS 'ComparisonSet2'
			,	NULL AS 'ScaleImage2'
			,	NULL AS 'HealthImage2'

		FROM  datAppointment appt
		LEFT JOIN dbo.datAppointmentPhoto ap
			ON ap.AppointmentGUID = appt.AppointmentGUID
		LEFT JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic CD
			ON appt.ClientGUID = CD.ClientGUID
		LEFT JOIN dbo.lkpScalpHealth sh
			ON appt.ScalpHealthID = sh.ScalpHealthID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON eth.EthnicityID = CD.EthnicityID
		LEFT JOIN dbo.lkpNorwoodScale ns
			ON CD.NorwoodScaleID = ns.NorwoodScaleID
		WHERE  appt.AppointmentGUID = @AppointmentGUID2


		/******* If EthnicityID is still null update with a 1 so that an image will appear for Scale ***********/

		UPDATE #image2
		SET EthnicityID2 = 1
		WHERE EthnicityID2 IS NULL


		/********************* Find image for Scale for Male *************************/

		UPDATE i2
		SET i2.ScaleImage2 = rri.ReportResourceImage
		FROM #image2 i2
		INNER JOIN lkpReportResourceImage rri
			ON i2.GenderID2 =  rri.GenderID
		AND i2.EthnicityID2 = rri.EthnicityID
		AND i2.NorwoodScaleID2 = rri.NorwoodScaleID
		WHERE rri.NorwoodScaleID IS NOT NULL
			AND i2.NorwoodScaleID2 IS NOT NULL
	END

	/*************************************************************************************************/
	/********************************** Female *******************************************************/

	IF @Gender = 'F'
	BEGIN

		INSERT INTO #image

		SELECT TOP 1 appt.AppointmentGUID
		,	appt.AppointmentDate
			,	appt.ClientGUID
			,	@Gender AS 'Gender'
			,	g.GenderID
			,	appt.ScalpHealthID
			,	CASE WHEN ISNULL(appt.ScalpHealthID,0) = 0 THEN 'Unknown' ELSE sh.DescriptionResourceKey END AS 'ScalpHealthDescription'
			,	sh.ScalpHealthDetail
			,	ISNULL(eth.EthnicityID,1) AS 'EthnicityID'
			,	eth.DescriptionResourceKey AS  'EthnicityDescription'
			,	NULL AS NorwoodScaleID
			,	NULL AS NorwoodScaleDescription
			,	NULL AS NorwoodScaleDescriptionLong
			,	ls.LudwigScaleID
			,	ls.LudwigScaleDescription
			,	ls.DescriptionLongResourceKey AS 'LudwigScaleDescriptionLong'
			,	ISNULL(ap.ComparisonSet,1) AS 'ComparisonSet'
			,	NULL AS ScaleImage
			,	NULL AS HealthImage

		FROM  datAppointment appt
		LEFT JOIN dbo.datAppointmentPhoto ap
			ON ap.AppointmentGUID = appt.AppointmentGUID
		LEFT JOIN dbo.datClientDemographic CD
			ON appt.ClientGUID = CD.ClientGUID
		LEFT JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.lkpScalpHealth sh
			ON appt.ScalpHealthID = sh.ScalpHealthID
		LEFT JOIN lkpGender g
			ON clt.GenderID =  g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON CD.EthnicityID = eth.EthnicityID
		LEFT JOIN dbo.lkpLudwigScale ls
			ON CD.LudwigScaleID = ls.LudwigScaleID
		WHERE  appt.AppointmentGUID = @AppointmentGUID

	/******* If EthnicityID is still null update with a 1 so that an image will appear for Scale ***********/

		UPDATE #image
		SET EthnicityID = 1
		WHERE EthnicityID IS NULL


	/********************* Find image for Scale for Female *************************/
		UPDATE i
		SET i.ScaleImage = rri.ReportResourceImage
		FROM #image i
		INNER JOIN lkpReportResourceImage rri
			ON i.GenderID =  rri.GenderID
		AND i.EthnicityID = rri.EthnicityID
		AND i.LudwigScaleID = rri.LudwigScaleID
		WHERE rri.LudwigScaleID IS NOT NULL
			AND i.LudwigScaleID IS NOT NULL
	END

	/*************************Comparative 2 ***************************************************************/

	IF @Gender = 'F'
	BEGIN

		INSERT INTO #image2

		SELECT TOP 1 appt.AppointmentGUID AS 'AppointmentGUID2'
			,	appt.AppointmentDate AS 'AppointmentDate2'
			,	appt.ClientGUID AS 'ClientGUID2'
			,	@Gender AS 'Gender2'
			,	g.GenderID AS 'GenderID2'
			,	appt.ScalpHealthID AS 'ScalpHealthID2'
			,	CASE WHEN ISNULL(appt.ScalpHealthID,0) = 0 THEN 'Unknown' ELSE sh.DescriptionResourceKey END AS 'ScalpHealthDescription2'
			,	sh.ScalpHealthDetail AS 'ScalpHealthDetail2'
			,	ISNULL(eth.EthnicityID,1) AS 'EthnicityID2'
			,	eth.DescriptionResourceKey AS 'EthnicityDescription2'
			,	NULL AS 'NorwoodScaleID2'
			,	NULL AS 'NorwoodScaleDescription2'
			,	NULL AS 'NorwoodScaleDescriptionLong2'
			,	ls.LudwigScaleID AS 'LudwigScaleID2'
			,	ls.LudwigScaleDescription AS 'LudwigScaleDescription2'
			,	ls.DescriptionLongResourceKey AS 'LudwigScaleDescriptionLong2'
			,	ISNULL(ap.ComparisonSet,1) AS 'ComparisonSet2'
			,	NULL AS 'ScaleImage2'
			,	NULL AS 'HealthImage2'


		FROM  datAppointment appt
		LEFT JOIN dbo.datAppointmentPhoto ap
			ON ap.AppointmentGUID = appt.AppointmentGUID
		LEFT JOIN dbo.datClientDemographic CD
			ON appt.ClientGUID = CD.ClientGUID
		LEFT JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.lkpScalpHealth sh
			ON appt.ScalpHealthID = sh.ScalpHealthID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON CD.EthnicityID = eth.EthnicityID
		LEFT JOIN dbo.lkpNorwoodScale ns
			ON CD.NorwoodScaleID = ns.NorwoodScaleID
		LEFT JOIN dbo.lkpLudwigScale ls
			ON CD.LudwigScaleID = ls.LudwigScaleID
		WHERE  appt.AppointmentGUID = @AppointmentGUID2


	/******* If EthnicityID is still null update with a 1 so that an image will appear for Scale ***********/

		UPDATE #image2
		SET EthnicityID2 = 1
		WHERE EthnicityID2 IS NULL


	/********************* Find image for Scale for Female *************************/
		UPDATE i2
		SET i2.ScaleImage2 = rri.ReportResourceImage
		FROM #image2 i2
		INNER JOIN lkpReportResourceImage rri
			ON i2.GenderID2 =  rri.GenderID
		AND i2.EthnicityID2 = rri.EthnicityID
		AND i2.LudwigScaleID2 = rri.LudwigScaleID
		WHERE rri.LudwigScaleID IS NOT NULL
			AND i2.LudwigScaleID2 IS NOT NULL
	END

	/********************* Find image for Health for either Male or Female ********************************/

	UPDATE i
	SET i.HealthImage = rri.ReportResourceImage
	FROM #image i
	INNER JOIN lkpReportResourceImage rri
		ON i.ScalpHealthID = rri.ScalpHealthID
	WHERE rri.ScalpHealthID IS NOT NULL
		AND i.ScalpHealthID IS NOT NULL

	UPDATE i2
	SET i2.HealthImage2 = rri.ReportResourceImage
	FROM #image2 i2
	INNER JOIN lkpReportResourceImage rri
		ON i2.ScalpHealthID2 = rri.ScalpHealthID
	WHERE rri.ScalpHealthID IS NOT NULL
		AND i2.ScalpHealthID2 IS NOT NULL


	/***************************Final Select **************************************************************/
	SELECT 1 AS Comparative1
	,	a.AppointmentGUID
	,	a.AppointmentDate
		,	a.ClientGUID
		,	a.Gender
		,	a.GenderID
		,	a.ScalpHealthID
		,	a.ScalpHealthDescription
		,	a.ScalpHealthDetail
		,	a.EthnicityID
		,	a.EthnicityDescription
		,	a.NorwoodScaleID
		,	a.NorwoodScaleDescription
		,	a.NorwoodScaleDescriptionLong
		,	a.LudwigScaleID
		,	a.LudwigScaleDescription
		,	a.LudwigScaleDescriptionLong
		,	a.ComparisonSet
		,	a.ScaleImage
		,	a.HealthImage

		,	b.AppointmentGUID2
		,	b.AppointmentDate2
		,	b.ClientGUID2
		,	b.Gender2
		,	b.GenderID2
		,	b.ScalpHealthID2
		,	b.ScalpHealthDescription2
		,	b.ScalpHealthDetail2
		,	b.EthnicityID2
		,	b.EthnicityDescription2
		,	b.NorwoodScaleID2
		,	b.NorwoodScaleDescription2
		,	b.NorwoodScaleDescriptionLong2
		,	b.LudwigScaleID2
		,	b.LudwigScaleDescription2
		,	b.LudwigScaleDescriptionLong2
		,	b.ComparisonSet2
		,	b.ScaleImage2
		,	b.HealthImage2
	FROM #image a, #image2 b
	GROUP BY a.AppointmentGUID
		,	a.AppointmentDate
		,	a.ClientGUID
		,	a.Gender
		,	a.GenderID
		,	a.ScalpHealthID
		,	a.ScalpHealthDescription
		,	a.ScalpHealthDetail
		,	a.EthnicityID
		,	a.EthnicityDescription
		,	a.NorwoodScaleID
		,	a.NorwoodScaleDescription
		,	a.NorwoodScaleDescriptionLong
		,	a.LudwigScaleID
		,	a.LudwigScaleDescription
		,	a.LudwigScaleDescriptionLong
		,	a.ComparisonSet
		,	a.ScaleImage
		,	a.HealthImage

		,	b.AppointmentGUID2
		,	b.AppointmentDate2
		,	b.ClientGUID2
		,	b.Gender2
		,	b.GenderID2
		,	b.ScalpHealthID2
		,	b.ScalpHealthDescription2
		,	b.ScalpHealthDetail2
		,	b.EthnicityID2
		,	b.EthnicityDescription2
		,	b.NorwoodScaleID2
		,	b.NorwoodScaleDescription2
		,	b.NorwoodScaleDescriptionLong2
		,	b.LudwigScaleID2
		,	b.LudwigScaleDescription2
		,	b.LudwigScaleDescriptionLong2
		,	b.ComparisonSet2
		,	b.ScaleImage2
		,	b.HealthImage2

END
