CREATE TABLE [dbo].[datSlideShow](
	[SlideShowID] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NOT NULL,
	[DayOfWeekID] [int] NOT NULL,
	[MinutesDelay] [int] NOT NULL,
	[TimeUpdate] [time](7) NOT NULL,
	[SlideShowUrl] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSlideShow] PRIMARY KEY CLUSTERED
(
	[SlideShowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSlideShow]  WITH CHECK ADD  CONSTRAINT [FK_datSlideShow_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSlideShow] CHECK CONSTRAINT [FK_datSlideShow_cfgCenter]
GO
ALTER TABLE [dbo].[datSlideShow]  WITH CHECK ADD  CONSTRAINT [FK_datSlideShow_lkpDayOfWeek] FOREIGN KEY([DayOfWeekID])
REFERENCES [dbo].[lkpDayOfWeek] ([DayOfWeekID])
GO
ALTER TABLE [dbo].[datSlideShow] CHECK CONSTRAINT [FK_datSlideShow_lkpDayOfWeek]
