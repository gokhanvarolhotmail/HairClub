/* CreateDate: 02/13/2009 16:22:06.677 , ModifyDate: 05/26/2020 10:48:43.983 */
GO
CREATE TABLE [dbo].[cfgAccumulatorJoin](
	[AccumulatorJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AccumulatorJoinSortOrder] [int] NULL,
	[AccumulatorJoinTypeID] [int] NULL,
	[SalesCodeID] [int] NULL,
	[AccumulatorID] [int] NULL,
	[AccumulatorDataTypeID] [int] NULL,
	[AccumulatorActionTypeID] [int] NULL,
	[AccumulatorAdjustmentTypeID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemOrderProcessID] [int] NULL,
	[IsEligibleForInterCompanyTransaction] [bit] NULL,
 CONSTRAINT [PK_cfgAccumulatorJoin] PRIMARY KEY CLUSTERED
(
	[AccumulatorJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] ADD  CONSTRAINT [DF_cfgAccumulatorJoin_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_cfgAccumulator] FOREIGN KEY([AccumulatorID])
REFERENCES [dbo].[cfgAccumulator] ([AccumulatorID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_cfgAccumulator]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorActionType] FOREIGN KEY([AccumulatorActionTypeID])
REFERENCES [dbo].[lkpAccumulatorActionType] ([AccumulatorActionTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorActionType]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorAdjustmentType] FOREIGN KEY([AccumulatorAdjustmentTypeID])
REFERENCES [dbo].[lkpAccumulatorAdjustmentType] ([AccumulatorAdjustmentTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorAdjustmentType]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorDataType] FOREIGN KEY([AccumulatorDataTypeID])
REFERENCES [dbo].[lkpAccumulatorDataType] ([AccumulatorDataTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorDataType]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorJoinType] FOREIGN KEY([AccumulatorJoinTypeID])
REFERENCES [dbo].[lkpAccumulatorJoinType] ([AccumulatorJoinTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_lkpAccumulatorJoinType]
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgAccumulatorJoin_lkpHairSystemOrderProcess] FOREIGN KEY([HairSystemOrderProcessID])
REFERENCES [dbo].[lkpHairSystemOrderProcess] ([HairSystemOrderProcessID])
GO
ALTER TABLE [dbo].[cfgAccumulatorJoin] CHECK CONSTRAINT [FK_cfgAccumulatorJoin_lkpHairSystemOrderProcess]
GO
