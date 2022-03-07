/* CreateDate: 11/04/2019 08:18:20.160 , ModifyDate: 03/04/2022 16:09:12.643 */
GO
CREATE TABLE [dbo].[lkpScorecardCategory](
	[ScorecardCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ScorecardCategorySortOrder] [int] NOT NULL,
	[ScorecardCategoryDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScorecardCategoryDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpScorecardCategory] PRIMARY KEY CLUSTERED
(
	[ScorecardCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
