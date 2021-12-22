/* CreateDate: 02/14/2009 12:20:28.570 , ModifyDate: 12/03/2021 10:24:48.563 */
GO
CREATE TABLE [dbo].[cfgAccumulator](
	[AccumulatorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AccumulatorSortOrder] [int] NULL,
	[AccumulatorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDataTypeID] [int] NULL,
	[SalesOrderProcessFlag] [bit] NULL,
	[SchedulerProcessFlag] [bit] NULL,
	[SchedulerActionTypeID] [int] NULL,
	[SchedulerAdjustmentTypeID] [int] NULL,
	[AdjustARBalanceFlag] [bit] NULL,
	[AdjustContractPriceFlag] [bit] NULL,
	[AdjustContractPaidFlag] [bit] NULL,
	[IsVisibleFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsVisibleToClient] [bit] NOT NULL,
	[ClientDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgAccumulator] PRIMARY KEY CLUSTERED
(
	[AccumulatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_SalesOrderProcessFlag]  DEFAULT ((0)) FOR [SalesOrderProcessFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_SchedulerProcessFlag]  DEFAULT ((0)) FOR [SchedulerProcessFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_AdjustARBalanceFlag]  DEFAULT ((0)) FOR [AdjustARBalanceFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_AdjustContractPriceFlag]  DEFAULT ((0)) FOR [AdjustContractPriceFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_AdjustContractPaidFlag]  DEFAULT ((0)) FOR [AdjustContractPaidFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_IsVisibleFlag]  DEFAULT ((1)) FOR [IsVisibleFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  CONSTRAINT [DF_cfgAccumulator_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgAccumulator] ADD  DEFAULT ((0)) FOR [IsVisibleToClient]
GO
ALTER TABLE [dbo].[cfgAccumulator]  WITH CHECK ADD  CONSTRAINT [FK_cfgAccumulator_lkpAccumulatorActionType1] FOREIGN KEY([SchedulerActionTypeID])
REFERENCES [dbo].[lkpAccumulatorActionType] ([AccumulatorActionTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulator] CHECK CONSTRAINT [FK_cfgAccumulator_lkpAccumulatorActionType1]
GO
ALTER TABLE [dbo].[cfgAccumulator]  WITH CHECK ADD  CONSTRAINT [FK_cfgAccumulator_lkpAccumulatorAdjustmentType2] FOREIGN KEY([SchedulerAdjustmentTypeID])
REFERENCES [dbo].[lkpAccumulatorAdjustmentType] ([AccumulatorAdjustmentTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulator] CHECK CONSTRAINT [FK_cfgAccumulator_lkpAccumulatorAdjustmentType2]
GO
ALTER TABLE [dbo].[cfgAccumulator]  WITH CHECK ADD  CONSTRAINT [FK_cfgAccumulator_lkpAccumulatorDataType] FOREIGN KEY([AccumulatorDataTypeID])
REFERENCES [dbo].[lkpAccumulatorDataType] ([AccumulatorDataTypeID])
GO
ALTER TABLE [dbo].[cfgAccumulator] CHECK CONSTRAINT [FK_cfgAccumulator_lkpAccumulatorDataType]
GO
