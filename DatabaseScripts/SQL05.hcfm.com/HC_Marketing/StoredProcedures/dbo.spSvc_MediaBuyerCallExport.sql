/* CreateDate: 06/10/2020 15:34:24.620 , ModifyDate: 06/10/2020 15:38:36.037 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerCallExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/5/2018
DESCRIPTION:			4/5/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MediaBuyerCallExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].spSvc_MediaBuyerCallExport
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


--SET @StartDate = '1/1/2017'


-- Get Call Data
SELECT	CallRecordSSID AS 'CallRecordID'
,		CenterSSID AS 'CenterID'
,		CallDate
,		CallTime
,		CallTypeSSID AS 'CallType'
,		CallTypeDescription AS 'CallTypeDescription'
,		CallTypeGroup
,		ISNULL(TollFreeNumber, '') AS 'TollFreeNumber'
,		InboundSourceSSID AS 'InboundSourceCode'
,		InboundSourceDescription AS 'InboundSourceCodeDescription'
,		LeadSourceSSID AS 'LeadSourceCode'
,		LeadSourceDescription AS 'LeadSourceCodeDescription'
,		CallPhoneNo
,		SFDC_LeadID
,		SFDC_TaskID
,		UsedBy
,		CallStatusSSID AS 'CallStatus'
,		CallStatusDescription
,		AdditionalCallStatusSSID AS 'AdditionalCallStatus'
,		AdditionalCallStatusDescription
,		UserSSID AS 'UserID'
,		NobleUserSSID AS 'NobleUserID'
,		IsViableCall
,		CallLength
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwDimCallData
WHERE	CallDate BETWEEN @StartDate AND @EndDate

END
GO
