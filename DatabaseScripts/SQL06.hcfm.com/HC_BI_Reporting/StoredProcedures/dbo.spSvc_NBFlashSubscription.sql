/***********************************************************************
PROCEDURE:				spSvc_NBFlashSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/10/2019
DESCRIPTION:			12/10/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_NBFlashSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_NBFlashSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'_CorporateRegionalDirectors@hairclub.com;_CorporateSalesTeam@hcfm.com;mnassar@hcfm.com;relder@hcfm.com;tgoldsmith@hcfm.com' AS 'SendTo'
,		'Flash New Business Report - ' + DATENAME(DW, GETDATE() -1) + ', ' + CONVERT(VARCHAR, GETDATE() -1, 101) AS 'Subject'


END
