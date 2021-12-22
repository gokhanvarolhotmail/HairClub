CREATE TABLE [dbo].[tmp_cfgScheduleTemplate](
	[ScheduleTemplateGUID] [uniqueidentifier] NOT NULL,
	[ScheduleTemplateDayOfWeek] [int] NOT NULL,
	[CenterID] [int] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[StartTime] [time](0) NULL,
	[EndTime] [time](0) NULL,
	[ScheduleTypeID] [int] NULL,
	[ScheduleCalendarTypeID] [int] NULL,
	[ScheduleDurationCalc] [int] NOT NULL,
	[IsActiveScheduleFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
