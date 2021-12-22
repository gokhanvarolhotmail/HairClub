/* CreateDate: 10/20/2014 07:53:40.247 , ModifyDate: 10/20/2014 07:53:40.797 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datFeedbackSurvey](
	[FeedbackSurveyID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[MeetObjectiveID] [int] NULL,
	[MeetObjectiveExplanation] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datFeedbackSurvey] PRIMARY KEY CLUSTERED
(
	[FeedbackSurveyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datFeedbackSurvey]  WITH CHECK ADD  CONSTRAINT [FK_datFeedbackSurvey_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datFeedbackSurvey] CHECK CONSTRAINT [FK_datFeedbackSurvey_datAppointment]
GO
ALTER TABLE [dbo].[datFeedbackSurvey]  WITH CHECK ADD  CONSTRAINT [FK_datFeedbackSurvey_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datFeedbackSurvey] CHECK CONSTRAINT [FK_datFeedbackSurvey_datClient]
GO
