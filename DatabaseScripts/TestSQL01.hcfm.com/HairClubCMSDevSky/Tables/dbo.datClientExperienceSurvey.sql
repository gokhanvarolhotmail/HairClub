/* CreateDate: 02/12/2018 17:13:47.243 , ModifyDate: 02/02/2022 09:00:45.137 */
GO
CREATE TABLE [dbo].[datClientExperienceSurvey](
	[ClientExperienceSurveyID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NOT NULL,
	[CompletedDate] [datetime] NOT NULL,
	[FiveStarExperienceID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientExperienceSurvey] PRIMARY KEY CLUSTERED
(
	[ClientExperienceSurveyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExperienceSurvey_ClientGUID] ON [dbo].[datClientExperienceSurvey]
(
	[ClientGUID] ASC
)
INCLUDE([CompletedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientExperienceSurvey]  WITH CHECK ADD  CONSTRAINT [FK_datClientExperienceSurvey_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientExperienceSurvey] CHECK CONSTRAINT [FK_datClientExperienceSurvey_datClient]
GO
ALTER TABLE [dbo].[datClientExperienceSurvey]  WITH CHECK ADD  CONSTRAINT [FK_datClientExperienceSurvey_datEmployee] FOREIGN KEY([CompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datClientExperienceSurvey] CHECK CONSTRAINT [FK_datClientExperienceSurvey_datEmployee]
GO
