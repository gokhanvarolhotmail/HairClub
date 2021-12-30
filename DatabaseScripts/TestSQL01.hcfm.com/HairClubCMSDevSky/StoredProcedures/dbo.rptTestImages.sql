/* CreateDate: 09/04/2014 12:24:03.657 , ModifyDate: 09/05/2014 11:06:48.500 */
GO
/*===============================================================================================
 Procedure Name:				[rptTestImages]
 Procedure Description:			This stored procedure provides the image to test.
 Created By:					Rachelen Hut
 Date Created:					08/04/2014
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			TrichoView
================================================================================================
NOTES:  This has to run on SQL01 to show the images OR Link to SQL01 in the statements - SQL01.HairclubCMS....
================================================================================================
Sample Execution:

EXEC [rptTestImages] 'Ludwig', NULL, 9, NULL, NULL, 4, 2

EXEC [rptTestImages] 'Norwood', 9, NULL, NULL, NULL, 4, 1

EXEC [rptTestImages] 'Scalp', NULL, NULL, 1, NULL, NULL, NULL

EXEC [rptTestImages] 'Headmap', NULL, NULL, NULL, NULL, 6, 1

EXEC [rptTestImages] 'HeadmapTarget', NULL, NULL, NULL, NULL, NULL, NULL


================================================================================================*/

CREATE PROCEDURE [dbo].[rptTestImages](
	@RRImageCategory NVARCHAR(50)
	,	@NorwoodScaleID INT
	,	@LudwigScaleID INT
	,	@ScalpHealthID INT
	,	@ScalpRegionID INT
	,	@EthnicityID INT
	,	@GenderID INT
	--,	@SorenessLevelID INT
	--,	@SebumLevelID INT
	--,	@FlakingLevelID INT
	)
AS


BEGIN

	SET NOCOUNT ON;

	IF @NorwoodScaleID IS NOT NULL
	BEGIN
		SELECT TOP 1 ReportResourceImage
		,	ReportResourceImageID
		,	ReportResourceImageName
		FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
		WHERE RRImageCategory =  @RRImageCategory
		AND NorwoodScaleID = @NorwoodScaleID
		AND EthnicityID = @EthnicityID
		AND GenderID = @GenderID
	END
ELSE
	IF @LudwigScaleID IS NOT NULL
	BEGIN
		SELECT TOP 1 ReportResourceImage
		,	ReportResourceImageID
		,	ReportResourceImageName
		FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
		WHERE RRImageCategory =  @RRImageCategory
		AND LudwigScaleID = @LudwigScaleID
		AND EthnicityID = @EthnicityID
		AND GenderID = @GenderID
	END
ELSE
	IF @ScalpHealthID IS NOT NULL
	BEGIN
		SELECT  TOP 1 ReportResourceImage
		,	ReportResourceImageID
		,	ReportResourceImageName
		FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
		WHERE RRImageCategory =  @RRImageCategory
		AND ScalpHealthID = @ScalpHealthID
	END
ELSE
	IF @RRImageCategory = 'Headmap'
	BEGIN
		SELECT  TOP 1 ReportResourceImage
		,	ReportResourceImageID
		,	ReportResourceImageName
		FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
		WHERE RRImageCategory =  @RRImageCategory
		AND EthnicityID = @EthnicityID
		AND GenderID = @GenderID
	END

	ELSE
	IF @RRImageCategory = 'HeadmapTarget'
	BEGIN
		SELECT  TOP 1 ReportResourceImage
		,	ReportResourceImageID
		,	ReportResourceImageName
		FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
		WHERE RRImageCategory =  'HeadmapTarget'
		UNION
		SELECT TOP 1 ReportResourceImage
		,	ReportResourceImageID
		,	ReportResourceImageName
		FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
		WHERE RRImageCategory =  'Headmap'

	END


END


	--CREATE TABLE #image(
	--	RRImageCategory NVARCHAR(50)
	--	,	NorwoodScaleID INT
	--	,	LudwigScaleID INT
	--	,	ScalpRegionID INT
	--	,	EthnicityID INT
	--	,	GenderID INT)

	--SELECT  TOP 1 ReportResourceImage
	--      --, ReportResourceImageName
	--      --, ReportResourceImageID
	--      --, NorwoodScaleID
	--      --, LudwigScaleID
	--      --, ScalpHealthID
	--      --, ScalpRegionID
	--      --, EthnicityID
	--      --, GenderID
	--      --, MimeType
	--      --, SorenessLevelID
	--      --, SebumLevelID
	--      --, FlakingLevelID
	--      --, IsActiveFlag

	--FROM SQL01.HairclubCMS.dbo.lkpReportResourceImage
GO
