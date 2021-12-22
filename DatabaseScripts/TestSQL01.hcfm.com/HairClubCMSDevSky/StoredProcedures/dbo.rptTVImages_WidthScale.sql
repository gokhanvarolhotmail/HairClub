/* CreateDate: 10/15/2014 19:01:17.067 , ModifyDate: 04/26/2017 08:54:39.523 */
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
/*Coarse
Fine
MediumCoarse
MediumFine
MediumWidth
VeryFine*/

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [rptTVImages_WidthScale]

***********************************************************************/
CREATE PROCEDURE [dbo].[rptTVImages_WidthScale]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

SELECT TOP 1 Wid_Coarse
,	Wid_Fine
,	Wid_MediumCoarse
,	Wid_MediumFine
,	Wid_MediumWidth
,	Wid_VeryFine

FROM (
	SELECT
		Wid_Coarse = ( SELECT ReportResourceImage
					FROM dbo.lkpReportResourceImage
					WHERE RRImageCategory = 'WidthScale'
					AND ReportResourceImageName = 'Coarse' )
	,	Wid_Fine = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'WidthScale'
						AND ReportResourceImageName = 'Fine' )
	,	Wid_MediumCoarse = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'WidthScale'
						AND ReportResourceImageName = 'MediumCoarse' )
	,	Wid_MediumFine = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'WidthScale'
						AND ReportResourceImageName = 'MediumFine' )
	,	Wid_MediumWidth = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'WidthScale'
						AND ReportResourceImageName = 'MediumWidth' )
	,	Wid_VeryFine = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'WidthScale'
						AND ReportResourceImageName = 'VeryFine' )

)q



END
GO
