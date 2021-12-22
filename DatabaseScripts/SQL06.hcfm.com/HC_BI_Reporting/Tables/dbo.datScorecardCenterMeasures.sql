CREATE TABLE [dbo].[datScorecardCenterMeasures](
	[CenterMeasureID] [int] NULL,
	[MeasureID] [int] NULL,
	[Organization] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Measure] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datScorecardCenterMeasures_Organization_INCL] ON [dbo].[datScorecardCenterMeasures]
(
	[Organization] ASC
)
INCLUDE([CenterMeasureID],[MeasureID],[Measure]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
