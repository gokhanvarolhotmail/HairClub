/* CreateDate: 05/05/2020 17:42:50.250 , ModifyDate: 05/05/2020 17:43:10.613 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
