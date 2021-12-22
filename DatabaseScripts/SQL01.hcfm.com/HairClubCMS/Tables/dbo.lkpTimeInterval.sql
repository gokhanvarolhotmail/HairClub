CREATE TABLE [dbo].[lkpTimeInterval](
	[TimeIntervalID] [int] NOT NULL,
	[TimeIntervalSortOrder] [int] NOT NULL,
	[TimeIntervalDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeIntervalDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaximumValue] [int] NOT NULL,
	[MinimumValue] [int] NOT NULL,
	[Interval] [int] NOT NULL,
	[TimeUnitID] [int] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpTimeInterval] PRIMARY KEY CLUSTERED
(
	[TimeIntervalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTimeInterval] ADD  CONSTRAINT [DF_lkpTimeInterval_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpTimeInterval]  WITH CHECK ADD  CONSTRAINT [FK_lkpTimeInterval_lkpTimeUnit] FOREIGN KEY([TimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[lkpTimeInterval] CHECK CONSTRAINT [FK_lkpTimeInterval_lkpTimeUnit]
