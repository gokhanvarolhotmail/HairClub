/* CreateDate: 10/21/2015 15:24:03.080 , ModifyDate: 01/26/2018 16:30:30.973 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_PCPCounts_Rolling2Years
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		10/21/2015
------------------------------------------------------------------------
NOTES: This view is used in Datazen dashboards
01/26/2018 - RH - (#145957) Added CenterType, changed CenterSSID from 100 to 102 for Total Corporate
---------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_PCPCounts_Rolling2Years where CenterSSID = 102 (Corporate Total)
***********************************************************************/
CREATE VIEW [dbo].[vwd_PCPCounts_Rolling2Years]
AS


--Find dates for Rolling 2 Years


WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETUTCDATE() -- Today
)
SELECT  CTR.CenterSSID
,	FA.DateKey --Always first of the month
,	DATEADD(MONTH,-1,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN Rolling2Years DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort = 'C'
	AND CTR.Active = 'Y'
GROUP BY CTR.CenterSSID
,   FA.DateKey
,	DATEADD(MONTH,-1,DD.FirstDateOfMonth)
UNION
SELECT 102  --Corporate Total
,	FA.DateKey --Always first of the month
,	DATEADD(MONTH,-1,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN Rolling2Years DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort = 'C'
	AND CTR.Active = 'Y'
GROUP BY FA.DateKey
       ,	DATEADD(MONTH,-1,DD.FirstDateOfMonth)
GO
