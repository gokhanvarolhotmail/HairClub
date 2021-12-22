/* CreateDate: 02/18/2020 13:56:11.590 , ModifyDate: 02/18/2020 14:14:08.683 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spSvc_LeadsConsultationsDetailByCenterSubscription]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		2/18/2020
DESCRIPTION:			2/18/2020
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spSvc_LeadsConsultationsDetailByCenterSubscription]
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_LeadsConsultationsDetailByCenterSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

SELECT  'rnarcisi@hairclub.com; moakes@hairclub.com; relder@hairclub.com; JChalson@hairclub.com; kkopp@hairclub.com; aspringstead@hairclub.com; whahn@hairclub.com; dleiba@hairclub.com; NKridel@hairclub.com; nbowman@hairclub.com; lorodriguez@hairclub.com' AS 'SendTo'
,		'mnassar@hairclub.com; rhut@hairclub.com' AS 'CCTo'
,       'Leads and Consultations Detail - All Centers - ' + DATENAME(DW, GETDATE() - 1) + ', ' + CONVERT(VARCHAR, GETDATE() - 1, 101) AS 'Subject'


END
GO
