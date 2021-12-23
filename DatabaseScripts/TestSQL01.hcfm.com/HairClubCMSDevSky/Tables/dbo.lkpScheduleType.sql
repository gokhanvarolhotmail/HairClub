/* CreateDate: 10/04/2010 12:08:52.453 , ModifyDate: 12/07/2021 16:20:16.287 */
GO
CREATE TABLE [dbo].[lkpScheduleType](
	[ScheduleTypeID] [int] NOT NULL,
	[ScheduleTypeSortOrder] [int] NOT NULL,
	[ScheduleTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScheduleTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScheduleCalendarTypeID] [int] NOT NULL,
	[IsAvailableFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[CanScheduleOver] [bit] NOT NULL,
 CONSTRAINT [PK_lkpScheduleType] PRIMARY KEY CLUSTERED
(
	[ScheduleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpScheduleType] ADD  DEFAULT ((0)) FOR [IsAvailableFlag]
GO
ALTER TABLE [dbo].[lkpScheduleType] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpScheduleType] ADD  DEFAULT ((0)) FOR [CanScheduleOver]
GO
ALTER TABLE [dbo].[lkpScheduleType]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpScheduleType_lkpScheduleCalendarType] FOREIGN KEY([ScheduleCalendarTypeID])
REFERENCES [dbo].[lkpScheduleCalendarType] ([ScheduleCalendarTypeID])
GO
ALTER TABLE [dbo].[lkpScheduleType] CHECK CONSTRAINT [FK_lkpScheduleType_lkpScheduleCalendarType]
GO
