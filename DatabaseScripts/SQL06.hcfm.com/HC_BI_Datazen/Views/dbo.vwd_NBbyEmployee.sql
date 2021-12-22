/* CreateDate: 09/30/2015 15:43:06.610 , ModifyDate: 09/30/2015 16:58:01.470 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_NBbyEmployee
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_NBbyEmployee
***********************************************************************/
CREATE VIEW [dbo].[vwd_NBbyEmployee]
AS


WITH Rolling1Month AS (
	SELECT DateKey, DD.FullDate, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
		AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
)


SELECT DD.FullDate
	,	DD.DateKey
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	CE.CenterSSID
	,	LTRIM((CASE WHEN E1.EmployeeFullName = 'Unknown, Unknown' THEN '' ELSE E1.EmployeeFullName END) + '  ' + (CASE WHEN E2.EmployeeFullName  = 'Unknown, Unknown' THEN '' ELSE E2.EmployeeFullName END)) AS 'PerformerFullName'
	,	LTRIM(E1.EmployeeInitials + '  ' + E2.EmployeeInitials) AS 'PerformerInitials'
	,	SUM(ISNULL(FST.NB_TradAmt+FST.NB_GradAmt,0)) AS 'NB_XtrandsPlusAmt'
	,	SUM(ISNULL(FST.NB_XTRAmt,0)) AS 'NB_XtrandsAmt'
	,	SUM(ISNULL(FST.NB_EXTAmt+FST.S_PostEXTAmt,0)) AS 'NB_EXTAmt'
	,	SUM(ISNULL(FST.S_SurgeryPerformedAmt,0)) AS 'NB_SURAmt'

	,	SUM(ISNULL(FST.NB_TradCnt+FST.NB_GradCnt,0)) AS 'NB_XtrandsPlusCnt'
	,	SUM(ISNULL(FST.NB_XTRCnt,0)) AS 'NB_XTRCnt'
	,	SUM(ISNULL(FST.NB_EXTCnt+FST.S_PostEXTCnt,0)) AS 'NB_EXTCnt'
	,	SUM(ISNULL(FST.S_SurgeryPerformedCnt,0)) AS 'NB_SURCnt'
FROM HC_BI_CMS_DDS.BI_CMS_DDS.FactSalesTransaction FST
	INNER JOIN Rolling1Month DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN [HC_BI_CMS_DDS].[BI_CMS_DDS].DimEmployee E1
		ON FST.Employee1Key = E1.EmployeeKey
	INNER JOIN [HC_BI_CMS_DDS].[BI_CMS_DDS].DimEmployee E2
		ON FST.Employee2Key = E2.EmployeeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_DDs.DimCenter CE
		ON FST.CenterKey = CE.CenterKey
WHERE CE.CenterSSID LIKE '[2]%'
	AND ((FST.NB_TradAmt+FST.NB_GradAmt+FST.NB_XTRAmt+FST.NB_EXTAmt+FST.S_PostEXTAmt+S_SurgeryPerformedAmt) <> 0
	OR (FST.NB_TradCnt+FST.NB_GradCnt+FST.NB_XTRCnt+FST.NB_EXTCnt+FST.S_PostEXTCnt+S_SurgeryPerformedCnt) <> 0)
GROUP BY LTRIM((CASE WHEN E1.EmployeeFullName = 'Unknown, Unknown' THEN ''
       ELSE E1.EmployeeFullName
       END) + '  '
       + (CASE WHEN E2.EmployeeFullName = 'Unknown, Unknown' THEN ''
       ELSE E2.EmployeeFullName
       END))
       , LTRIM(E1.EmployeeInitials + '  ' + E2.EmployeeInitials)
       , DD.FullDate
       , DD.DateKey
       , DD.YearNumber
       , DD.YearMonthNumber
       , CE.CenterSSID
GO
