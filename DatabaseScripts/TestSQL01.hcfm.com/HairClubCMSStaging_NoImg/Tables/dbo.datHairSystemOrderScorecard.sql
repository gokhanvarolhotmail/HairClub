/* CreateDate: 11/04/2019 08:18:20.553 , ModifyDate: 12/28/2021 09:20:54.547 */
GO
CREATE TABLE [dbo].[datHairSystemOrderScorecard](
	[HairSystemOrderScorecardID] [int] IDENTITY(1,1) NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[ScorecardCategoryID] [int] NOT NULL,
	[CompleteDate] [datetime] NOT NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsFailProcess] [bit] NOT NULL,
 CONSTRAINT [PK_datHairSystemOrderScorecard] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderScorecardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard] ADD  DEFAULT ((0)) FOR [IsFailProcess]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderScorecard_datEmployee] FOREIGN KEY([CompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard] CHECK CONSTRAINT [FK_datHairSystemOrderScorecard_datEmployee]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderScorecard_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard] CHECK CONSTRAINT [FK_datHairSystemOrderScorecard_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderScorecard_lkpScorecardCategory] FOREIGN KEY([ScorecardCategoryID])
REFERENCES [dbo].[lkpScorecardCategory] ([ScorecardCategoryID])
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecard] CHECK CONSTRAINT [FK_datHairSystemOrderScorecard_lkpScorecardCategory]
GO
