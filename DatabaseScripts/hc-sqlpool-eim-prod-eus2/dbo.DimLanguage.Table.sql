/****** Object:  Table [dbo].[DimLanguage]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimLanguage]
(
	[LanguageKey] [int] IDENTITY(1,1) NOT NULL,
	[LanguageName] [varchar](200) NULL,
	[LanguageShortCode] [varchar](10) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NULL,
	[SourceSystem] [varchar](10) NULL,
	[Hash] [varchar](1024) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[LanguageKey] ASC
	)
)
GO
