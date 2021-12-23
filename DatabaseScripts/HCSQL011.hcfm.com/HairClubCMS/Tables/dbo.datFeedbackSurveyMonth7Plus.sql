/* CreateDate: 10/20/2014 07:53:40.300 , ModifyDate: 10/20/2014 07:53:40.830 */
GO
CREATE TABLE [dbo].[datFeedbackSurveyMonth7Plus](
	[FeedbackSurveyMonth7PlusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FeedbackSurveyID] [int] NOT NULL,
	[lkpFeedbackSurveyMonth7PlusID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datFeedbackSurveyMonth7Plus] PRIMARY KEY CLUSTERED
(
	[FeedbackSurveyMonth7PlusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth7Plus]  WITH NOCHECK ADD  CONSTRAINT [FK_datFeedbackSurveyMonth7Plus_datFeedbackSurvey] FOREIGN KEY([FeedbackSurveyID])
REFERENCES [dbo].[datFeedbackSurvey] ([FeedbackSurveyID])
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth7Plus] CHECK CONSTRAINT [FK_datFeedbackSurveyMonth7Plus_datFeedbackSurvey]
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth7Plus]  WITH NOCHECK ADD  CONSTRAINT [FK_datFeedbackSurveyMonth7Plus_lkpFeedbackSurveyMonth7Plus] FOREIGN KEY([lkpFeedbackSurveyMonth7PlusID])
REFERENCES [dbo].[lkpFeedbackSurveyMonth7Plus] ([FeedbackSurveyMonth7PlusID])
GO
ALTER TABLE [dbo].[datFeedbackSurveyMonth7Plus] CHECK CONSTRAINT [FK_datFeedbackSurveyMonth7Plus_lkpFeedbackSurveyMonth7Plus]
GO
