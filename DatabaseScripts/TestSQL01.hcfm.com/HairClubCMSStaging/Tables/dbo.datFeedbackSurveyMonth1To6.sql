/* CreateDate: 10/20/2014 07:53:40.267 , ModifyDate: 10/20/2014 07:53:40.767 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datFeedbackSurveyMonth1To6](
	[FeedbackSurveyMonth1To6ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FeedbackSurveyID] [int] NOT NULL,
	[lkpFeedbackSurveyMonth1To6ID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datFeedbackSurveyMonth1To6] PRIMARY KEY CLUSTERED
(
	[FeedbackSurveyMonth1To6ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth1To6]  WITH CHECK ADD  CONSTRAINT [FK_datFeedbackSurveyMonth1To6_datFeedbackSurvey] FOREIGN KEY([FeedbackSurveyID])
REFERENCES [dbo].[datFeedbackSurvey] ([FeedbackSurveyID])
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth1To6] CHECK CONSTRAINT [FK_datFeedbackSurveyMonth1To6_datFeedbackSurvey]
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth1To6]  WITH CHECK ADD  CONSTRAINT [FK_datFeedbackSurveyMonth1To6_lkpFeedbackSurveyMonth1To6] FOREIGN KEY([lkpFeedbackSurveyMonth1To6ID])
REFERENCES [dbo].[lkpFeedbackSurveyMonth1To6] ([FeedbackSurveyMonth1To6ID])
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth1To6] CHECK CONSTRAINT [FK_datFeedbackSurveyMonth1To6_lkpFeedbackSurveyMonth1To6]
GO
