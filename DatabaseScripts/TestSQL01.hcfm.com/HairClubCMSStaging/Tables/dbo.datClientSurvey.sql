/* CreateDate: 10/20/2014 07:50:33.807 , ModifyDate: 06/15/2018 05:34:05.873 */
GO
CREATE TABLE [dbo].[datClientSurvey](
	[ClientSurveyID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[BrochureID] [int] NULL,
	[HearAboutID] [int] NULL,
	[ReferredBy] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ThinningHairID] [int] NULL,
	[HairLossAge] [int] NULL,
	[ActivityOtherText] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaAffectedOtherText] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GoalOtherText] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReasonToGetHairBack] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TellAnyoneID] [int] NULL,
	[DateToGetHairBack] [datetime] NULL,
	[ResearchOtherText] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LearnedFromResearch] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApplyNonSurgicalReplacementTried] [bit] NOT NULL,
	[ApplyNonSurgicalReplacementInterested] [bit] NOT NULL,
	[ApplyHairTransplantTried] [bit] NOT NULL,
	[ApplyHairTransplantInterested] [bit] NOT NULL,
	[ApplyHairTherapiesTried] [bit] NOT NULL,
	[ApplyHairTherapiesInterested] [bit] NOT NULL,
	[ApplyOtherTried] [bit] NOT NULL,
	[ApplyOtherInterested] [bit] NOT NULL,
	[ApplyOtherText] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientSurvey] PRIMARY KEY CLUSTERED
(
	[ClientSurveyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientSurvey]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientSurvey_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datClientSurvey] CHECK CONSTRAINT [FK_datClientSurvey_datAppointment]
GO
ALTER TABLE [dbo].[datClientSurvey]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientSurvey_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientSurvey] CHECK CONSTRAINT [FK_datClientSurvey_datClient]
GO
ALTER TABLE [dbo].[datClientSurvey]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientSurvey_lkpClientSurveyHearAbout] FOREIGN KEY([HearAboutID])
REFERENCES [dbo].[lkpClientSurveyHearAbout] ([ClientSurveyHearAboutID])
GO
ALTER TABLE [dbo].[datClientSurvey] CHECK CONSTRAINT [FK_datClientSurvey_lkpClientSurveyHearAbout]
GO
