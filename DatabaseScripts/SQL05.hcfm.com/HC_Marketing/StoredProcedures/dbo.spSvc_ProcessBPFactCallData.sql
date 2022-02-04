/* CreateDate: 09/04/2020 09:24:40.990 , ModifyDate: 01/24/2022 14:21:23.247 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ProcessBPFactCallData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Kevin Murdoch
DATE IMPLEMENTED:		9/4/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

12/14/2020	KMurdoch	Added check for TimeOfDay key to not select last record 0 and 86400 are both 12:00:00AM

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ProcessBPFactCallData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_ProcessBPFactCallData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


		DECLARE @enddate DATETIME
		SET @enddate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))

/********************************** Insert Data into FactCallData *************************************/
INSERT INTO HC_BI_MKTG_DDS.bi_mktg_dds.FactCallDataBP (
	Call_RecordKey
,	Call_DateKey
,	Call_TimeKey
,	InboundSourceKey
,	ContactKey
,	ActivityKey
,	Is_Viable_Call
,	Is_Productive_Call
,	Call_Length
,	IVR_Time
,	Queue_Time
,	Pending_Time
,	Talk_Time
,	Hold_Time
)
SELECT	dcd.Call_RecordKey
,		ISNULL(d.DateKey, -1)
,		ISNULL(tod.TimeOfDayKey, -1)
,		ISNULL(ins.SourceKey, -1)
,		ISNULL(c.ContactKey, -1)
--,		-1 AS ContactKey
,		ISNULL(a.ActivityKey, -1)
,		dcd.Is_Viable_Call
,		dcd.Is_Productive_Call
,		ISNULL(dcd.Call_Length,0)
,		ISNULL(dcd.IVR_Time,0)
,		ISNULL(dcd.Queue_Time,0)
,		ISNULL(dcd.Pending_Time,0)
,		ISNULL(dcd.Talk_Time,0)
,		ISNULL(dcd.Hold_Time,0)
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimCallDataBP dcd
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = dcd.Call_Date
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			ON c.SFDC_LeadID = dcd.SFDC_LeadID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ins
			ON ins.SourceSSID = DCD.InboundSourceSSID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ls
			ON ls.SourceSSID = dcd.LeadSourceSSID
		LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimTimeOfDay tod
			ON tod.Time24 = dcd.Call_Time
			and tod.timeofdaykey <> 86400
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity a
			ON a.SFDC_TaskID = dcd.SFDC_TaskID

WHERE	dcd.Call_Date <= @enddate AND  dcd.Call_RecordKey NOT IN (SELECT fcd.Call_RecordKey FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactCallDataBP fcd)
AND dcd.Call_RecordKey != (SELECT Call_RecordKey FROM  HC_BI_MKTG_DDS.bi_mktg_dds.FactCallDataBP where Call_RecordKey = 93316)
ORDER BY dcd.Call_RecordKey

END
GO
