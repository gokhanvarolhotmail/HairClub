/* CreateDate: 02/26/2017 22:34:52.887 , ModifyDate: 12/07/2021 16:20:15.913 */
GO
CREATE TABLE [dbo].[datTechnicalProfilePlacement](
	[TechnicalProfilePlacementID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[ScalpRegionID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfilePlacement] PRIMARY KEY CLUSTERED
(
	[TechnicalProfilePlacementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfilePlacement_TechnicalProfileID_ScalpRegionID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[ScalpRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfilePlacement]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfilePlacement_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePlacement] CHECK CONSTRAINT [FK_datTechnicalProfilePlacement_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfilePlacement]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfilePlacement_lkpScalpRegion] FOREIGN KEY([ScalpRegionID])
REFERENCES [dbo].[lkpScalpRegion] ([ScalpRegionID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePlacement] CHECK CONSTRAINT [FK_datTechnicalProfilePlacement_lkpScalpRegion]
GO
