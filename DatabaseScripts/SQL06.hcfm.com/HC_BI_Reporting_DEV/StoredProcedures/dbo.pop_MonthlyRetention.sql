/***********************************************************************
PROCEDURE:				[pop_MonthlyRetention]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Warboard Manager
AUTHOR:					Rachelen Hut
------------------------------------------------------------------------
NOTES:  This table MonthlyRetention is used to find Retention for the Warboard Manager report.
------------------------------------------------------------------------
CHANGE HISTORY:
07/08/2016 - RH - (#126425) Changed Retention to be a four month rolling - Previous Month is three months previous to current month
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_MonthlyRetention]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_MonthlyRetention]

AS
BEGIN

SET ARITHABORT OFF
SET ANSI_WARNINGS OFF

DECLARE @Month INT
,	@Year INT

--SET @Month = 6 --This was for the initial population
--SET @Year = 2016

SET @Month = MONTH(GETDATE())
SET @Year = YEAR(GETDATE())

DECLARE @PCPStartDate DATETIME
,	@PCPEndDate DATETIME
,	@ConversionEndDate DATETIME


SELECT @PCPEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year))
--,	@PCPStartDate = DATEADD(MM,-2,@PCPEndDate)
,	@PCPStartDate = DATEADD(MM,-3,@PCPEndDate)
,	@ConversionEndDate = DATEADD(MINUTE,-1,@PCPEndDate)


PRINT '@PCPStartDate = ' + CAST(@PCPStartDate AS VARCHAR(12))
PRINT '@PCPEndDate = ' + CAST(@PCPEndDate AS VARCHAR(12))
PRINT '@ConversionEndDate = ' + CAST(@ConversionEndDate AS VARCHAR(12))

/************* Create temp tables *****************************************************************/

CREATE TABLE #Prev_PCPCount
(	CenterSSID INT
,	Prev_FirstDateOfMonth DATETIME
,	Prev_XTRPlusPCPCount INT
,	Prev_XTRPlusPCPMaleCount INT
,	Prev_XTRPlusPCPFemaleCount INT
)

CREATE TABLE #PCPCount
(	CenterSSID INT
,	FirstDateOfMonth DATETIME
,	XTRPlusPCPCount INT
,	XTRPlusPCPMaleCount INT
,	XTRPlusPCPFemaleCount INT
)

CREATE TABLE #Conv(
	CenterSSID INT
,	FirstDateOfMonth DATETIME
,	ConversionEndDate DATETIME
,	Total_Conv INT
,	MaleNB_BIOConvCnt INT
,	FemaleNB_BIOConvCnt INT
)

CREATE TABLE #MonthlyRetention(CenterSSID INT
,	Prev_XTRPlusPCPCount INT
,	Prev_XTRPlusPCPMaleCount INT
,	Prev_XTRPlusPCPFemaleCount INT
,	XTRPlusPCPCount INT
,	XTRPlusPCPMaleCount INT
,	XTRPlusPCPFemaleCount INT
,	Total_Conv INT
,	MaleNB_BIOConvCnt INT
,	FemaleNB_BIOConvCnt INT
,	Prev_FirstDateOfMonth DATETIME
,	FirstDateOfMonth DATETIME
,	PCPRetention DECIMAL(18,5)
,	MaleRetention DECIMAL(18,5)
,	FemaleRetention DECIMAL(18,5)
)

/*************** Find Previous PCP Counts *************************************************************/

INSERT INTO #Prev_PCPCount
SELECT  CTR.CenterSSID
--,	DATEADD(MONTH,2,DD.FirstDateOfMonth) AS 'Prev_FirstDateOfMonth'
,	DATEADD(MONTH,3,DD.FirstDateOfMonth) AS 'Prev_FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'Prev_XTRPlusPCPCount'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'Prev_XTRPlusPCPMaleCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'Prev_XTRPlusPCPFemaleCount'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[278]%'
	AND CTR.Active = 'Y'
	AND DD.FirstDateOfMonth = @PCPStartDate
GROUP BY CTR.CenterSSID
,   FA.DateKey
,	 DATEADD(MONTH,3,DD.FirstDateOfMonth)

/*************** Find PCP Counts *************************************************************/

INSERT INTO #PCPCount
SELECT  CTR.CenterSSID
,	DD.FirstDateOfMonth
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPCount'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMaleCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemaleCount'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[278]%'
	AND CTR.Active = 'Y'
	AND DD.FirstDateOfMonth = @PCPEndDate
GROUP BY CTR.CenterSSID
,   FA.DateKey
,	DD.FirstDateOfMonth

/*************  Find Conversion Counts *************************************************/

INSERT INTO #Conv
SELECT CTR.CenterSSID
	,	@PCPEndDate AS 'FirstDateOfMonth'
	,	@ConversionEndDate AS 'ConversionEndDate'
	,	SUM(FST.NB_BIOConvCnt) AS 'Total_Conv' --BIO only
	,	SUM(CASE WHEN CLT.GenderSSID = 1 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'MaleNB_BIOConvCnt'
	,	SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'FemaleNB_BIOConvCnt'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON DD.DateKey = FST.OrderDateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON CTR.CenterKey = FST.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
WHERE DD.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
	AND (FST.NB_BIOConvCnt <> 0)
GROUP BY CTR.CenterSSID

/******* Populate the temp table #MonthlyRetention ***********************************************/

INSERT INTO #MonthlyRetention
SELECT PCP.CenterSSID
     ,	PREV.Prev_XTRPlusPCPCount
	 ,	PREV.Prev_XTRPlusPCPMaleCount
	 ,	PREV.Prev_XTRPlusPCPFemaleCount
     ,	PCP.XTRPlusPCPCount
	 ,	PCP.XTRPlusPCPMaleCount
	 ,	PCP.XTRPlusPCPFemaleCount
     ,	CONV.Total_Conv
	 ,	CONV.MaleNB_BIOConvCnt
	 ,	CONV.FemaleNB_BIOConvCnt
     --,	DATEADD(MM,-3,PREV.Prev_FirstDateOfMonth) AS 'Prev_FirstDateOfMonth'		--One month previous for Rev
     --,	DATEADD(MM,-1,PCP.FirstDateOfMonth) AS 'FirstDateOfMonth'					--One month previous for Rev
	 ,	DATEADD(MM,-4,PREV.Prev_FirstDateOfMonth) AS 'Prev_FirstDateOfMonth'		--One month previous for Rev
     ,	DATEADD(MM,-1,PCP.FirstDateOfMonth) AS 'FirstDateOfMonth'					--One month previous for Rev
	 ,	[dbo].[Retention](PREV.Prev_XTRPlusPCPCount, PCP.XTRPlusPCPCount, CONV.Total_Conv, DATEADD(MM,-3,PREV.Prev_FirstDateOfMonth), PCP.FirstDateOfMonth) AS 'PCPRetention'
	 ,	dbo.[Retention](PREV.Prev_XTRPlusPCPMaleCount, PCP.XTRPlusPCPMaleCount,  CONV.MaleNB_BIOConvCnt, DATEADD(MM,-3,PREV.Prev_FirstDateOfMonth), PCP.FirstDateOfMonth) AS 'MaleRetention'
	,	dbo.[Retention](PREV.Prev_XTRPlusPCPFemaleCount, PCP.XTRPlusPCPFemaleCount,  CONV.FemaleNB_BIOConvCnt, DATEADD(MM,-3,PREV.Prev_FirstDateOfMonth), PCP.FirstDateOfMonth) AS 'FemaleRetention'
FROM #PCPCount PCP
INNER JOIN #Prev_PCPCount PREV
	ON PREV.CenterSSID = PCP.CenterSSID
	AND PCP.FirstDateOfMonth = PREV.Prev_FirstDateOfMonth
INNER JOIN #Conv CONV
	ON CONV.CenterSSID = PCP.CenterSSID
	AND CONV.FirstDateOfMonth = PCP.FirstDateOfMonth

--Remove unused records  --before the merge
DELETE FROM MonthlyRetention
WHERE PCPRetention = '0.00000'
	OR PCPRetention IS NULL

--Merge records with Target and Source --Populate the table MonthlyRetention
MERGE MonthlyRetention AS Target
USING (SELECT CenterSSID
			,	Prev_XTRPlusPCPCount
			,	Prev_XTRPlusPCPMaleCount
			,	Prev_XTRPlusPCPFemaleCount

			,	XTRPlusPCPCount
			,	XTRPlusPCPMaleCount
			,	XTRPlusPCPFemaleCount

			,	Total_Conv
			,	MaleNB_BIOConvCnt
			,	FemaleNB_BIOConvCnt

            ,	Prev_FirstDateOfMonth
            ,	FirstDateOfMonth
            ,	[PCPRetention]
			,	[MaleRetention]
			,	[FemaleRetention]
		FROM #MonthlyRetention
		GROUP BY CenterSSID
			,	Prev_XTRPlusPCPCount
			,	Prev_XTRPlusPCPMaleCount
			,	Prev_XTRPlusPCPFemaleCount

			,	XTRPlusPCPCount
			,	XTRPlusPCPMaleCount
			,	XTRPlusPCPFemaleCount

			,	Total_Conv
			,	MaleNB_BIOConvCnt
			,	FemaleNB_BIOConvCnt

            ,	Prev_FirstDateOfMonth
            ,	FirstDateOfMonth
            ,	PCPRetention
			,	MaleRetention
			,	FemaleRetention

	) AS Source
ON (Target.CenterSSID = Source.CenterSSID
		AND Target.Prev_FirstDateOfMonth = Source.Prev_FirstDateOfMonth
		AND Target.FirstDateOfMonth = Source.FirstDateOfMonth
	)
WHEN MATCHED THEN
	UPDATE SET Target.CenterSSID = Source.CenterSSID
	,	Target.Prev_XTRPlusPCPCount = Source.Prev_XTRPlusPCPCount
	,	Target.Prev_XTRPlusPCPMaleCount = Source.Prev_XTRPlusPCPMaleCount
	,	Target.Prev_XTRPlusPCPFemaleCount = Source.Prev_XTRPlusPCPFemaleCount

	,	Target.XTRPlusPCPCount = Source.XTRPlusPCPCount
	,	Target.XTRPlusPCPMaleCount = Source.XTRPlusPCPMaleCount
	,	Target.XTRPlusPCPFemaleCount = Source.XTRPlusPCPFemaleCount

	,	Target.Total_Conv = Source.Total_Conv
	,	Target.MaleNB_BIOConvCnt = Source.MaleNB_BIOConvCnt
	,	Target.FemaleNB_BIOConvCnt = Source.FemaleNB_BIOConvCnt


	,	Target.Prev_FirstDateOfMonth = Source.Prev_FirstDateOfMonth
	,	Target.FirstDateOfMonth = Source.FirstDateOfMonth
	,	Target.PCPRetention = Source.PCPRetention
	,	Target.MaleRetention= Source.MaleRetention
	,	Target.FemaleRetention= Source.FemaleRetention

WHEN NOT MATCHED BY TARGET THEN
	INSERT( CenterSSID
			, Prev_XTRPlusPCPCount
			, Prev_XTRPlusPCPMaleCount
			, Prev_XTRPlusPCPFemaleCount
			, XTRPlusPCPCount
			, XTRPlusPCPMaleCount
			, XTRPlusPCPFemaleCount
			, Total_Conv
			, MaleNB_BIOConvCnt
			, FemaleNB_BIOConvCnt

			, Prev_FirstDateOfMonth
			, FirstDateOfMonth
			, PCPRetention
			, MaleRetention
			, FemaleRetention
			)
	VALUES( Source.CenterSSID
            , Source.Prev_XTRPlusPCPCount
			, Source.Prev_XTRPlusPCPMaleCount
			, Source.Prev_XTRPlusPCPFemaleCount
			, Source.XTRPlusPCPCount
			, Source.XTRPlusPCPMaleCount
			, Source.XTRPlusPCPFemaleCount
			, Source.Total_Conv
			, Source.MaleNB_BIOConvCnt
			, Source.FemaleNB_BIOConvCnt

			, Source.Prev_FirstDateOfMonth
			, Source.FirstDateOfMonth
			, Source.PCPRetention
			, Source.MaleRetention
			, Source.FemaleRetention
			)
;

--Remove unused records  --after the merge
DELETE FROM MonthlyRetention
WHERE PCPRetention = '0.00000'
	OR PCPRetention IS NULL


END
