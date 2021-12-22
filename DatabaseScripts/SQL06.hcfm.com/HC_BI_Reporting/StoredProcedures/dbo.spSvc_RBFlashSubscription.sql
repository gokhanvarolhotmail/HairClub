/***********************************************************************
PROCEDURE:				spSvc_RBFlashSubscription
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

EXEC spSvc_RBFlashSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_RBFlashSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'_CorporateRegionalDirectors@hairclub.com;_CorporateSalesTeam@hcfm.com;mnassar@hcfm.com;relder@hcfm.com;tgoldsmith@hcfm.com' AS 'SendTo'
,		'Flash Recurring Business - ' + DATENAME(DW, GETDATE() -1) + ', ' + CONVERT(VARCHAR, GETDATE() -1, 101) AS 'Subject'


END
