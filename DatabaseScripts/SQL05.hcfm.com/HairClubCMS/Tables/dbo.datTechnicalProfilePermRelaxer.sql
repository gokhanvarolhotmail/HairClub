/* CreateDate: 05/05/2020 17:42:53.050 , ModifyDate: 05/05/2020 18:28:46.733 */
GO
CREATE TABLE [dbo].[datTechnicalProfilePermRelaxer](
	[TechnicalProfilePermRelaxerID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfilePermRelaxer_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
