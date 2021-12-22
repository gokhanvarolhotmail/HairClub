/* CreateDate: 02/18/2020 13:48:29.387 , ModifyDate: 12/18/2021 17:28:59.650 */
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

SELECT  'MNassar@hairclub.com; WHahn@hairclub.com; RNarcisi@hairclub.com; JChalson@hairclub.com; MSpadaccini@hairclub.com; bseward@cannellamedia.com; agonzales@hairclub.com; achristy@hairclub.com; RKalra@hairclub.com; TPetersen@hairclub.com' AS 'SendTo'
,       'Leads and Consultations Detail - All Centers - ' + DATENAME(DW, GETDATE() - 1) + ', ' + CONVERT(VARCHAR, GETDATE() - 1, 101) AS 'Subject'

END
GO
