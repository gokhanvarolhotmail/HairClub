/****** Object:  Table [ODS].[CNCT_lkpLanguage]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpLanguage]
(
	[LanguageID] [int] NULL,
	[LanguageSortOrder] [int] NULL,
	[LanguageDescription] [varchar](8000) NULL,
	[LanguageDescriptionShort] [varchar](8000) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[OnContactLanguageCode] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
