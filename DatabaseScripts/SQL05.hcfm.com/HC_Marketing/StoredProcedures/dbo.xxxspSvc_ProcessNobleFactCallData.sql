/* CreateDate: 07/01/2020 10:45:00.920 , ModifyDate: 09/09/2020 14:39:26.460 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ProcessNobleFactCallData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/8/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ProcessNobleFactCallData
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspSvc_ProcessNobleFactCallData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Insert Data into FactCallData *************************************/
INSERT INTO HC_BI_MKTG_DDS.bi_mktg_dds.FactCallData (
	CallRecordKey
,	CallDateKey
,	CallTimeKey
,	InboundSourceKey
,	ContactKey
,	ActivityKey
,	IsViableCall
,	CallLength
)
SELECT	dcd.CallRecordKey
,		d.DateKey
,		ISNULL(tod.TimeOfDayKey, -1)
,		ISNULL(ins.SourceKey, -1)
,		ISNULL(c.ContactKey, -1)
,		ISNULL(a.ActivityKey, -1)
,		dcd.IsViableCall
,		ISNULL(dcd.CallLength, 0)
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimCallData dcd
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			ON c.SFDC_LeadID = dcd.SFDC_LeadID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ins
			ON ins.SourceSSID = DCD.InboundSourceSSID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ls
			ON ls.SourceSSID = dcd.LeadSourceSSID
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = dcd.CallDate
		LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimTimeOfDay tod
			ON tod.Time24 = dcd.CallTime
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity a
			ON a.SFDC_TaskID = dcd.SFDC_TaskID
--		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactCallData fcd
--			ON fcd.CallRecordKey = dcd.CallRecordKey
--WHERE	fcd.CallRecordKey IS NULL
WHERE	dcd.CallRecordKey NOT IN (SELECT fcd.CallRecordKey FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactCallData fcd)

END
GO
