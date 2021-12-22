/* CreateDate: 10/15/2014 18:28:48.820 , ModifyDate: 04/26/2017 08:56:33.733 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
RELATED REPORT:
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		4/25/2017
------------------------------------------------------------------------
NOTES:
/*ExtraLight
Heavy
Light
LightPlus
MediumDensity
MediumHeavy
MediumLight*/

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [rptTVImages_DensityScale]

***********************************************************************/
CREATE PROCEDURE [dbo].[rptTVImages_DensityScale]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

SELECT TOP 1 Den_ExtraLight
,	Den_Light
,	Den_LightPlus
,	Den_MediumDensity
,	Den_MediumHeavy
,	Den_MediumLight
,	Den_Heavy
FROM (
	SELECT
		Den_ExtraLight = ( SELECT ReportResourceImage
					FROM dbo.lkpReportResourceImage
					WHERE RRImageCategory = 'DensityScale'
					AND ReportResourceImageName = 'ExtraLight' )
	,	Den_Light = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'DensityScale'
						AND ReportResourceImageName = 'Light' )
	,	Den_LightPlus = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'DensityScale'
						AND ReportResourceImageName = 'LightPlus' )
	,	Den_MediumDensity = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'DensityScale'
						AND ReportResourceImageName = 'MediumDensity' )
	,	Den_MediumHeavy = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'DensityScale'
						AND ReportResourceImageName = 'MediumHeavy' )
		,	Den_MediumLight = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'DensityScale'
						AND ReportResourceImageName = 'MediumLight' )
		,	Den_Heavy = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'DensityScale'
						AND ReportResourceImageName = 'Heavy' )

)q



END
GO
