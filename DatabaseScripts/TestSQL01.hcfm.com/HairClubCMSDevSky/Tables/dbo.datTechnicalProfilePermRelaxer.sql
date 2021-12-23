/* CreateDate: 02/26/2017 22:35:10.547 , ModifyDate: 12/07/2021 16:20:15.817 */
GO
CREATE TABLE [dbo].[datTechnicalProfilePermRelaxer](
	[TechnicalProfilePermRelaxerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[PermOwnPermBrandID] [int] NULL,
	[PermOwnPermOwnHairRods1ID] [int] NULL,
	[PermOwnPermOwnHairRods2ID] [int] NULL,
	[PermOwnProcessingTime] [int] NULL,
	[PermOwnProcessingTimeUnitID] [int] NULL,
	[PermOwnPermTechniqueID] [int] NULL,
	[PermSystemPermBrandID] [int] NULL,
	[PermSystemPermOwnHairRods1ID] [int] NULL,
	[PermSystemPermOwnHairRods2ID] [int] NULL,
	[PermSystemProcessingTime] [int] NULL,
	[PermSystemProcessingTimeUnitID] [int] NULL,
	[PermSystemPermTechniqueID] [int] NULL,
	[RelaxerBrandID] [int] NULL,
	[RelaxerStrengthID] [int] NULL,
	[RelaxerProcessingTime] [int] NULL,
	[RelaxerProcessingTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfilePermRelaxer] PRIMARY KEY CLUSTERED
(
	[TechnicalProfilePermRelaxerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfilePermRelaxer_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermBrand] FOREIGN KEY([PermOwnPermBrandID])
REFERENCES [dbo].[lkpPermBrand] ([PermBrandID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermBrand]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermBrand1] FOREIGN KEY([PermSystemPermBrandID])
REFERENCES [dbo].[lkpPermBrand] ([PermBrandID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermBrand1]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods1] FOREIGN KEY([PermOwnPermOwnHairRods1ID])
REFERENCES [dbo].[lkpPermOwnHairRods] ([PermOwnHairRodsID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods1]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods2] FOREIGN KEY([PermOwnPermOwnHairRods2ID])
REFERENCES [dbo].[lkpPermOwnHairRods] ([PermOwnHairRodsID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods2]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods3] FOREIGN KEY([PermSystemPermOwnHairRods1ID])
REFERENCES [dbo].[lkpPermOwnHairRods] ([PermOwnHairRodsID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods3]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods4] FOREIGN KEY([PermSystemPermOwnHairRods2ID])
REFERENCES [dbo].[lkpPermOwnHairRods] ([PermOwnHairRodsID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermOwnHairRods4]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermTechnique] FOREIGN KEY([PermOwnPermTechniqueID])
REFERENCES [dbo].[lkpPermTechnique] ([PermTechniqueID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermTechnique]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermTechnique1] FOREIGN KEY([PermSystemPermTechniqueID])
REFERENCES [dbo].[lkpPermTechnique] ([PermTechniqueID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpPermTechnique1]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpRelaxerBrand] FOREIGN KEY([RelaxerBrandID])
REFERENCES [dbo].[lkpRelaxerBrand] ([RelaxerBrandID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpRelaxerBrand]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpRelaxerStrength] FOREIGN KEY([RelaxerStrengthID])
REFERENCES [dbo].[lkpRelaxerStrength] ([RelaxerStrengthID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpRelaxerStrength]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimeUnit] FOREIGN KEY([PermOwnProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimeUnit]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimeUnit1] FOREIGN KEY([PermSystemProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimeUnit1]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimeUnit2] FOREIGN KEY([RelaxerProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimeUnit2]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimUnit] FOREIGN KEY([PermOwnProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimUnit]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimUnit1] FOREIGN KEY([PermSystemProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimUnit1]
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimUnit2] FOREIGN KEY([RelaxerProcessingTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfilePermRelaxer] CHECK CONSTRAINT [FK_datTechnicalProfilePermRelaxer_lkpTimUnit2]
GO
