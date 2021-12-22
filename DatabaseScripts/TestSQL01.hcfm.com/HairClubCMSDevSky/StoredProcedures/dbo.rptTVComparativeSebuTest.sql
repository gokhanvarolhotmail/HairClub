/* CreateDate: 10/08/2014 09:04:28.920 , ModifyDate: 08/15/2016 23:40:20.183 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
Procedure Name:				[rptTVComparativeSebuTest]
Procedure Description:			This stored procedure provides the data for the SebuTest report.
Created By:					Rachelen Hut
Date Created:					10/17/2014
Destination Server.Database:   SQL01.HairclubCMS
Related Application:			TrichoView Comparative Analysis
================================================================================================
Change History:
05/07/2015	RH	Changed OnContact_cstd_activity_demographic_TABLE to datClientDemographic
07/18/2016 - RH - (#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC [rptTVComparativeSebuTest] '52EE6482-A768-410E-897E-43A5FF4F17C8','F7A7710A-B537-4C04-BF31-D0A6612C54E5' ,'M'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVComparativeSebuTest]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

	CREATE TABLE #sebum( ID INT IDENTITY(1,1)
		,	AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	Gender NVARCHAR(1)
		,	EthnicityDescriptionShort NVARCHAR(10)
		,	ScalpRegionID INT
		,	ScalpRegionDescriptionShort NVARCHAR(10)
		,	ScalpRegionDescription NVARCHAR(100)
		,	ReportResourceImageName NVARCHAR(50)
		,	SebuTapeLevelID INT
		,	SebuTapeLevelDescription NVARCHAR(100)
		,	SebuTapeLevelDescriptionShort NVARCHAR(10)
		,	SebuTapeLevelDetail NVARCHAR(500)
		,	ReportResourceImage VARBINARY(MAX)
		)

	CREATE TABLE #sebum2( ID INT IDENTITY(1,1)
		,	AppointmentGUID UNIQUEIDENTIFIER
		,	AppointmentDate DATETIME
		,	Gender NVARCHAR(1)
		,	EthnicityDescriptionShort NVARCHAR(10)
		,	ScalpRegionID INT
		,	ScalpRegionDescriptionShort NVARCHAR(10)
		,	ScalpRegionDescription NVARCHAR(100)
		,	ReportResourceImageName NVARCHAR(50)
		,	SebuTapeLevelID INT
		,	SebuTapeLevelDescription NVARCHAR(100)
		,	SebuTapeLevelDescriptionShort NVARCHAR(10)
		,	SebuTapeLevelDetail NVARCHAR(500)
		,	ReportResourceImage VARBINARY(MAX)
		)


/************************ Comparative 1 ********************************************/

	INSERT INTO #sebum
	SELECT 	st.AppointmentGUID
		,	appt.AppointmentDate
		,	LOWER(@Gender) AS 'Gender'
		,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
		,	st.ScalpRegionID
		,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
		,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
		,	CASE WHEN @Gender = 'F' THEN 'm'+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) --Default for now
				ELSE LOWER(@Gender)+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) END AS 'ReportResourceImageName'
		,	st.SebuTapeLevelID
		,	stl.DescriptionResourceKey AS 'SebuTapeLevelDescription'
		,	stl.SebuTapeLevelDescriptionShort
		,	stl.DetailResourceKey AS 'SebuTapeLevelDetail'
		,	NULL AS ReportResourceImage
	 FROM   dbo.datAppointmentSebuTape st
		INNER JOIN dbo.datAppointment appt
			ON st.AppointmentGUID = appt.AppointmentGUID
		INNER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON appt.ClientGUID = cd.ClientGUID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON cd.EthnicityID = eth.EthnicityID AND eth.IsActiveFlag = 1
		LEFT JOIN dbo.lkpScalpRegion sr
			ON st.ScalpRegionID = sr.ScalpRegionID
		INNER JOIN dbo.lkpSebuTapeLevel stl
			ON st.SebuTapeLevelID = stl.SebuTapeLevelID
	 WHERE st.AppointmentGUID = @AppointmentGUID
	 ORDER BY ScalpRegionID

	UPDATE #sebum
	SET #sebum.ReportResourceImage = rri.ReportResourceImage
	FROM #sebum
	INNER JOIN lkpReportResourceImage rri
		ON #sebum.ReportResourceImageName = rri.ReportResourceImageName

		--SELECT * FROM #sebum


/************************ Comparative 2 ********************************************/

	INSERT INTO #sebum2
	SELECT 	st.AppointmentGUID
		,	appt.AppointmentDate
		,	LOWER(@Gender) AS 'Gender'
		,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
		,	st.ScalpRegionID
		,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
		,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
		,	CASE WHEN @Gender = 'F' THEN 'm'+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) --Default for now
				ELSE LOWER(@Gender)+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) END AS 'ReportResourceImageName'
		,	st.SebuTapeLevelID
		,	stl.DescriptionResourceKey AS 'SebuTapeLevelDescription'
		,	stl.SebuTapeLevelDescriptionShort
		,	stl.DetailResourceKey AS 'SebuTapeLevelDetail'
		,	NULL AS ReportResourceImage
	 FROM   dbo.datAppointmentSebuTape st
		INNER JOIN dbo.datAppointment appt
			ON st.AppointmentGUID = appt.AppointmentGUID
		INNER JOIN dbo.datClient clt
			ON appt.ClientGUID = clt.ClientGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON appt.ClientGUID = cd.ClientGUID
		LEFT JOIN lkpGender g
			ON clt.GenderID = g.GenderID
		LEFT JOIN dbo.lkpEthnicity eth
			ON cd.EthnicityID = eth.EthnicityID AND eth.IsActiveFlag = 1
		LEFT JOIN dbo.lkpScalpRegion sr
			ON st.ScalpRegionID = sr.ScalpRegionID
		INNER JOIN dbo.lkpSebuTapeLevel stl
			ON st.SebuTapeLevelID = stl.SebuTapeLevelID
	 WHERE st.AppointmentGUID = @AppointmentGUID2
	 ORDER BY ScalpRegionID

	UPDATE #sebum2
	SET #sebum2.ReportResourceImage = rri.ReportResourceImage
	FROM #sebum2
	INNER JOIN lkpReportResourceImage rri
		ON #sebum2.ReportResourceImageName = rri.ReportResourceImageName

		--SELECT * FROM #sebum2



	/************************** Final Select ******************************************/

	SELECT 1 AS 'Comparative'
	,	a.AppointmentGUID
	,	a.AppointmentDate
      , a.Gender
      , a.EthnicityDescriptionShort
      , a.ScalpRegionID
      , a.ScalpRegionDescriptionShort
      , a.ScalpRegionDescription
      , a.ReportResourceImageName
      , a.SebuTapeLevelID
      , a.SebuTapeLevelDescription
      , a.SebuTapeLevelDescriptionShort
      , a.SebuTapeLevelDetail
      , a.ReportResourceImage
     FROM #sebum a
	UNION
	 SELECT 2 AS 'Comparative'
	  ,	b.AppointmentGUID
	  ,	b.AppointmentDate
      , b.Gender
      , b.EthnicityDescriptionShort
      , b.ScalpRegionID
      ,	b.ScalpRegionDescriptionShort
      , b.ScalpRegionDescription
      , b.ReportResourceImageName
      , b.SebuTapeLevelID
      , b.SebuTapeLevelDescription
      , b.SebuTapeLevelDescriptionShort
      , b.SebuTapeLevelDetail
      , b.ReportResourceImage
	  FROM #sebum2 b




END
GO
