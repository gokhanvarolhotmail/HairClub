/* CreateDate: 10/16/2014 13:42:22.230 , ModifyDate: 08/15/2016 23:41:40.947 */
GO
/*===============================================================================================
Procedure Name:				[rptTVSebuTest]
Procedure Description:			This stored procedure provides the data for the SebuTest report.
Created By:					Rachelen Hut
Date Created:					09/22/2014
Destination Server.Database:   SQL01.HairclubCMS
Related Application:			TrichoView Appointment
================================================================================================
CHANGE HISTORY:
05/07/2015	RH	Changed OnContact_cstd_activity_demographic_TABLE to datClientDemographic
07/18/2016  RH	(#122874) Added code for Localized Lookups using resource keys
================================================================================================
Sample Execution:

EXEC [rptTVSebuTest] '23EB42EC-0372-46FC-A7EA-5C0C6DF3D510', 'M'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVSebuTest]
	@AppointmentGUID UNIQUEIDENTIFIER
	,	@Gender NVARCHAR(1)

AS
BEGIN

	CREATE TABLE #sebum(
			AppointmentGUID UNIQUEIDENTIFIER
			,	AppointmentDate DATETIME
			,	Gender NVARCHAR(1)
			,	EthnicityDescriptionShort NVARCHAR(10)
			,	ScalpRegionID INT
			,	ScalpRegionDescriptionShort NVARCHAR(10)
			,	ScalpRegionDescription NVARCHAR(100)
			,	ReportResourceImageName NVARCHAR(50)
			,	SebuTapeLevelID INT
			,	SebuTapeLevelDescription NVARCHAR(100)
			,	SebuTapeLevelDescriptionShort  NVARCHAR(10)
			,	SebuTapeLevelDetail NVARCHAR(500)
			,	ReportResourceImage VARBINARY(MAX)
			,	SebuTapeImageName NVARCHAR(50)
			,	SebuTapeImage VARBINARY(MAX)
				)

	INSERT INTO #sebum
	SELECT 	st.AppointmentGUID
		,	appt.AppointmentDate
		,	LOWER(@Gender) AS 'Gender'
		,	ISNULL(LOWER(eth.EthnicityDescriptionShort),'as') AS 'EthnicityDescriptionShort'
		,	st.ScalpRegionID
		,	LOWER(sr.ScalpRegionDescriptionShort) AS 'ScalpRegionDescriptionShort'
		--,	sr.ScalpRegionDescription
		,	sr.DescriptionResourceKey AS 'ScalpRegionDescription'
		,	CASE WHEN @Gender = 'F' THEN 'm'+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) --Default for now
				ELSE LOWER(@Gender)+'_'+ISNULL(LOWER(eth.EthnicityDescriptionShort),'as')+'_x'+LOWER(sr.ScalpRegionDescriptionShort) END AS 'ReportResourceImageName'
		,	st.SebuTapeLevelID
		--,	stl.SebuTapeLevelDescription
		,	stl.DescriptionResourceKey AS 'SebuTapeLevelDescription'
		,	stl.SebuTapeLevelDescriptionShort
		--,	stl.SebuTapeLevelDetail
		,	stl.DetailResourceKey AS 'SebuTapeLevelDetail'
		,	NULL AS 'ReportResourceImage'
		,   'sebutape' + CAST(st.SebuTapeLevelID AS NVARCHAR(2)) AS 'SebuTapeImageName'
		,	NULL AS 'SebuTapeImage'
	 FROM   dbo.datAppointmentSebuTape st
		INNER JOIN dbo.datAppointment appt
			ON st.AppointmentGUID = appt.AppointmentGUID
		LEFT JOIN dbo.datClientDemographic cd
			ON appt.ClientGUID = cd.ClientGUID
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

	UPDATE #sebum
	SET #sebum.SebuTapeImage = rri.ReportResourceImage
	FROM #sebum
	INNER JOIN lkpReportResourceImage rri
		ON #sebum.SebuTapeImageName = rri.ReportResourceImageName




		SELECT * FROM #sebum



END
GO
