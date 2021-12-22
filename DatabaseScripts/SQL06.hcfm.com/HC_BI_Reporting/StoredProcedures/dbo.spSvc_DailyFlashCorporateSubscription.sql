/* CreateDate: 03/30/2021 17:19:40.187 , ModifyDate: 12/18/2021 17:22:44.350 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_DailyFlashCorporateSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/31/2021
DESCRIPTION:			3/31/2021
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_DailyFlashCorporateSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_DailyFlashCorporateSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'_DeptManagementCommittee@hairclub.com;_CorporateRegionalDirectors@hairclub.com;_DailyFlashCorporate@hairclub.com;_DailyFlashAderans@hcfm.com;BRensing@hairclub.com;hiroki.itakura@aderans.com;mutsuo.minowa@aderans.com;yukino.baba@aderans.com;yosuke.ikunaga@aderans.com;masaaki.furukawa@aderans.com;shigehito.suzuki@aderans.com' AS 'SendTo'
,		'RElder@hairclub.com' AS 'CopyTo'
,		'Daily Flash - All Corporate - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
,		'C' AS 'CenterType'

END
GO
