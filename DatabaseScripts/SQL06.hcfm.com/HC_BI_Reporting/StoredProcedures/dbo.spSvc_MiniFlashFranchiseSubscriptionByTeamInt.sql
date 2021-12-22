/* CreateDate: 07/15/2021 08:14:14.757 , ModifyDate: 12/19/2021 20:22:06.940 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

EXEC spSvc_MiniFlashFranchiseSubscriptionByTeamInt
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MiniFlashFranchiseSubscriptionByTeamInt]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'mnassar@hairclub.com;whahn@hairclub.com;MSpadaccini@hairclub.com' AS 'SendTo',
       'chamrick@hairclub.com;brensing@hairclub.com;cczencz@hairclub.com' AS 'CopyTo'
,		'Daily Flash - All Franchise - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
,		'f' AS 'CenterType'

--SELECT	'lzuluaga@hairclub.com;eorrego@hairclub.com;jreyes@hairclub.com;jlopez@hairclub.com;nchavez@hairclub.com;jlopez@hairclub.com' AS 'SendTo'
--,		'Daily Flash - All Franchise - ' + DATENAME(DW, GETDATE()-1) + ', ' + CONVERT(VARCHAR, GETDATE()-1, 101) AS 'Subject'
--,		'f' AS 'CenterType'

END
GO
