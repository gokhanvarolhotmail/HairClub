/* CreateDate: 05/05/2020 17:42:44.940 , ModifyDate: 12/18/2021 19:00:59.413 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
