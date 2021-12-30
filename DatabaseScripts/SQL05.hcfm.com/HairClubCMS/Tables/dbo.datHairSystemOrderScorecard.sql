/* CreateDate: 05/05/2020 17:42:55.817 , ModifyDate: 03/01/2021 17:56:32.613 */
GO
CREATE TABLE [dbo].[datHairSystemOrderScorecard](
	[HairSystemOrderScorecardID] [int] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[ScorecardCategoryID] [int] NOT NULL,
	[CompleteDate] [datetime] NOT NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL,
	[IsFailProcess] [bit] NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_datHairSystemOrderScorecard] ON [dbo].[datHairSystemOrderScorecard]
(
	[HairSystemOrderScorecardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard] ADD  CONSTRAINT [DF__datHairSy__IsFai__59033EB5]  DEFAULT ((0)) FOR [IsFailProcess]
GO
