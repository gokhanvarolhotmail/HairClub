/* CreateDate: 08/06/2014 16:19:19.080 , ModifyDate: 09/17/2019 10:27:38.950 */
GO
/*===============================================================================================
 Procedure Name:				rptTVScaleHealthScreen
 Procedure Description:			This stored procedure provides the data for the Scalp Health grids.
 Created By:					Rachelen Hut
 Date Created:					08/04/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView
================================================================================================
Notes: This stored procedure is used for the Scale and Health screen in TrichoView.

12/5/2014	RH	Removed the line for ComparisonSet = 1 - this was removing some information
12/29/2014	RH	Changed query to use the datClientDemographic table (#110161)
01/04/2016	RH	Using the OnContact_cstd_activity_demographic_TABLE first, then updating with client information if it exists (#118117)
02/04/2016	RH	Changed the JOIN to onc.norwood = ns.BOSNorwoodScaleCode and onc.ludwig = ls.BOSLudwigScaleCode
02/04/2016	RH	Changed GenderID to 1 for Male and 2 for Female
06/06/2016  RH	Corrected join for NorwoodScaleDescription and LudwigScaleDescription
07/11/2016  RH	(#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC rptTVScaleHealthScreen '7C63B743-BA88-4BB3-A3D5-2CC8DC8F0386', 'M'


================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVScaleHealthScreen]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@Gender  NVARCHAR(1)

AS
BEGIN

/**************************Create temp tables****************************************************/


	CREATE TABLE #image(AppointmentGUID UNIQUEIDENTIFIER
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

/**********************************Male*******************************************************/

IF @Gender = 'M'
BEGIN

		INSERT INTO #image
		SELECT TOP 1 appt.AppointmentGUID
			,	appt.ClientGUID
			,	'M' AS 'Gender'
			,	1 AS 'GenderID'
			,	appt.ScalpHealthID
			,	CASE WHEN ISNULL(appt.ScalpHealthID,0) = 0 THEN 'Unknown' ELSE sh.DescriptionResourceKey END AS 'ScalpHealthDescription'
			--,	sh.ScalpHealthDetail
			,	sh.DetailResourceKey AS 'ScalpHealthDetail'
			,	eth.EthnicityID
			--,	eth.EthnicityDescription
			,	eth.DescriptionResourceKey AS 'EthnicityDescription'
			,	ns.NorwoodScaleID
			,	ns.NorwoodScaleDescription
			--,	ns.NorwoodScaleDescriptionLong
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
		LEFT JOIN dbo.datClientDemographic onc
			ON clt.ClientGUID = onc.ClientGUID
		LEFT JOIN dbo.lkpScalpHealth sh
			ON appt.ScalpHealthID = sh.ScalpHealthID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON onc.EthnicityID = eth.EthnicityID
			AND eth.IsActiveFlag = 1
		LEFT JOIN dbo.lkpNorwoodScale ns
			ON onc.NorwoodScaleID = ns.NorwoodScaleID
		WHERE  appt.AppointmentGUID = @AppointmentGUID

		/************* If the ethnicity and scale do not populate and there is a client record, get the information from datClient ******/

		IF (SELECT ClientGUID FROM #image) IS NOT NULL
		BEGIN
			UPDATE i
			SET i.EthnicityID = CD.EthnicityID
			FROM #image i
			INNER JOIN dbo.datClientDemographic CD
				ON i.ClientGUID = CD.ClientGUID
		END

		IF (SELECT ClientGUID FROM #image) IS NOT NULL
		BEGIN
			UPDATE i
			SET i.NorwoodScaleID = CD.NorwoodScaleID
			FROM #image i
			INNER JOIN dbo.datClientDemographic CD
				ON i.ClientGUID = CD.ClientGUID
		END

		/******* If EthnicityID is still null update with a 1 so that an image will appear for Scale ***********/

		UPDATE #image
		SET EthnicityID = 1
		WHERE EthnicityID IS NULL


		/*******Update the NorwoodScale Description and NorwoodScalDescriptionLong for the update NorwoodScaleID***/

		IF (SELECT ClientGUID FROM #image) IS NOT NULL
		BEGIN
			UPDATE i
			SET i.NorwoodScaleDescription = ls.NorwoodScaleDescription
			FROM #image i
			INNER JOIN dbo.lkpNorwoodScale ls
				ON i.NorwoodScaleID = ls.NorwoodScaleID
			WHERE i.NorwoodScaleDescription IS NULL

			UPDATE i
			SET i.NorwoodScaleDescriptionLong = ls.DescriptionLongResourceKey
			FROM #image i
			INNER JOIN dbo.lkpNorwoodScale ls
				ON i.NorwoodScaleID = ls.NorwoodScaleID
			WHERE i.NorwoodScaleDescriptionLong IS NULL
		END


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

/********************************** Female *******************************************************/

IF @Gender = 'F'
BEGIN

		INSERT INTO #image

		SELECT TOP 1 appt.AppointmentGUID
			,	appt.ClientGUID
			,	@Gender AS 'Gender'
			,	2 AS 'GenderID'
			,	appt.ScalpHealthID
			,	CASE WHEN ISNULL(appt.ScalpHealthID,0) = 0 THEN 'Unknown' ELSE sh.DescriptionResourceKey END AS 'ScalpHealthDescription'
			,	sh.DetailResourceKey AS 'ScalpHealthDetail'
			,	ISNULL(eth.EthnicityID,1) AS 'EthnicityID'
			,	eth.DescriptionResourceKey AS 'EthnicityDescription'
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
		LEFT JOIN dbo.datClientDemographic onc
			ON appt.ClientGUID = onc.ClientGUID
		LEFT JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.lkpScalpHealth sh
			ON appt.ScalpHealthID = sh.ScalpHealthID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON onc.EthnicityID = eth.EthnicityID
			AND eth.IsActiveFlag = 1
		LEFT JOIN dbo.lkpLudwigScale ls
			ON onc.LudwigScaleID = ls.LudwigScaleID
		WHERE  appt.AppointmentGUID = @AppointmentGUID


		--SELECT * FROM #image


	/************************ If the ethnicity and scale do not populate and there is a client record, get the information from datClient ******/

		IF (SELECT ClientGUID FROM #image) IS NOT NULL
		BEGIN
			UPDATE i
			SET i.EthnicityID = CD.EthnicityID
			FROM #image i
			INNER JOIN dbo.datClientDemographic CD
			ON i.ClientGUID = CD.ClientGUID
			WHERE i.EthnicityID IS NULL
		END

		IF (SELECT ClientGUID FROM #image) IS NOT NULL
		BEGIN
			UPDATE i
			SET i.LudwigScaleID = CD.LudwigScaleID
			FROM #image i
			INNER JOIN dbo.datClientDemographic CD
			ON i.ClientGUID = CD.ClientGUID
			WHERE i.LudwigScaleID IS NULL
		END

	/******* If EthnicityID is still null update with a 1 so that an image will appear for Scale ***********/

		UPDATE #image
		SET EthnicityID = 1
		WHERE EthnicityID IS NULL


	/*******Update the LudwigScale Description and LudwigScalDescriptionLong for the update LudwigScaleID***/

		IF (SELECT ClientGUID FROM #image) IS NOT NULL
		BEGIN
			UPDATE i
			SET i.LudwigScaleDescription = ls.LudwigScaleDescription
			FROM #image i
			INNER JOIN dbo.lkpLudwigScale ls
				ON i.LudwigScaleID = ls.LudwigScaleID
			WHERE i.LudwigScaleDescription IS NULL

			UPDATE i
			SET i.LudwigScaleDescriptionLong = ls.DescriptionLongResourceKey
			FROM #image i
			INNER JOIN dbo.lkpLudwigScale ls
				ON i.LudwigScaleID = ls.LudwigScaleID
			WHERE i.LudwigScaleDescriptionLong IS NULL
		END



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


	/********************* Find image for Health for either Male or Female ********************************/

	UPDATE i
	SET i.HealthImage = rri.ReportResourceImage
	FROM #image i
	INNER JOIN lkpReportResourceImage rri
		ON i.ScalpHealthID = rri.ScalpHealthID
	WHERE rri.ScalpHealthID IS NOT NULL
		AND i.ScalpHealthID IS NOT NULL

	SELECT AppointmentGUID
		,	ClientGUID
		,	Gender
		,	GenderID
		,	ScalpHealthID
		,	ScalpHealthDescription
		,	ScalpHealthDetail
		,	EthnicityID
		,	EthnicityDescription
		,	NorwoodScaleID
		,	NorwoodScaleDescription
		,	NorwoodScaleDescriptionLong
		,	LudwigScaleID
		,	LudwigScaleDescription
		,	LudwigScaleDescriptionLong
		,	ComparisonSet
		,	ScaleImage
		,	HealthImage
	FROM #image

END
GO
