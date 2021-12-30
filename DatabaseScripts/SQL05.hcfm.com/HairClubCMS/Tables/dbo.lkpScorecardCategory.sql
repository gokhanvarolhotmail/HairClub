/* CreateDate: 05/05/2020 17:42:51.293 , ModifyDate: 05/05/2020 17:43:11.820 */
GO
CREATE TABLE [dbo].[lkpScorecardCategory](
	[ScorecardCategoryID] [int] NOT NULL,
	[ScorecardCategorySortOrder] [int] NOT NULL,
	[ScorecardCategoryDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScorecardCategoryDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_lkpScorecardCategory] ON [dbo].[lkpScorecardCategory]
(
	[ScorecardCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
