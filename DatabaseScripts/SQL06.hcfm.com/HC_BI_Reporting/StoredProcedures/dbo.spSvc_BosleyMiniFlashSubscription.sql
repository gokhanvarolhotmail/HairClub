/***********************************************************************
PROCEDURE:				spSvc_BosleyMiniFlashSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/29/2020
DESCRIPTION:			1/29/2020
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BosleyMiniFlashSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BosleyMiniFlashSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT  'mnassar@hcfm.com; jchalson@hcfm.com; nbowman@hcfm.com; agonzales@hairclub.com; jwethington@hairclub.com; amym@bosley.com; jiml@bosley.com; robs@bosley.com; AndrewS@bosley.com; AidanP@bosley.com; ArtinM@bosley.com; mutsuo.minowa@aderans.com; vern.elenel@gmail.com; _CorporateAreaDirectors@hairclub.com' AS 'SendTo'
,		 'brensing@hairclub.com' AS 'CCTo'
,		'Daily Bosley Synergy Flash - All Corporate - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
,		'C' AS 'CenterType'


END
