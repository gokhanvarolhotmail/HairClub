/* CreateDate: 02/04/2009 07:47:04.280 , ModifyDate: 12/07/2021 16:20:15.993 */
GO
CREATE TABLE [dbo].[datAccumulatorAdjustment](
	[AccumulatorAdjustmentGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[SalesOrderDetailGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[AccumulatorID] [int] NULL,
	[AccumulatorActionTypeID] [int] NULL,
	[QuantityUsedOriginal] [int] NULL,
	[QuantityUsedAdjustment] [int] NULL,
	[QuantityTotalOriginal] [int] NULL,
	[QuantityTotalAdjustment] [int] NULL,
	[MoneyOriginal] [decimal](21, 6) NULL,
	[MoneyAdjustment] [decimal](21, 6) NULL,
	[DateOriginal] [date] NULL,
	[DateAdjustment] [date] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[QuantityUsedNewCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityUsedOriginal],(0))+isnull([QuantityUsedAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then isnull([QuantityUsedOriginal],(0))-isnull([QuantityUsedAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([QuantityUsedAdjustment],(0)) else (0) end),
	[QuantityUsedChangeCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityUsedAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then  -(1)*isnull([QuantityUsedAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([QuantityUsedAdjustment],(0))-isnull([QuantityUsedOriginal],(0)) else (0) end),
	[QuantityTotalNewCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityTotalOriginal],(0))+isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then isnull([QuantityTotalOriginal],(0))-isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([QuantityTotalAdjustment],(0)) else (0) end),
	[QuantityTotalChangeCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then  -(1)*isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([QuantityTotalAdjustment],(0))-isnull([QuantityTotalOriginal],(0)) else (0) end),
	[MoneyNewCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([MoneyOriginal],(0))+isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then isnull([MoneyOriginal],(0))-isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([MoneyAdjustment],(0)) else (0) end),
	[MoneyChangeCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then  -(1)*isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([MoneyAdjustment],(0))-isnull([MoneyOriginal],(0)) else (0) end),
	[SalesOrderTenderGuid] [uniqueidentifier] NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_datAccumulatorAdjustment] PRIMARY KEY CLUSTERED
(
	[AccumulatorAdjustmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccumulatorAdjustment_LastUpdate] ON [dbo].[datAccumulatorAdjustment]
(
	[LastUpdate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccumulatorAdjustment_SalesOrderDetailGUID] ON [dbo].[datAccumulatorAdjustment]
(
	[SalesOrderDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_cfgAccumulator] FOREIGN KEY([AccumulatorID])
REFERENCES [dbo].[cfgAccumulator] ([AccumulatorID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_cfgAccumulator]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_datAppointment]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembership]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembershipAddOn] FOREIGN KEY([ClientMembershipAddOnID])
REFERENCES [dbo].[datClientMembershipAddOn] ([ClientMembershipAddOnID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembershipAddOn]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_datSalesOrderDetail] FOREIGN KEY([SalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_datSalesOrderDetail]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_datSalesOrderTender] FOREIGN KEY([SalesOrderTenderGuid])
REFERENCES [dbo].[datSalesOrderTender] ([SalesOrderTenderGUID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_datSalesOrderTender]
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_lkpAccumulatorActionType] FOREIGN KEY([AccumulatorActionTypeID])
REFERENCES [dbo].[lkpAccumulatorActionType] ([AccumulatorActionTypeID])
GO
ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_lkpAccumulatorActionType]
GO
