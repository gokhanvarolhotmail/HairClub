/* CreateDate: 10/20/2014 07:50:33.813 , ModifyDate: 10/20/2014 07:50:34.077 */
GO
CREATE TABLE [dbo].[datClientSurveyActivity](
	[ClientSurveyActivityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientSurveyID] [int] NOT NULL,
	[lkpClientSurveyActivityID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientSurveyActivity] PRIMARY KEY CLUSTERED
(
	[ClientSurveyActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientSurveyActivity]  WITH CHECK ADD  CONSTRAINT [FK_datClientSurveyActivity_datClientSurvey] FOREIGN KEY([ClientSurveyID])
REFERENCES [dbo].[datClientSurvey] ([ClientSurveyID])
GO
ALTER TABLE [dbo].[datClientSurveyActivity] CHECK CONSTRAINT [FK_datClientSurveyActivity_datClientSurvey]
GO
ALTER TABLE [dbo].[datClientSurveyActivity]  WITH CHECK ADD  CONSTRAINT [FK_datClientSurveyActivity_lkpClientSurveyActivity] FOREIGN KEY([lkpClientSurveyActivityID])
REFERENCES [dbo].[lkpClientSurveyActivity] ([ClientSurveyActivityID])
GO
ALTER TABLE [dbo].[datClientSurveyActivity] CHECK CONSTRAINT [FK_datClientSurveyActivity_lkpClientSurveyActivity]
GO
