CREATE TABLE [dbo].[datClientSurveyGoal](
	[ClientSurveyGoalID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientSurveyID] [int] NOT NULL,
	[lkpClientSurveyGoalID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientSurveyGoal] PRIMARY KEY CLUSTERED
(
	[ClientSurveyGoalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientSurveyGoal]  WITH CHECK ADD  CONSTRAINT [FK_datClientSurveyGoal_datClientSurvey] FOREIGN KEY([ClientSurveyID])
REFERENCES [dbo].[datClientSurvey] ([ClientSurveyID])
GO
ALTER TABLE [dbo].[datClientSurveyGoal] CHECK CONSTRAINT [FK_datClientSurveyGoal_datClientSurvey]
GO
ALTER TABLE [dbo].[datClientSurveyGoal]  WITH CHECK ADD  CONSTRAINT [FK_datClientSurveyGoal_lkpClientSurveyGoal] FOREIGN KEY([lkpClientSurveyGoalID])
REFERENCES [dbo].[lkpClientSurveyGoal] ([ClientSurveyGoalID])
GO
ALTER TABLE [dbo].[datClientSurveyGoal] CHECK CONSTRAINT [FK_datClientSurveyGoal_lkpClientSurveyGoal]
