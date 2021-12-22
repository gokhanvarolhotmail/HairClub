/* CreateDate: 10/15/2014 19:25:33.803 , ModifyDate: 04/26/2017 08:55:29.453 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	[HairClubCMS]
RELATED REPORT:
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		4/25/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [rptTVImages_HMIScale]

***********************************************************************/
CREATE PROCEDURE [rptTVImages_HMIScale]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

SELECT TOP 1 HMI_NoLoss
,	HMI_Minimal
,	HMI_Mild
,	HMI_Mod
,	HMI_Severe
FROM (
	SELECT
		HMI_NoLoss = ( SELECT ReportResourceImage
					FROM dbo.lkpReportResourceImage
					WHERE RRImageCategory = 'HMIScale'
					AND ReportResourceImageName = 'NoHairLoss' )
	,	HMI_Minimal = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'HMIScale'
						AND ReportResourceImageName = 'MinimalHairLoss' )
	,	HMI_Mild = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'HMIScale'
						AND ReportResourceImageName = 'MildHairLoss' )
	,	HMI_Mod = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'HMIScale'
						AND ReportResourceImageName = 'ModerateHairLoss' )
	,	HMI_Severe = (SELECT ReportResourceImage
						FROM dbo.lkpReportResourceImage
						WHERE RRImageCategory = 'HMIScale'
						AND ReportResourceImageName = 'SevereHairLoss' )
)q



END
GO
