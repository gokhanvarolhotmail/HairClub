/* CreateDate: 09/04/2020 16:30:56.677 , ModifyDate: 02/04/2021 13:28:56.050 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerCallExportBP
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/5/2020
DESCRIPTION:			9/5/2020
------------------------------------------------------------------------
NOTES:
	10/12/2020	KMurdoch	Modified to remove call type group associated with SMS
	10/14/2020  KMurdoch    Modified to add column SystemDisposition to job.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MediaBuyerCallExportBP '9/01/2020', '01/28/2021'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MediaBuyerCallExportBP]
(
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME


SET @CurrentDate = GETDATE()


-- Set Dates If Parameters are NULL
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
   END


--SET @StartDate = '9/1/2020'


-- Get Call Data
SELECT	Call_RecordKey AS 'Call_RecordKey'
,		CenterSSID AS 'CenterSSID'
,		Call_Date
,		Call_Time
,		Service_Name AS 'CallTypeDescription'
,		Call_Type_Group
,		ISNULL(Inbound_Phone, '') AS 'TollFreeNumber'
,		InboundSourceSSID AS 'InboundSourceCode'
,		Inbound_Campaign_Name AS 'InboundCampaign'
,		LeadSourceSSID AS 'LeadSourceCode'
,		Lead_Campaign_Name AS 'LeadCampaignName'
,		LEFT(Lead_Phone,6) AS 'Lead_Phone'
,		SFDC_LeadID
,		SFDC_TaskID
,		User_Login_ID
,		Agent_Disposition
,		Is_Viable_Call
,		Call_Length
,		Talk_Time
,		System_Disposition
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwDimCallDataBP
WHERE	Call_Date BETWEEN @StartDate AND @EndDate
		AND Call_Type_Group NOT IN ( 'SMS' )

END
GO
