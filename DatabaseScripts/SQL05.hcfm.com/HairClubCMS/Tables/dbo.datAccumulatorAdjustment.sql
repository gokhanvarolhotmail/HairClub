/* CreateDate: 05/05/2020 17:42:48.440 , ModifyDate: 05/05/2020 18:41:04.313 */
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
	[QuantityUsedChangeCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityUsedAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then  -((1)*isnull([QuantityUsedAdjustment],(0))) when [AccumulatorActionTypeID]=(3) then isnull([QuantityUsedAdjustment],(0))-isnull([QuantityUsedOriginal],(0)) else (0) end),
	[QuantityTotalNewCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityTotalOriginal],(0))+isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then isnull([QuantityTotalOriginal],(0))-isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([QuantityTotalAdjustment],(0)) else (0) end),
	[QuantityTotalChangeCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([QuantityTotalAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then  -((1)*isnull([QuantityTotalAdjustment],(0))) when [AccumulatorActionTypeID]=(3) then isnull([QuantityTotalAdjustment],(0))-isnull([QuantityTotalOriginal],(0)) else (0) end),
	[MoneyNewCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([MoneyOriginal],(0))+isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then isnull([MoneyOriginal],(0))-isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(3) then isnull([MoneyAdjustment],(0)) else (0) end),
	[MoneyChangeCalc]  AS (case when [AccumulatorActionTypeID]=(1) then isnull([MoneyAdjustment],(0)) when [AccumulatorActionTypeID]=(2) then  -((1)*isnull([MoneyAdjustment],(0))) when [AccumulatorActionTypeID]=(3) then isnull([MoneyAdjustment],(0))-isnull([MoneyOriginal],(0)) else (0) end),
	[SalesOrderTenderGuid] [uniqueidentifier] NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_datAccumulatorAdjustment] PRIMARY KEY CLUSTERED
(
	[AccumulatorAdjustmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datAccumulatorAdjustment_LastUpdate] ON [dbo].[datAccumulatorAdjustment]
(
	[LastUpdate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccumulatorAdjustment_SalesOrderDetailGUID] ON [dbo].[datAccumulatorAdjustment]
(
	[SalesOrderDetailGUID] ASC
)
INCLUDE([AccumulatorID],[MoneyAdjustment],[QuantityTotalChangeCalc],[MoneyChangeCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
