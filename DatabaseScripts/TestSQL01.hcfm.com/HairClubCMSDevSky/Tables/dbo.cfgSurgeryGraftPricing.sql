/* CreateDate: 09/28/2009 00:02:00.170 , ModifyDate: 12/07/2021 16:20:16.103 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgSurgeryGraftPricing](
	[SurgeryGraftPricingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SurgeryGraftPricingSortOrder] [int] NULL,
	[CenterID] [int] NOT NULL,
	[GraftsMinimum] [int] NULL,
	[GraftsMaximum] [int] NULL,
	[CostPerGraft] [money] NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgSurgeryGraftPricing] PRIMARY KEY CLUSTERED
(
	[SurgeryGraftPricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSurgeryGraftPricing_GraftsMaximum] ON [dbo].[cfgSurgeryGraftPricing]
(
	[GraftsMaximum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSurgeryGraftPricing_GraftsMinimum] ON [dbo].[cfgSurgeryGraftPricing]
(
	[GraftsMinimum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSurgeryGraftPricing_SurgeryGraftPricingSortOrder] ON [dbo].[cfgSurgeryGraftPricing]
(
	[SurgeryGraftPricingSortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSurgeryGraftPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgSurgeryGraftPricing_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgSurgeryGraftPricing] CHECK CONSTRAINT [FK_cfgSurgeryGraftPricing_cfgCenter]
GO
