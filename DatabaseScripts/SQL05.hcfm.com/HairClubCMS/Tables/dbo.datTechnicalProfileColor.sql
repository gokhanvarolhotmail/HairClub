/* CreateDate: 05/05/2020 17:42:52.590 , ModifyDate: 05/05/2020 18:28:46.610 */
GO
CREATE TABLE [dbo].[datTechnicalProfileColor](
	[TechnicalProfileColorID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfileColor_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
