/* CreateDate: 02/26/2017 22:35:10.480 , ModifyDate: 12/07/2021 16:20:16.290 */
GO
CREATE TABLE [dbo].[datTechnicalProfileColor](
	[TechnicalProfileColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[ColorBrandID] [int] NULL,
	[ColorFormula1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ColorFormulaSize1ID] [int] NULL,
	[ColorFormula2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ColorFormulaSize2ID] [int] NULL,
	[ColorFormula3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ColorFormulaSize3ID] [int] NULL,
	[DeveloperSizeID] [int] NULL,
	[DeveloperVolumeID] [int] NULL,
	[ColorProcessingTime] [int] NULL,
	[ColorProcessingTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileColor] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileColor_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpColorBrand] FOREIGN KEY([ColorBrandID])
REFERENCES [dbo].[lkpColorBrand] ([ColorBrandID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpColorBrand]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpColorFormulaSize1] FOREIGN KEY([ColorFormulaSize1ID])
REFERENCES [dbo].[lkpColorFormulaSize] ([ColorFormulaSizeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpColorFormulaSize1]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpColorFormulaSize2] FOREIGN KEY([ColorFormulaSize2ID])
REFERENCES [dbo].[lkpColorFormulaSize] ([ColorFormulaSizeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpColorFormulaSize2]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpColorFormulaSize3] FOREIGN KEY([ColorFormulaSize3ID])
REFERENCES [dbo].[lkpColorFormulaSize] ([ColorFormulaSizeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpColorFormulaSize3]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpDeveloperSize] FOREIGN KEY([DeveloperSizeID])
REFERENCES [dbo].[lkpDeveloperSize] ([DeveloperSizeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpDeveloperSize]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpDeveloperVolume] FOREIGN KEY([DeveloperVolumeID])
REFERENCES [dbo].[lkpDeveloperVolume] ([DeveloperVolumeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpDeveloperVolume]
GO
ALTER TABLE [dbo].[datTechnicalProfileColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileColor_lkpTimeUnit] FOREIGN KEY([ColorProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileColor] CHECK CONSTRAINT [FK_datTechnicalProfileColor_lkpTimeUnit]
GO
