/****** Object:  Table [dbo].[DimGeographyCopy]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimGeographyCopy]
(
	[GeographyKey] [int] NOT NULL,
	[DigitZIPCode] [varchar](10) NULL,
	[LongitudeZIPCode] [float] NULL,
	[LatitudeZIPCode] [float] NULL,
	[ZIPCodeClassification] [varchar](100) NULL,
	[NameOfCityOrORG] [varchar](200) NULL,
	[FIPSCode] [int] NULL,
	[TwoLetterAbbrevForState] [varchar](100) NULL,
	[FullNameOfStateOrTerritory] [varchar](200) NULL,
	[FIPSCountyCode] [int] NULL,
	[NameOfCounty] [varchar](100) NULL,
	[MetroStatisticalAreaCode] [int] NULL,
	[SingleAreaCodeForZIPCode] [int] NULL,
	[MultipleAreaCodesForZIPCode] [varchar](100) NULL,
	[TimeZoneForZIPCode] [varchar](100) NULL,
	[HrsDiff] [int] NULL,
	[ZIPCodeObeysDaylightSavings] [bit] NULL,
	[USPSPostOfficeName] [varchar](100) NULL,
	[USPSAlternateNamesOfCity] [varchar](320) NULL,
	[LocalAlternateNamesOfCity] [varchar](320) NULL,
	[CleanCITYNameForGeocoding] [varchar](100) NULL,
	[CleanSTATENAMEForGeocoding] [varchar](100) NULL,
	[FIPSStateNumericCode] [int] NULL,
	[Name] [varchar](200) NULL,
	[DMADescription] [varchar](100) NULL,
	[DMAMarketRegion] [varchar](100) NULL,
	[DMACode] [int] NULL,
	[DMANameNielsen] [varchar](100) NULL,
	[DMANameInternal] [varchar](100) NULL,
	[DMANameAlternate] [varchar](100) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[SourceSystem] [varchar](50) NULL,
	[Country] [varchar](100) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[GeographyKey] ASC
	)
)
GO
