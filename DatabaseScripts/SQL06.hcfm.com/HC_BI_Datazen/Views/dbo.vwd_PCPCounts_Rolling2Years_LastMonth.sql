/* CreateDate: 10/21/2015 15:31:30.630 , ModifyDate: 02/16/2016 11:11:05.097 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_PCPCounts_Rolling2Years_LastMonth
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		10/21/2015
------------------------------------------------------------------------
NOTES: This view is used in Datazen dashboards

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_PCPCounts_Rolling2Years_LastMonth WHERE CenterSSID = 100 ORDER BY CenterSSID, FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vwd_PCPCounts_Rolling2Years_LastMonth]
AS


--Find dates for Rolling 2 Years


WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETUTCDATE()
)
SELECT  CTR.CenterSSID
,	FA.DateKey --Always first of the month
,	DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN Rolling2Years DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '2%'
	AND CTR.Active = 'Y'
GROUP BY CTR.CenterSSID
,   FA.DateKey
,	DATEADD(MONTH,0,DD.FirstDateOfMonth)
UNION
SELECT 100
,	FA.DateKey --Always first of the month
,	DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
INNER JOIN Rolling2Years DD
ON FA.DateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '2%'
AND CTR.Active = 'Y'
GROUP BY FA.DateKey
,	DATEADD(MONTH,0,DD.FirstDateOfMonth)
GO
