/* CreateDate: 06/15/2020 10:08:06.610 , ModifyDate: 12/19/2021 20:20:02.383 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MiniFlashFranchiseSubscription
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

EXEC spSvc_MiniFlashFranchiseSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MiniFlashFranchiseSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'_DailyFlashFranchise@hcfm.com;BRensing@hairclub.com' AS 'SendTo'
,		'Daily Flash - All Franchise - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
,		'f' AS 'CenterType'

--SELECT	'lzuluaga@hairclub.com;eorrego@hairclub.com;jreyes@hairclub.com;jlopez@hairclub.com;nchavez@hairclub.com;jlopez@hairclub.com' AS 'SendTo'
--,		'Daily Flash - All Franchise - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
--,		'f' AS 'CenterType'

END
GO
