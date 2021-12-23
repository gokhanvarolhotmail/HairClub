/* CreateDate: 08/15/2014 12:35:26.953 , ModifyDate: 12/07/2021 16:20:16.230 */
GO
CREATE TABLE [dbo].[lkpReportResourceImage](
	[ReportResourceImageID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ReportResourceImageName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportResourceImage] [varbinary](max) NOT NULL,
	[NorwoodScaleID] [int] NULL,
	[LudwigScaleID] [int] NULL,
	[ScalpHealthID] [int] NULL,
	[ScalpRegionID] [int] NULL,
	[EthnicityID] [int] NULL,
	[GenderID] [int] NULL,
	[MimeType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SorenessLevelID] [int] NULL,
	[SebumLevelID] [int] NULL,
	[FlakingLevelID] [int] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[RRImageCategory] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpReportResourceImage] PRIMARY KEY CLUSTERED
(
	[ReportResourceImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpEthnicity] FOREIGN KEY([EthnicityID])
REFERENCES [dbo].[lkpEthnicity] ([EthnicityID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpEthnicity]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpFlakingLevel] FOREIGN KEY([FlakingLevelID])
REFERENCES [dbo].[lkpFlakingLevel] ([FlakingLevelID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpFlakingLevel]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpGender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[lkpGender] ([GenderID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpGender]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpLudwigScale] FOREIGN KEY([LudwigScaleID])
REFERENCES [dbo].[lkpLudwigScale] ([LudwigScaleID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpLudwigScale]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpScalpHealth] FOREIGN KEY([ScalpHealthID])
REFERENCES [dbo].[lkpScalpHealth] ([ScalpHealthID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpScalpHealth]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpScalpRegion] FOREIGN KEY([ScalpRegionID])
REFERENCES [dbo].[lkpScalpRegion] ([ScalpRegionID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpScalpRegion]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpSebumLevel] FOREIGN KEY([SebumLevelID])
REFERENCES [dbo].[lkpSebumLevel] ([SebumLevelID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpSebumLevel]
GO
ALTER TABLE [dbo].[lkpReportResourceImage]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpReportResourceImage_lkpSorenessLevel] FOREIGN KEY([SorenessLevelID])
REFERENCES [dbo].[lkpSorenessLevel] ([SorenessLevelID])
GO
ALTER TABLE [dbo].[lkpReportResourceImage] CHECK CONSTRAINT [FK_lkpReportResourceImage_lkpSorenessLevel]
GO
