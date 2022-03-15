/* CreateDate: 12/11/2017 07:01:32.340 , ModifyDate: 03/06/2022 20:38:14.717 */
GO
CREATE TABLE [dbo].[cfgScheduleHolidayTemplate](
	[ScheduleHolidayTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleHolidayTemplateDate] [date] NOT NULL,
	[StartTime] [time](0) NOT NULL,
	[EndTime] [time](0) NOT NULL,
	[CenterTypeID] [int] NOT NULL,
	[CountryID] [int] NOT NULL,
	[ScheduleTypeID] [int] NOT NULL,
	[ScheduleCalendarTypeID] [int] NOT NULL,
	[ScheduleDurationCalc]  AS (isnull(datediff(minute,[StartTime],[EndTime]),(0))),
	[IsActiveScheduleFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgScheduleHolidayTemplate] PRIMARY KEY CLUSTERED
(
	[ScheduleHolidayTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpCenterType] FOREIGN KEY([CenterTypeID])
REFERENCES [dbo].[lkpCenterType] ([CenterTypeID])
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate] CHECK CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpCenterType]
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate] CHECK CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpCountry]
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpScheduleCalendarType] FOREIGN KEY([ScheduleCalendarTypeID])
REFERENCES [dbo].[lkpScheduleCalendarType] ([ScheduleCalendarTypeID])
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate] CHECK CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpScheduleCalendarType]
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpScheduleType] FOREIGN KEY([ScheduleTypeID])
REFERENCES [dbo].[lkpScheduleType] ([ScheduleTypeID])
GO
ALTER TABLE [dbo].[cfgScheduleHolidayTemplate] CHECK CONSTRAINT [FK_cfgScheduleHolidayTemplate_lkpScheduleType]
GO
