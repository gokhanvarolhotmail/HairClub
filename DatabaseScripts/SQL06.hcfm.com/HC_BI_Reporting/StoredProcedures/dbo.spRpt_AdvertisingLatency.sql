/***********************************************************************
PROCEDURE:				spRpt_AdvertisingLatency
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			AdvertisingLatency.rdl
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		04/26/2016
------------------------------------------------------------------------
NOTES: @Type and @Subtype may be NULL; Dates are the Lead Date;
Channels:
1 - Broadcast
2 - Database
3 - Digital
4 - Miscellaneous
5 - [Print]
------------------------------------------------------------------------
CHANGE HISTORY: DROP TABLE #Lead
06/06/2016 - RH - Changed logic to show ALL SHOWS (not just SALES)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_AdvertisingLatency 3, NULL, NULL, '10/29/2014', '4/26/2016'
EXEC spRpt_AdvertisingLatency 1, 4, 4, '10/29/2014', '4/26/2016'
EXEC spRpt_AdvertisingLatency 1, 4, 5, NULL, NULL
EXEC spRpt_AdvertisingLatency 1, 4, NULL, '10/29/2014', '4/26/2016'
EXEC spRpt_AdvertisingLatency 1, NULL, NULL, '10/29/2014','4/26/2016'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_AdvertisingLatency]
(
	@ChannelID INT
	,	@TypeID INT
	,	@SubtypeID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;





/********** Create temp tables ****************************************************************/

CREATE TABLE #Media(Media NVARCHAR(50)
,	[Format] NVARCHAR(50)
,	MediaFormat NVARCHAR(50)
,	Channel NVARCHAR(50)
,	[Type] NVARCHAR(50)
,	Subtype NVARCHAR(50)
,	SourceKey INT
)

CREATE TABLE #Lead(ContactKey NVARCHAR(50)
     , FullDate DATETIME
     , CenterKey INT
     , CenterSSID INT
     , CenterDescription NVARCHAR(50)
     , CenterDescriptionNumber NVARCHAR(50)
     , SourceKey INT
     , Channel NVARCHAR(50)
     , [Type] NVARCHAR(50)
     , Subtype NVARCHAR(50)
     , Media NVARCHAR(50)
     , [Format] NVARCHAR(50)
     , Gender NVARCHAR(50)
     , OccupationDescription NVARCHAR(50)
     , EthnicityDescription NVARCHAR(50)
     , MaritalStatusDescription NVARCHAR(50)
     , HairLossTypeDescription NVARCHAR(50)
     , AgeRangeDescription NVARCHAR(50)
     , PromotionCodeDescription NVARCHAR(50)
     , SalesTypeDescription NVARCHAR(50)
     , Leads INT
     , Appointments INT
     , Shows INT
     , Sales INT
     , Activities INT
     , NoShows INT
     , NoSales INT
     , SHOWDIFF DECIMAL(18,4)
     , SALEDIFF DECIMAL(18,4)
     , SHOWSALEDIFF DECIMAL(18,4)
)

CREATE TABLE #Totals(HalfMonthShow DECIMAL(18,4)
,	OneMonthShow DECIMAL(18,4)
,	TwoMonthsShow DECIMAL(18,4)
,	ThreeMonthsShow DECIMAL(18,4)
,	FourMonthsShow DECIMAL(18,4)
,	SevenMonthsShow DECIMAL(18,4)
,	MoreThanOneYearShow DECIMAL(18,4)
,	ShowDiffTotal DECIMAL(18,4)

,	HalfMonthSale DECIMAL(18,4)
,	OneMonthSale DECIMAL(18,4)
,	TwoMonthsSale DECIMAL(18,4)
,	ThreeMonthsSale DECIMAL(18,4)
,	FourMonthsSale DECIMAL(18,4)
,	SevenMonthsSale DECIMAL(18,4)
,	MoreThanOneYearSale DECIMAL(18,4)
,	SaleDiffTotal DECIMAL(18,4)

,	HalfMonthSaleShowDiff DECIMAL(18,4)
,	OneMonthSaleShowDiff DECIMAL(18,4)
,	TwoMonthsSaleShowDiff DECIMAL(18,4)
,	ThreeMonthsSaleShowDiff DECIMAL(18,4)
,	FourMonthsSaleShowDiff DECIMAL(18,4)
,	SevenMonthsSaleShowDiff DECIMAL(18,4)
,	MoreThanOneYearSaleShowDiff DECIMAL(18,4)
,	SaleShowDiffTotal DECIMAL(18,4)
)

--Set @TypeID to 0 if NULL
IF @TypeID IS NULL
BEGIN
SET @TypeID = 0
END

--Set @SubtypeID to 0 if NULL
IF @SubtypeID IS NULL
BEGIN
SET @SubtypeID = 0
END

/********** Find SourceKeys for the Channel, Type and Subtype *********************************/

IF (@TypeID = 0 AND @SubtypeID = 0)
BEGIN
INSERT INTO #Media
SELECT Media
     , [Format]
     , MediaFormat
     , Channel
     , [Type]
     , Subtype
     , SourceKey
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwChannelTypeSubtype
WHERE ChannelID = @ChannelID
END
IF (@TypeID <> 0 AND @SubtypeID = 0)
BEGIN
INSERT INTO #Media
SELECT Media
     , [Format]
     , MediaFormat
     , Channel
     , [Type]
     , Subtype
     , SourceKey
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwChannelTypeSubtype
WHERE ChannelID = @ChannelID
AND TypeID = @TypeID
END
ELSE  --@TypeID <> 0 AND @SubtypeID <> 0
BEGIN
INSERT INTO #Media
SELECT Media
	, [Format]
	, MediaFormat
	, Channel
	, [Type]
	, [Subtype]
	, SourceKey
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwChannelTypeSubtype CTS
WHERE ChannelID = @ChannelID
AND TypeID = @TypeID
AND SubtypeID = @SubtypeID

END

--SELECT * FROM #Media

/*************** Set the variables to be used in the final select ****************************/

DECLARE @Channel NVARCHAR(50)
DECLARE @Type NVARCHAR(50)
DECLARE @Subtype NVARCHAR(50)

SET @Channel = (SELECT TOP 1 Channel FROM #Media)
IF @TypeID = 0
BEGIN
SET @Type = NULL
END

IF @SubtypeID = 0
BEGIN
SET @Subtype = NULL
END

IF @TypeID <> 0
BEGIN
SET @Type = (SELECT TOP 1 [Type]  FROM #Media)
END

IF @SubtypeID <> 0
BEGIN
SET @Subtype = (SELECT TOP 1 Subtype FROM #Media)
END

/********** Find the Details *****************************************************************/

IF ISNULL(@StartDate,0)<>0
BEGIN
INSERT INTO #Lead
SELECT ContactKey
     ,	DD.FullDate
     ,	FL.CenterKey
	 ,	CTR.CenterSSID
	 ,	CTR.CenterDescription
	 ,	CTR.CenterDescriptionNumber
     ,	FL.SourceKey
	 ,	MED.Channel
	 ,	MED.[Type]
	 ,	MED.[Subtype]
	 ,	MED.[Media]
	 ,	MED.[Format]
     ,	CASE WHEN FL.GenderKey = -1 THEN 'Unknown' WHEN FL.GenderKey = 1 THEN 'Male' ELSE 'Female' END AS 'Gender'
     ,	CASE WHEN FL.OccupationKey = -1 THEN 'Unknown' ELSE O.OccupationDescription END AS 'OccupationDescription'
	 ,	CASE WHEN FL.EthnicityKey = -1 THEN 'Unknown' ELSE E.EthnicityDescription END AS 'EthnicityDescription'
	 ,	CASE WHEN FL.MaritalStatusKey = -1 THEN 'Unknown' ELSE MS.MaritalStatusDescription END AS 'MaritalStatusDescription'
	 ,	CASE WHEN FL.HairLossTypeKey = -1 THEN 'Unknown' ELSE HLT.HairLossTypeDescription END AS 'HairLossTypeDescription'
	 ,	CASE WHEN FL.AgeRangeKey = -1 THEN 'Unknown' ELSE AR.AgeRangeDescription END AS 'AgeRangeDescription'
	 ,	CASE WHEN FL.PromotionCodeKey = -1 THEN 'Unknown' ELSE PC.PromotionCodeDescription END AS 'PromotionCodeDescription'
	 ,	CASE WHEN FL.SalesTypeKey = -1 THEN 'Unknown' ELSE ST.SalesTypeDescription END AS 'SalesTypeDescription'
     ,	Leads
     ,	Appointments
     ,	Shows
     ,	Sales
     ,	Activities
     ,	NoShows
     ,	NoSales
     ,	ABS(SHOWDIFF) AS 'SHOWDIFF'
     ,	CASE WHEN FL.SALEDIFF IS NULL THEN NULL ELSE ABS(SALEDIFF) END AS 'SALEDIFF'
	 ,	CASE WHEN FL.SALEDIFF IS NULL THEN NULL ELSE ABS(ABS(SHOWDIFF) - ABS(SALEDIFF)) END  AS 'SHOWSALEDIFF'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
    ON FL.LeadCreationDateKey = DD.DateKey
INNER JOIN #Media MED
	ON FL.SourceKey = MED.SourceKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterKey = FL.CenterKey  --There are some (-1)s so LEFT JOIN
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation O
	ON O.OccupationKey = FL.OccupationKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity E
	ON E.EthnicityKey = FL.EthnicityKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus MS
	ON MS.MaritalStatusKey = FL.MaritalStatusKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimHairLossType HLT
	ON HLT.HairLossTypeKey = FL.HairLossTypeKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange AR
	ON AR.AgeRangeKey = FL.AgeRangeKey
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC
	ON PC.PromotionCodeKey = FL.PromotionCodeKey
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType ST
	ON ST.SalesTypeKey = FL.SalesTypeKey

WHERE FL.SourceKey IN (SELECT SourceKey FROM #Media)
AND SHOWDIFF IS NOT NULL
AND DD.FullDate BETWEEN @StartDate AND @EndDate
END
ELSE IF ISNULL(@StartDate,0)=0
BEGIN
INSERT INTO #Lead
SELECT ContactKey
     ,	DD.FullDate
     ,	FL.CenterKey
	 ,	CTR.CenterSSID
	 ,	CTR.CenterDescription
	 ,	CTR.CenterDescriptionNumber
     ,	FL.SourceKey
	 ,	MED.Channel
	 ,	MED.[Type]
	 ,	MED.[Subtype]
	 ,	MED.[Media]
	 ,	MED.[Format]
     ,	CASE WHEN FL.GenderKey = -1 THEN 'Unknown' WHEN FL.GenderKey = 1 THEN 'Male' ELSE 'Female' END AS 'Gender'
     ,	CASE WHEN FL.OccupationKey = -1 THEN 'Unknown' ELSE O.OccupationDescription END AS 'OccupationDescription'
	 ,	CASE WHEN FL.EthnicityKey = -1 THEN 'Unknown' ELSE E.EthnicityDescription END AS 'EthnicityDescription'
	 ,	CASE WHEN FL.MaritalStatusKey = -1 THEN 'Unknown' ELSE MS.MaritalStatusDescription END AS 'MaritalStatusDescription'
	 ,	CASE WHEN FL.HairLossTypeKey = -1 THEN 'Unknown' ELSE HLT.HairLossTypeDescription END AS 'HairLossTypeDescription'
	 ,	CASE WHEN FL.AgeRangeKey = -1 THEN 'Unknown' ELSE AR.AgeRangeDescription END AS 'AgeRangeDescription'
	 ,	CASE WHEN FL.PromotionCodeKey = -1 THEN 'Unknown' ELSE PC.PromotionCodeDescription END AS 'PromotionCodeDescription'
	 ,	CASE WHEN FL.SalesTypeKey = -1 THEN 'Unknown' ELSE ST.SalesTypeDescription END AS 'SalesTypeDescription'
     ,	Leads
     ,	Appointments
     ,	Shows
     ,	Sales
     ,	Activities
     ,	NoShows
     ,	NoSales
     ,	ABS(SHOWDIFF) AS 'SHOWDIFF'
     ,	CASE WHEN FL.SALEDIFF IS NULL THEN NULL ELSE ABS(SALEDIFF) END AS 'SALEDIFF'
	 ,	CASE WHEN FL.SALEDIFF IS NULL THEN NULL ELSE ABS(ABS(SHOWDIFF) - ABS(SALEDIFF)) END  AS 'SHOWSALEDIFF'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
    ON FL.LeadCreationDateKey = DD.DateKey
INNER JOIN #Media MED
	ON FL.SourceKey = MED.SourceKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterKey = FL.CenterKey  --There are some (-1)s so LEFT JOIN
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation O
	ON O.OccupationKey = FL.OccupationKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity E
	ON E.EthnicityKey = FL.EthnicityKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus MS
	ON MS.MaritalStatusKey = FL.MaritalStatusKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimHairLossType HLT
	ON HLT.HairLossTypeKey = FL.HairLossTypeKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange AR
	ON AR.AgeRangeKey = FL.AgeRangeKey
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC
	ON PC.PromotionCodeKey = FL.PromotionCodeKey
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType ST
	ON ST.SalesTypeKey = FL.SalesTypeKey

WHERE FL.SourceKey IN (SELECT SourceKey FROM #Media)
AND SHOWDIFF IS NOT NULL
END

--Set Shows to 1 even if there is more than one show

UPDATE #Lead
SET Shows = 1
WHERE Shows > 1


/********** Find the Buckets for DateDiffs from the table DimAgingGroup ***************************/

SELECT SHOWDIFF
, AGShow.AGDescription AS 'AGDescriptionShow'
, AGShow.AGMin AS 'AGMinShow'
, AGShow.AGMax AS 'AGMaxShow'
, AGShow.AgingGroupKey AS 'AgingGroupKeyShow'
,	LD.SALEDIFF
, AGSale.AGDescription AS 'AGDescriptionSale'
, AGSale.AGMin AS 'AGMinSale'
, AGSale.AGMax AS 'AGMaxSale'
, AGSale.AgingGroupKey AS 'AgingGroupKeySale'
,	LD.SHOWSALEDIFF
, AGSaleShowDiff.AGDescription AS 'AGDescriptionSaleShowDiff'
, AGSaleShowDiff.AGMin AS 'AGMinSaleShowDiff'
, AGSaleShowDiff.AGMax AS 'AGMaxSaleShowDiff'
, AGSaleShowDiff.AgingGroupKey AS 'AgingGroupKeySaleShowDiff'
INTO #Diff
FROM #Lead LD
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimAgingGroup AGShow
	ON LD.SHOWDIFF BETWEEN AGShow.AGMin AND AGShow.AGMax
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimAgingGroup AGSale
	ON LD.SALEDIFF BETWEEN AGSale.AGMin AND AGSale.AGMax
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimAgingGroup AGSaleShowDiff
	ON LD.SHOWSALEDIFF BETWEEN AGSaleShowDiff.AGMin AND AGSaleShowDiff.AGMax
WHERE AGShow.AGGroupDescription = 'LeadsShowsSales'



/********** Find the Totals *************************************************************************/


INSERT INTO #Totals
SELECT SUM(CASE WHEN AgingGroupKeyShow = 1 THEN 1 ELSE 0 END) AS 'HalfMonthShow'
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

FROM #Diff

/********** Find the Percentages **********************************************************************/

SELECT CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (HalfMonthShow/ShowDiffTotal) END AS 'HalfMonthShowPercent'
,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (OneMonthShow/ShowDiffTotal) END AS 'OneMonthShowPercent'
,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (TwoMonthsShow/ShowDiffTotal) END AS 'TwoMonthsShowPercent'
,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (ThreeMonthsShow/ShowDiffTotal) END AS 'ThreeMonthsShowPercent'
,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (FourMonthsShow/ShowDiffTotal) END AS 'FourMonthsShowPercent'
,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (SevenMonthsShow/ShowDiffTotal) END AS 'SevenMonthsShowPercent'
,	CASE WHEN ShowDiffTotal = 0 THEN 0 ELSE (MoreThanOneYearShow/ShowDiffTotal) END AS 'MoreThanOneYearShowPercent'

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

INTO #Percent
FROM #Totals

/********** Final select ****************************************************************************/


SELECT  @Channel AS 'Channel'
	 ,	@Type AS [Type]
	 ,	@Subtype AS [Subtype]
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
FROM #Totals, #Percent


END
