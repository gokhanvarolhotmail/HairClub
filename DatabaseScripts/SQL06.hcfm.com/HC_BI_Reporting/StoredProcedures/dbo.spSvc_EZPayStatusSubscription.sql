/* CreateDate: 09/24/2019 11:23:38.970 , ModifyDate: 12/18/2021 17:27:18.900 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_EZPayStatusSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/24/2019
DESCRIPTION:			9/24/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_EZPayStatusSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_EZPayStatusSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'_CorporateAreaDirectors@hcfm.com;NBowman@hairclub.com;GDebono@hairclub.com;HMatthews@hairclub.com;dlittle@hairclub.com' AS 'SendTo'
,		'EZ Pay Status Report - ' + DATENAME(DW, GETDATE() - 0) + ', ' + CONVERT(VARCHAR, GETDATE() - 0, 101) AS 'Subject'


END
GO
