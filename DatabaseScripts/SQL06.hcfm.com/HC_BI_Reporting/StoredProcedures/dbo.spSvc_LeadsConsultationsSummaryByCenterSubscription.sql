/***********************************************************************
PROCEDURE:				[spSvc_LeadsConsultationsSummaryByCenterSubscription]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/30/2020
DESCRIPTION:			3/30/2020
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spSvc_LeadsConsultationsSummaryByCenterSubscription]
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_LeadsConsultationsSummaryByCenterSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

SELECT  'MNassar@hairclub.com; WHahn@hairclub.com; RNarcisi@hairclub.com; JChalson@hairclub.com; MSpadaccini@hairclub.com; bseward@cannellamedia.com; agonzales@hairclub.com; achristy@hairclub.com; RKalra@hairclub.com; TPetersen@hairclub.com' AS 'SendTo'
,       'Leads and Consultations Summary - All Centers - ' + DATENAME(DW, GETDATE() - 1) + ', ' + CONVERT(VARCHAR, GETDATE() - 1, 101) AS 'Subject'

END
