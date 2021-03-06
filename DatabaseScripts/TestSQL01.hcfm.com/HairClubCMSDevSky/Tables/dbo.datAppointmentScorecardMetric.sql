/* CreateDate: 11/04/2019 08:18:20.467 , ModifyDate: 12/29/2021 15:38:46.280 */
GO
CREATE TABLE [dbo].[datAppointmentScorecardMetric](
	[AppointmentScorecardMetricID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentScorecardID] [int] NOT NULL,
	[ScorecardMetricID] [int] NOT NULL,
	[ScorecardMetricAnswer] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datAppointmentScorecardMetric] PRIMARY KEY CLUSTERED
(
	[AppointmentScorecardMetricID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentScorecardMetric]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentScorecardMetric_datAppointmentScorecard] FOREIGN KEY([AppointmentScorecardID])
REFERENCES [dbo].[datAppointmentScorecard] ([AppointmentScorecardID])
GO
ALTER TABLE [dbo].[datAppointmentScorecardMetric] CHECK CONSTRAINT [FK_datAppointmentScorecardMetric_datAppointmentScorecard]
GO
ALTER TABLE [dbo].[datAppointmentScorecardMetric]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentScorecardMetric_lkpScorecardMetric] FOREIGN KEY([ScorecardMetricID])
REFERENCES [dbo].[lkpScorecardMetric] ([ScorecardMetricID])
GO
ALTER TABLE [dbo].[datAppointmentScorecardMetric] CHECK CONSTRAINT [FK_datAppointmentScorecardMetric_lkpScorecardMetric]
GO
