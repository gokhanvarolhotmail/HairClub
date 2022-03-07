/* CreateDate: 11/04/2019 08:18:20.660 , ModifyDate: 03/04/2022 16:09:12.740 */
GO
CREATE TABLE [dbo].[datHairSystemOrderScorecardMetric](
	[HairSystemOrderScorecardMetricID] [int] IDENTITY(1,1) NOT NULL,
	[HairSystemOrderScorecardID] [int] NOT NULL,
	[ScorecardMetricID] [int] NOT NULL,
	[ScorecardMetricAnswer] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datHairSystemOrderScorecardMetric] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderScorecardMetricID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecardMetric]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderScorecardMetric_datHairSystemOrderScorecard] FOREIGN KEY([HairSystemOrderScorecardID])
REFERENCES [dbo].[datHairSystemOrderScorecard] ([HairSystemOrderScorecardID])
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecardMetric] CHECK CONSTRAINT [FK_datHairSystemOrderScorecardMetric_datHairSystemOrderScorecard]
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecardMetric]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderScorecardMetric_lkpScorecardMetric] FOREIGN KEY([ScorecardMetricID])
REFERENCES [dbo].[lkpScorecardMetric] ([ScorecardMetricID])
GO
ALTER TABLE [dbo].[datHairSystemOrderScorecardMetric] CHECK CONSTRAINT [FK_datHairSystemOrderScorecardMetric_lkpScorecardMetric]
GO
