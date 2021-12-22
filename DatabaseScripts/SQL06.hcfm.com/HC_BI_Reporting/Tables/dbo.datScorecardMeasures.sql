CREATE TABLE [dbo].[datScorecardMeasures](
	[MeasureID] [int] IDENTITY(1,1) NOT NULL,
	[Measure] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountID] [int] NULL,
	[IncludeInDailyImportFlag] [bit] NULL,
	[ExcludeFromVirtualFlag] [bit] NULL,
	[MeasureType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeasureThresholdType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasThreshold1Flag] [bit] NULL,
	[Threshold1Calculation] [decimal](18, 2) NULL,
	[HasThreshold2Flag] [bit] NULL,
	[Threshold2Calculation] [decimal](18, 2) NULL,
	[HasThreshold3Flag] [bit] NULL,
	[Threshold3Calculation] [decimal](18, 2) NULL,
	[HasThreshold4Flag] [bit] NULL,
	[Threshold4Calculation] [decimal](18, 2) NULL,
 CONSTRAINT [PK_datScorecardMeasures] PRIMARY KEY CLUSTERED
(
	[MeasureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
