/* CreateDate: 05/02/2016 14:51:05.717 , ModifyDate: 05/02/2016 15:50:01.900 */
GO
/***********************************************************************
VIEW:					[vwd_AdvertisingLatency]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		05/02/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_AdvertisingLatency] order by YearMonthNumber

***********************************************************************/
CREATE VIEW [dbo].[vwd_AdvertisingLatency]
AS


--Find dates for Rolling 2 Years

WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	--WHERE  DD.FullDate BETWEEN DATEADD(yy, -1.5, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- 1 and a half years ago
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) --2 years ago
		  AND GETUTCDATE() -- Today
),

SourceKeys AS ( SELECT Channel, [Type], SourceKey
			FROM dbo.vwChannelTypeSubtype
			GROUP BY Channel, [Type], SourceKey

),

Lead AS (SELECT FirstDateOfMonth
, YearNumber
, YearMonthNumber
	 ,	MED.Channel
	 ,	MED.[Type]
	 ,	MED.SourceKey
     ,	SUM(ISNULL(ABS(SHOWDIFF),0)) AS 'SHOWDIFF'
     ,	SUM(ISNULL(ABS(SALEDIFF),0)) AS 'SALEDIFF'
	 ,	ABS(SUM(ISNULL(ABS(SHOWDIFF),0)) - SUM(ISNULL(ABS(SALEDIFF),0))) AS 'SHOWSALEDIFF'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
INNER JOIN Rolling2Years DD
    ON FL.LeadCreationDateKey = DD.DateKey
INNER JOIN SourceKeys MED
	ON FL.SourceKey = MED.SourceKey
WHERE SHOWDIFF IS NOT NULL
GROUP BY DD.FirstDateOfMonth
       , DD.YearNumber
       , DD.YearMonthNumber
       , MED.Channel
       , MED.[Type]
	   	,	MED.SourceKey
)
--SELECT * FROM Lead

--/*

,	Diff AS (SELECT FirstDateOfMonth
		,	YearNumber
		,	YearMonthNumber
		,	Channel
		,	[Type]
		,	SHOWDIFF
		,	AGShow.AGDescription AS 'AGDescriptionShow'
		,	AGShow.AGMin AS 'AGMinShow'
		,	AGShow.AGMax AS 'AGMaxShow'
		,	AGShow.AgingGroupKey AS 'AgingGroupKeyShow'
		,	LD.SALEDIFF
		,	AGSale.AGDescription AS 'AGDescriptionSale'
		,	AGSale.AGMin AS 'AGMinSale'
		,	AGSale.AGMax AS 'AGMaxSale'
		,	AGSale.AgingGroupKey AS 'AgingGroupKeySale'
		,	LD.SHOWSALEDIFF
		,	AGSaleShowDiff.AGDescription AS 'AGDescriptionSaleShowDiff'
		,	AGSaleShowDiff.AGMin AS 'AGMinSaleShowDiff'
		,	AGSaleShowDiff.AGMax AS 'AGMaxSaleShowDiff'
		,	AGSaleShowDiff.AgingGroupKey AS 'AgingGroupKeySaleShowDiff'
		FROM Lead LD
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimAgingGroup AGShow
			ON LD.SHOWDIFF BETWEEN AGShow.AGMin AND AGShow.AGMax
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimAgingGroup AGSale
			ON LD.SALEDIFF BETWEEN AGSale.AGMin AND AGSale.AGMax
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimAgingGroup AGSaleShowDiff
			ON LD.SHOWSALEDIFF BETWEEN AGSaleShowDiff.AGMin AND AGSaleShowDiff.AGMax
		WHERE AGSale.AGGroupDescription = 'LeadsShowsSales'
)

--SELECT * FROM Diff
--/*

,	Totals AS (SELECT FirstDateOfMonth
		,	YearNumber
		,	YearMonthNumber
		,	Channel
		,	[Type]
		,	SUM(CASE WHEN AgingGroupKeyShow = 1 THEN 1 ELSE 0 END) AS 'HalfMonthShow'
		,	SUM(CASE WHEN AgingGroupKeyShow = 2 THEN 1 ELSE 0 END) AS 'OneMonthShow'
		,	SUM(CASE WHEN AgingGroupKeyShow = 3 THEN 1 ELSE 0 END) AS 'TwoMonthsShow'
		,	SUM(CASE WHEN AgingGroupKeyShow = 4 THEN 1 ELSE 0 END) AS 'ThreeMonthsShow'
		,	SUM(CASE WHEN AgingGroupKeyShow = 5 THEN 1 ELSE 0 END) AS 'FourMonthsShow'
		,	SUM(CASE WHEN AgingGroupKeyShow = 6 THEN 1 ELSE 0 END) AS 'SevenMonthsShow'
		,	SUM(CASE WHEN AgingGroupKeyShow = 7 THEN 1 ELSE 0 END) AS 'MoreThanOneYearShow'

		,	SUM(CASE WHEN AgingGroupKeyShow = 1 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeyShow = 2 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeyShow = 3 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeyShow = 4 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeyShow = 5 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeyShow = 6 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeyShow = 7 THEN 1 ELSE 0 END) AS 'ShowDiffTotal'

		,	SUM(CASE WHEN AgingGroupKeySale = 1 THEN 1 ELSE 0 END) AS 'HalfMonthSale'
		,	SUM(CASE WHEN AgingGroupKeySale = 2 THEN 1 ELSE 0 END) AS 'OneMonthSale'
		,	SUM(CASE WHEN AgingGroupKeySale = 3 THEN 1 ELSE 0 END) AS 'TwoMonthsSale'
		,	SUM(CASE WHEN AgingGroupKeySale = 4 THEN 1 ELSE 0 END) AS 'ThreeMonthsSale'
		,	SUM(CASE WHEN AgingGroupKeySale = 5 THEN 1 ELSE 0 END) AS 'FourMonthsSale'
		,	SUM(CASE WHEN AgingGroupKeySale = 6 THEN 1 ELSE 0 END) AS 'SevenMonthsSale'
		,	SUM(CASE WHEN AgingGroupKeySale = 7 THEN 1 ELSE 0 END) AS 'MoreThanOneYearSale'

		,	SUM(CASE WHEN AgingGroupKeySale = 1 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySale = 2 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySale = 3 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySale = 4 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySale = 5 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySale = 6 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySale = 7 THEN 1 ELSE 0 END) AS 'SaleDiffTotal'

		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 1 THEN 1 ELSE 0 END) AS 'HalfMonthSaleShowDiff'
		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 2 THEN 1 ELSE 0 END) AS 'OneMonthSaleShowDiff'
		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 3 THEN 1 ELSE 0 END) AS 'TwoMonthsSaleShowDiff'
		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 4 THEN 1 ELSE 0 END) AS 'ThreeMonthsSaleShowDiff'
		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 5 THEN 1 ELSE 0 END) AS 'FourMonthsSaleShowDiff'
		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 6 THEN 1 ELSE 0 END) AS 'SevenMonthsSaleShowDiff'
		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 7 THEN 1 ELSE 0 END) AS 'MoreThanOneYearSaleShowDiff'

		,	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 1 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 2 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 3 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 4 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 5 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 6 THEN 1 ELSE 0 END)
			+	SUM(CASE WHEN AgingGroupKeySaleShowDiff = 7 THEN 1 ELSE 0 END) AS 'SaleShowDiffTotal'
		FROM Diff
		GROUP BY Diff.FirstDateOfMonth
               , Diff.YearNumber
               , Diff.YearMonthNumber
               , Diff.Channel
               , Diff.[Type]
)
SELECT * FROM Totals
/*
,
[Percentage] AS (SELECT FirstDateOfMonth
			,	YearNumber
			,	YearMonthNumber
			,	Channel
			,	[Type]
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(HalfMonthShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'HalfMonthShowPercent'
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(OneMonthShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'OneMonthShowPercent'
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(TwoMonthsShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'TwoMonthsShowPercent'
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(ThreeMonthsShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'ThreeMonthsShowPercent'
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(FourMonthsShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'FourMonthsShowPercent'
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(SevenMonthsShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'SevenMonthsShowPercent'
			,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (CAST(MoreThanOneYearShow AS DECIMAL(18,4))/CAST(ShowDiffTotal AS DECIMAL(18,4))) END AS 'MoreThanOneYearShowPercent'

			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (HalfMonthSale/SaleDiffTotal) END AS 'HalfMonthSalePercent'
			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (OneMonthSale/SaleDiffTotal) END AS 'OneMonthSalePercent'
			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (TwoMonthsSale/SaleDiffTotal) END AS 'TwoMonthsSalePercent'
			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (ThreeMonthsSale/SaleDiffTotal) END AS 'ThreeMonthsSalePercent'
			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (FourMonthsSale/SaleDiffTotal) END AS 'FourMonthsSalePercent'
			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (SevenMonthsSale/SaleDiffTotal) END AS 'SevenMonthsSalePercent'
			,	CASE WHEN SaleDiffTotal = 0 THEN 0 ELSE (MoreThanOneYearSale/SaleDiffTotal) END AS 'MoreThanOneYearSalePercent'

			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (HalfMonthSaleShowDiff/SaleShowDiffTotal) END AS 'HalfMonthSaleShowDiffPercent'
			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (OneMonthSaleShowDiff/SaleShowDiffTotal) END AS 'OneMonthSaleShowDiffPercent'
			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (TwoMonthsSaleShowDiff/SaleShowDiffTotal) END AS 'TwoMonthsSaleShowDiffPercent'
			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (ThreeMonthsSaleShowDiff/SaleShowDiffTotal) END AS 'ThreeMonthsSaleShowDiffPercent'
			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (FourMonthsSaleShowDiff/SaleShowDiffTotal) END AS 'FourMonthsSaleShowDiffPercent'
			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (SevenMonthsSaleShowDiff/SaleShowDiffTotal) END AS 'SevenMonthsSaleShowDiffPercent'
			,	CASE WHEN SaleShowDiffTotal = 0 THEN 0 ELSE (MoreThanOneYearSaleShowDiff/SaleShowDiffTotal) END AS 'MoreThanOneYearSaleShowDiffPercent'
			FROM Totals
)

SELECT  Totals.Channel
	 ,	Totals.[Type]
,	Totals.FirstDateOfMonth
,	Totals.YearNumber
,	Totals.YearMonthNumber
,	HalfMonthShow
,	OneMonthShow
,	TwoMonthsShow
,	ThreeMonthsShow
,	FourMonthsShow
,	SevenMonthsShow
,	MoreThanOneYearShow
,	ShowDiffTotal
,	HalfMonthSale
,	OneMonthSale
,	TwoMonthsSale
,	ThreeMonthsSale
,	FourMonthsSale
,	SevenMonthsSale
,	MoreThanOneYearSale
,	SaleDiffTotal
,	HalfMonthSaleShowDiff
,	OneMonthSaleShowDiff
,	TwoMonthsSaleShowDiff
,	ThreeMonthsSaleShowDiff
,	FourMonthsSaleShowDiff
,	SevenMonthsSaleShowDiff
,	MoreThanOneYearSaleShowDiff
,	SaleShowDiffTotal
,	HalfMonthShowPercent
,	OneMonthShowPercent
,	TwoMonthsShowPercent
,	ThreeMonthsShowPercent
,	FourMonthsShowPercent
,	SevenMonthsShowPercent
,	MoreThanOneYearShowPercent
,	HalfMonthSalePercent
,	OneMonthSalePercent
,	TwoMonthsSalePercent
,	ThreeMonthsSalePercent
,	FourMonthsSalePercent
,	SevenMonthsSalePercent
,	MoreThanOneYearSalePercent
,	HalfMonthSaleShowDiffPercent
,	OneMonthSaleShowDiffPercent
,	TwoMonthsSaleShowDiffPercent
,	ThreeMonthsSaleShowDiffPercent
,	FourMonthsSaleShowDiffPercent
,	SevenMonthsSaleShowDiffPercent
,	MoreThanOneYearSaleShowDiffPercent
FROM Totals, [Percentage]

*/
GO
