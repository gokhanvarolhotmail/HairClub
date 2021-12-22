/* CreateDate: 08/02/2020 22:03:00.320 , ModifyDate: 12/19/2021 20:27:10.270 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
