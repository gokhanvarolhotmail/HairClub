/* CreateDate: 05/05/2020 17:42:51.940 , ModifyDate: 11/05/2021 19:51:52.947 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
