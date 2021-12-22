CREATE TABLE [dbo].[tmpThreshold](
	[MeasureID] [float] NULL,
	[Measure] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Account] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IncludeInDailyImportFlag] [bit] NOT NULL,
	[MeasureThresholdType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasThreshold1Flag] [bit] NOT NULL,
	[Threshold1Calculation] [float] NULL,
	[HasThreshold2Flag] [bit] NOT NULL,
	[Threshold2Calculation] [float] NULL,
	[HasThreshold3Flag] [bit] NOT NULL,
	[Threshold3Calculation] [float] NULL,
	[HasThreshold4Flag] [bit] NOT NULL,
	[Threshold4Calculation] [float] NULL
) ON [PRIMARY]
