CREATE TABLE [dbo].[datTechnicalProfileBio](
	[TechnicalProfileBioID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[HairSystemID] [int] NULL,
	[AdhesiveFront1ID] [int] NULL,
	[AdhesiveFront2ID] [int] NULL,
	[AdhesivePerimeter1ID] [int] NULL,
	[AdhesivePerimeter2ID] [int] NULL,
	[AdhesivePerimeter3ID] [int] NULL,
	[RemovalProcessID] [int] NULL,
	[AdhesiveSolventID] [int] NULL,
	[IsClientUsingOwnHairline] [bit] NULL,
	[DistanceHairlineToNose] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastTemplateDate] [datetime] NULL,
	[LastTrimDate] [datetime] NULL,
	[ApplicationDuration] [int] NULL,
	[ApplicationTimeUnitID] [int] NULL,
	[FullServiceDuration] [int] NULL,
	[FullServiceTimeUnitID] [int] NULL,
	[OtherServiceSalesCodeID] [int] NULL,
	[OtherServiceDuration] [int] NULL,
	[OtherServiceTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsHairOrderReviewRequired] [bit] NULL,
	[IsHairSystemColorRequired] [bit] NULL,
	[IsHairSystemHighlightRequired] [bit] NULL,
 CONSTRAINT [PK_datTechnicalProfileBio] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileBioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileBio_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_cfgHairSystem]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_cfgSalesCode] FOREIGN KEY([OtherServiceSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_cfgSalesCode]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesiveFront1] FOREIGN KEY([AdhesiveFront1ID])
REFERENCES [dbo].[lkpAdhesiveFront] ([AdhesiveFrontID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesiveFront1]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesiveFront2] FOREIGN KEY([AdhesiveFront2ID])
REFERENCES [dbo].[lkpAdhesiveFront] ([AdhesiveFrontID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesiveFront2]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesivePerimeter1] FOREIGN KEY([AdhesivePerimeter1ID])
REFERENCES [dbo].[lkpAdhesivePerimeter] ([AdhesivePerimeterID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesivePerimeter1]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesivePerimeter2] FOREIGN KEY([AdhesivePerimeter2ID])
REFERENCES [dbo].[lkpAdhesivePerimeter] ([AdhesivePerimeterID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesivePerimeter2]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesivePerimeter3] FOREIGN KEY([AdhesivePerimeter3ID])
REFERENCES [dbo].[lkpAdhesivePerimeter] ([AdhesivePerimeterID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesivePerimeter3]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesiveSolvent] FOREIGN KEY([AdhesiveSolventID])
REFERENCES [dbo].[lkpAdhesiveSolvent] ([AdhesiveSolventID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpAdhesiveSolvent]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpRemovalProcess] FOREIGN KEY([RemovalProcessID])
REFERENCES [dbo].[lkpRemovalProcess] ([RemovalProcessID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpRemovalProcess]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpTimeUnit] FOREIGN KEY([ApplicationTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpTimeUnit]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpTimeUnit1] FOREIGN KEY([FullServiceTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpTimeUnit1]
GO
ALTER TABLE [dbo].[datTechnicalProfileBio]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileBio_lkpTimeUnit2] FOREIGN KEY([OtherServiceTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileBio] CHECK CONSTRAINT [FK_datTechnicalProfileBio_lkpTimeUnit2]
