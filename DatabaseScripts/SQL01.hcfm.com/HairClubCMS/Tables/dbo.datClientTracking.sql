CREATE TABLE [dbo].[datClientTracking](
	[ClientTrackingID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[TrackingDate] [datetime] NOT NULL,
	[ExtAMTimestamp] [datetime] NULL,
	[ExtPMTimestamp] [datetime] NULL,
	[LaserTimestamp] [datetime] NULL,
	[IsExtAMApplicable] [bit] NOT NULL,
	[IsExtPMApplicable] [bit] NOT NULL,
	[IsLaserApplicable] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientTracking] PRIMARY KEY CLUSTERED
(
	[ClientTrackingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientTracking]  WITH CHECK ADD  CONSTRAINT [FK_datClientTracking_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientTracking] CHECK CONSTRAINT [FK_datClientTracking_datClient]
