/* CreateDate: 03/06/2009 13:55:34.443 , ModifyDate: 03/04/2022 16:09:12.700 */
GO
CREATE TABLE [dbo].[datClientMembershipAccum](
	[ClientMembershipAccumGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[AccumulatorID] [int] NULL,
	[UsedAccumQuantity] [int] NULL,
	[AccumMoney] [decimal](21, 6) NULL,
	[AccumDate] [datetime] NULL,
	[TotalAccumQuantity] [int] NULL,
	[AccumQuantityRemainingCalc]  AS ([TotalAccumQuantity]-[UsedAccumQuantity]),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_datClientMembershipAccum] PRIMARY KEY CLUSTERED
(
	[ClientMembershipAccumGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CV_datClientMembershipAccum_ClientMembershipGUID] ON [dbo].[datClientMembershipAccum]
(
	[ClientMembershipGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembershipAccum_AccumulatorID] ON [dbo].[datClientMembershipAccum]
(
	[AccumulatorID] ASC
)
INCLUDE([UsedAccumQuantity],[TotalAccumQuantity],[AccumQuantityRemainingCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembershipAccum_ClientMembershipGUID_AccumID] ON [dbo].[datClientMembershipAccum]
(
	[ClientMembershipGUID] ASC,
	[AccumulatorID] ASC
)
INCLUDE([UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[ClientMembershipAddOnID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientMembershipAccum] ADD  CONSTRAINT [DF_datClientMembershipAccum_AccumMoney]  DEFAULT ((0)) FOR [AccumMoney]
GO
ALTER TABLE [dbo].[datClientMembershipAccum]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAccum_cfgAccumulator] FOREIGN KEY([AccumulatorID])
REFERENCES [dbo].[cfgAccumulator] ([AccumulatorID])
GO
ALTER TABLE [dbo].[datClientMembershipAccum] CHECK CONSTRAINT [FK_datClientMembershipAccum_cfgAccumulator]
GO
ALTER TABLE [dbo].[datClientMembershipAccum]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAccum_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClientMembershipAccum] CHECK CONSTRAINT [FK_datClientMembershipAccum_datClientMembership]
GO
ALTER TABLE [dbo].[datClientMembershipAccum]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAccum_datClientMembershipAddOn] FOREIGN KEY([ClientMembershipAddOnID])
REFERENCES [dbo].[datClientMembershipAddOn] ([ClientMembershipAddOnID])
GO
ALTER TABLE [dbo].[datClientMembershipAccum] CHECK CONSTRAINT [FK_datClientMembershipAccum_datClientMembershipAddOn]
GO
