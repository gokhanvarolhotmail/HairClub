/* CreateDate: 11/04/2019 08:18:20.210 , ModifyDate: 12/07/2021 16:20:15.993 */
GO
CREATE TABLE [dbo].[lkpScorecardMetric](
	[ScorecardMetricID] [int] IDENTITY(1,1) NOT NULL,
	[ScorecardMetricSortOrder] [int] NOT NULL,
	[ScorecardMetricDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScorecardMetricDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScorecardCategoryID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpScorecardMetric] PRIMARY KEY CLUSTERED
(
	[ScorecardMetricID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpScorecardMetric]  WITH CHECK ADD  CONSTRAINT [FK_lkpScorecardMetric_lkpScorecardCategory] FOREIGN KEY([ScorecardCategoryID])
REFERENCES [dbo].[lkpScorecardCategory] ([ScorecardCategoryID])
GO
ALTER TABLE [dbo].[lkpScorecardMetric] CHECK CONSTRAINT [FK_lkpScorecardMetric_lkpScorecardCategory]
GO
