/****** Object:  Table [dbo].[DimGeography_copy]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimGeography_copy]
(
	[GeographyKey] [int] NULL,
	[DigitZIPCode] [varchar](8000) NULL,
	[LongitudeZIPCode] [float] NULL,
	[LatitudeZIPCode] [float] NULL,
	[ZIPCodeClassification] [varchar](8000) NULL,
	[NameOfCityOrORG] [varchar](8000) NULL,
	[FIPSCode] [int] NULL,
	[TwoLetterAbbrevForState] [varchar](8000) NULL,
	[FullNameOfStateOrTerritory] [varchar](8000) NULL,
	[FIPSCountyCode] [int] NULL,
	[NameOfCounty] [varchar](8000) NULL,
	[MetroStatisticalAreaCode] [int] NULL,
	[SingleAreaCodeForZIPCode] [int] NULL,
	[MultipleAreaCodesForZIPCode] [varchar](8000) NULL,
	[TimeZoneForZIPCode] [varchar](8000) NULL,
	[HrsDiff] [int] NULL,
	[ZIPCodeObeysDaylightSavings] [bit] NULL,
	[USPSPostOfficeName] [varchar](8000) NULL,
	[USPSAlternateNamesOfCity] [varchar](8000) NULL,
	[LocalAlternateNamesOfCity] [varchar](8000) NULL,
	[CleanCITYNameForGeocoding] [varchar](8000) NULL,
	[CleanSTATENAMEForGeocoding] [varchar](8000) NULL,
	[FIPSStateNumericCode] [int] NULL,
	[Name] [varchar](8000) NULL,
	[DMADescription] [varchar](8000) NULL,
	[DMAMarketRegion] [varchar](8000) NULL,
	[DMACode] [int] NULL,
	[DMANameNielsen] [varchar](8000) NULL,
	[DMANameInternal] [varchar](8000) NULL,
	[DMANameAlternate] [varchar](8000) NULL,
	[DWH_LoadDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[SourceSystem] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
