/* CreateDate: 07/10/2020 07:50:41.807 , ModifyDate: 07/10/2020 07:50:41.807 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ProcessDuplicatedNobleCallData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/10/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ProcessDuplicatedNobleCallData
***********************************************************************/
CREATE PROCEDURE spSvc_ProcessDuplicatedNobleCallData
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	cd.CallRecordSSID
INTO	#Dupe
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimCallData cd
GROUP BY cd.CallRecordSSID
HAVING	COUNT(*) > 1


SELECT	ROW_NUMBER() OVER ( PARTITION BY cd.CallRecordSSID ORDER BY cd.CallRecordKey ) AS 'RowID'
,		cd.CallRecordKey
,		cd.CallRecordSSID
INTO	#RawData
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimCallData cd
		INNER JOIN #Dupe d
			ON d.CallRecordSSID = cd.CallRecordSSID
ORDER BY cd.CallRecordSSID
,		cd.CallRecordKey


DELETE	cd
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimCallData cd
		INNER JOIN #RawData rd
			ON rd.CallRecordKey = cd.CallRecordKey
WHERE	rd.RowID = 2


DELETE	fcd
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactCallData fcd
		INNER JOIN #RawData rd
			ON rd.CallRecordKey = fcd.CallRecordKey
WHERE	rd.RowID = 2

END
GO
