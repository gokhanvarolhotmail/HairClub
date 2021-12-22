/* CreateDate: 03/18/2014 08:05:08.840 , ModifyDate: 05/26/2020 10:49:28.833 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgCenterHoursException](
	[CenterHoursExceptionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[DayOfWeekID] [int] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_CenterHoursException] PRIMARY KEY CLUSTERED
(
	[CenterHoursExceptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterHoursException]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterHoursException_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterHoursException] CHECK CONSTRAINT [FK_cfgCenterHoursException_cfgCenter]
GO
ALTER TABLE [dbo].[cfgCenterHoursException]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterHoursException_lkpDayOfWeek] FOREIGN KEY([DayOfWeekID])
REFERENCES [dbo].[lkpDayOfWeek] ([DayOfWeekID])
GO
ALTER TABLE [dbo].[cfgCenterHoursException] CHECK CONSTRAINT [FK_cfgCenterHoursException_lkpDayOfWeek]
GO
