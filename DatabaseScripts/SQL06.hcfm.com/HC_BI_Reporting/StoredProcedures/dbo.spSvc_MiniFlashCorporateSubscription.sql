/* CreateDate: 01/31/2020 17:13:34.847 , ModifyDate: 12/18/2021 17:31:12.333 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MiniFlashCorporateSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/31/2020
DESCRIPTION:			1/31/2020
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MiniFlashCorporateSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MiniFlashCorporateSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


--SELECT	'_CorporateRegionalDirectors@hairclub.com;_DeptManagementCommittee@hairclub.com;_DailyFlashAderans@hcfm.com;hiroki.itakura@aderans.com;mutsuo.minowa@aderans.com;yukino.baba@aderans.com;yosuke.ikunaga@aderans.com;masaaki.furukawa@aderans.com;shigehito.suzuki@aderans.com;kmurdoch@hairclub.com;dleiba@hairclub.com;mhurtado@hairclub.com;SHopkins@hairclub.com;ADonovan@hairclub.com;KBurckhardt@hairclub.com;DHoyos@hairclub.com;BRensing@hairclub.com' AS 'SendTo'
--,		'Daily Flash - All Corporate - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
--,		'c' AS 'CenterType'

SELECT	'_DailyFlashFranchise@hcfm.com' AS 'SendTo'
,		'brensing@hairclub.com' AS 'CopyTo'
,		'Daily Flash - All Franchise - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
,		'c' AS 'CenterType'


END
GO
