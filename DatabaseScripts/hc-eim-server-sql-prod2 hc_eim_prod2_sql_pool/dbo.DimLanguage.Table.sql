/****** Object:  Table [dbo].[DimLanguage]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimLanguage]
(
	[LanguageKey] [int] IDENTITY(1,1) NOT NULL,
	[LanguageName] [nvarchar](50) NULL,
	[Hash] [varchar](256) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
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
