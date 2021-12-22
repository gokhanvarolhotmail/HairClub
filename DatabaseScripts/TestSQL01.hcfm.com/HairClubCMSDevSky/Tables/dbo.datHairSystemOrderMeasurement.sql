/* CreateDate: 10/04/2010 12:08:46.290 , ModifyDate: 12/07/2021 16:20:16.153 */
GO
CREATE TABLE [dbo].[datHairSystemOrderMeasurement](
	[HairSystemOrderMeasurementGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[StartingPointMeasurement] [decimal](10, 4) NULL,
	[CircumferenceMeasurement] [decimal](10, 4) NULL,
	[FrontToBackMeasurement] [decimal](10, 4) NULL,
	[EarToEarOverFrontMeasurement] [decimal](10, 4) NULL,
	[EarToEarOverTopMeasurement] [decimal](10, 4) NULL,
	[SideburnToSideburnMeasurement] [decimal](10, 4) NULL,
	[TempleToTempleMeasurement] [decimal](10, 4) NULL,
	[NapeAreaMeasurement] [decimal](10, 4) NULL,
	[FrontLaceMeasurement] [decimal](10, 4) NULL,
	[HairSystemRecessionID] [int] NULL,
	[AreSideburnsAndTemplesLaceFlag] [bit] NOT NULL,
	[SideburnTemplateDiagram] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datHairSystemOrderMeasurement] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderMeasurementGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrderMeasurement_HairSystemOrderGUID] ON [dbo].[datHairSystemOrderMeasurement]
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemOrderMeasurement]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderMeasurement_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrderMeasurement] CHECK CONSTRAINT [FK_datHairSystemOrderMeasurement_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datHairSystemOrderMeasurement]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderMeasurement_lkpHairSystemRecession] FOREIGN KEY([HairSystemRecessionID])
REFERENCES [dbo].[lkpHairSystemRecession] ([HairSystemRecessionID])
GO
ALTER TABLE [dbo].[datHairSystemOrderMeasurement] CHECK CONSTRAINT [FK_datHairSystemOrderMeasurement_lkpHairSystemRecession]
GO
