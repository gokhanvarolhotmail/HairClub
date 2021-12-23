/* CreateDate: 10/16/2008 14:09:42.197 , ModifyDate: 12/07/2021 16:20:16.080 */
GO
CREATE TABLE [dbo].[datSchedule](
	[ScheduleGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[ScheduleDate] [date] NULL,
	[StartTime] [time](0) NULL,
	[EndTime] [time](0) NULL,
	[ScheduleSubject] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentScheduleGUID] [uniqueidentifier] NULL,
	[RecurrenceRule] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDateTimeCalc]  AS (CONVERT([datetime],[ScheduleDate],(0))+CONVERT([datetime],[StartTime],(0))),
	[EndDateTimeCalc]  AS (CONVERT([datetime],[ScheduleDate],(0))+CONVERT([datetime],[EndTime],(0))),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ScheduleTypeID] [int] NULL,
	[ScheduleCalendarTypeID] [int] NULL,
	[ScheduleDurationCalc]  AS (isnull(datediff(minute,[StartTime],[EndTime]),(0))),
 CONSTRAINT [PK_datSchedule] PRIMARY KEY CLUSTERED
(
	[ScheduleGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSchedule_CenterID_EmployeeGUID_ScheduleDate_StartTime_EndTime] ON [dbo].[datSchedule]
(
	[CenterID] ASC,
	[EmployeeGUID] ASC,
	[ScheduleDate] DESC,
	[StartTime] ASC,
	[EndTime] ASC
)
INCLUDE([ScheduleGUID],[StartDateTimeCalc],[EndDateTimeCalc],[ScheduleTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSchedule_EmployeeGUID_ScheduleDate_StartTime_EndTime] ON [dbo].[datSchedule]
(
	[EmployeeGUID] ASC,
	[ScheduleDate] DESC,
	[StartTime] ASC,
	[EndTime] ASC
)
INCLUDE([CenterID],[CreateDate],[CreateUser],[EndDateTimeCalc],[LastUpdate],[LastUpdateUser],[ParentScheduleGUID],[RecurrenceRule],[ScheduleCalendarTypeID],[ScheduleDurationCalc],[ScheduleGUID],[ScheduleSubject],[ScheduleTypeID],[StartDateTimeCalc],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSchedule_ScheduleDate_EmployeeGuid] ON [dbo].[datSchedule]
(
	[ScheduleDate] ASC,
	[EmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StartTime_EndTime_SchedDate] ON [dbo].[datSchedule]
(
	[CenterID] ASC,
	[EmployeeGUID] ASC,
	[ScheduleDate] ASC,
	[StartTime] ASC,
	[EndTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSchedule_CenterID_EmployeeGUID_ScheduleDate] ON [dbo].[datSchedule]
(
	[CenterID] ASC,
	[EmployeeGUID] ASC,
	[ScheduleDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSchedule]  WITH NOCHECK ADD  CONSTRAINT [FK_datSchedule_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSchedule] CHECK CONSTRAINT [FK_datSchedule_cfgCenter]
GO
ALTER TABLE [dbo].[datSchedule]  WITH NOCHECK ADD  CONSTRAINT [FK_datSchedule_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSchedule] CHECK CONSTRAINT [FK_datSchedule_datEmployee]
GO
ALTER TABLE [dbo].[datSchedule]  WITH NOCHECK ADD  CONSTRAINT [FK_datSchedule_lkpScheduleCalendarType] FOREIGN KEY([ScheduleCalendarTypeID])
REFERENCES [dbo].[lkpScheduleCalendarType] ([ScheduleCalendarTypeID])
GO
ALTER TABLE [dbo].[datSchedule] CHECK CONSTRAINT [FK_datSchedule_lkpScheduleCalendarType]
GO
ALTER TABLE [dbo].[datSchedule]  WITH NOCHECK ADD  CONSTRAINT [FK_datSchedule_lkpScheduleType] FOREIGN KEY([ScheduleTypeID])
REFERENCES [dbo].[lkpScheduleType] ([ScheduleTypeID])
GO
ALTER TABLE [dbo].[datSchedule] CHECK CONSTRAINT [FK_datSchedule_lkpScheduleType]
GO
