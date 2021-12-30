/* CreateDate: 05/05/2020 17:42:41.333 , ModifyDate: 05/05/2020 17:42:59.910 */
GO
CREATE TABLE [dbo].[lkpLanguage](
	[LanguageID] [int] NOT NULL,
	[LanguageSortOrder] [int] NOT NULL,
	[LanguageDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LanguageDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL,
	[OnContactLanguageCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_lkpLanguage] ON [dbo].[lkpLanguage]
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
