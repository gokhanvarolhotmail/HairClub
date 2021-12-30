/* CreateDate: 11/04/2019 08:18:20.367 , ModifyDate: 12/29/2021 15:38:46.253 */
GO
CREATE TABLE [dbo].[datAppointmentScorecard](
	[AppointmentScorecardID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[ScorecardCategoryID] [int] NOT NULL,
	[CompleteDate] [datetime] NOT NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datAppointmentScorecard] PRIMARY KEY CLUSTERED
(
	[AppointmentScorecardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentScorecard]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentScorecard_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datAppointmentScorecard] CHECK CONSTRAINT [FK_datAppointmentScorecard_datAppointment]
GO
ALTER TABLE [dbo].[datAppointmentScorecard]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentScorecard_datEmployee] FOREIGN KEY([CompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datAppointmentScorecard] CHECK CONSTRAINT [FK_datAppointmentScorecard_datEmployee]
GO
ALTER TABLE [dbo].[datAppointmentScorecard]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentScorecard_lkpScorecardCategory] FOREIGN KEY([ScorecardCategoryID])
REFERENCES [dbo].[lkpScorecardCategory] ([ScorecardCategoryID])
GO
ALTER TABLE [dbo].[datAppointmentScorecard] CHECK CONSTRAINT [FK_datAppointmentScorecard_lkpScorecardCategory]
GO
