/* CreateDate: 10/04/2010 12:08:52.467 , ModifyDate: 12/29/2021 15:38:46.077 */
GO
CREATE TABLE [dbo].[cfgScheduleTemplate](
	[ScheduleTemplateGUID] [uniqueidentifier] NOT NULL,
	[ScheduleTemplateDayOfWeek] [int] NOT NULL,
	[CenterID] [int] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[StartTime] [time](0) NULL,
	[EndTime] [time](0) NULL,
	[ScheduleTypeID] [int] NULL,
	[ScheduleCalendarTypeID] [int] NULL,
	[ScheduleDurationCalc]  AS (isnull(datediff(minute,[StartTime],[EndTime]),(0))),
	[IsActiveScheduleFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgScheduleTemplate] PRIMARY KEY CLUSTERED
(
	[ScheduleTemplateGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgScheduleTemplate_EmployeeGUID] ON [dbo].[cfgScheduleTemplate]
(
	[EmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgScheduleTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleTemplate_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgScheduleTemplate] CHECK CONSTRAINT [FK_cfgScheduleTemplate_cfgCenter]
GO
ALTER TABLE [dbo].[cfgScheduleTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleTemplate_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgScheduleTemplate] CHECK CONSTRAINT [FK_cfgScheduleTemplate_datEmployee]
GO
ALTER TABLE [dbo].[cfgScheduleTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleTemplate_lkpScheduleCalendarType] FOREIGN KEY([ScheduleCalendarTypeID])
REFERENCES [dbo].[lkpScheduleCalendarType] ([ScheduleCalendarTypeID])
GO
ALTER TABLE [dbo].[cfgScheduleTemplate] CHECK CONSTRAINT [FK_cfgScheduleTemplate_lkpScheduleCalendarType]
GO
ALTER TABLE [dbo].[cfgScheduleTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleTemplate_lkpScheduleType] FOREIGN KEY([ScheduleTypeID])
REFERENCES [dbo].[lkpScheduleType] ([ScheduleTypeID])
GO
ALTER TABLE [dbo].[cfgScheduleTemplate] CHECK CONSTRAINT [FK_cfgScheduleTemplate_lkpScheduleType]
GO
