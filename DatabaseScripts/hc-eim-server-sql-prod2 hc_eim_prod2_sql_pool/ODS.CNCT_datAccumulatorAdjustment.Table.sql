/****** Object:  Table [ODS].[CNCT_datAccumulatorAdjustment]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datAccumulatorAdjustment]
(
	[AccumulatorAdjustmentGUID] [varchar](8000) NULL,
	[ClientMembershipGUID] [varchar](8000) NULL,
	[SalesOrderDetailGUID] [varchar](8000) NULL,
	[AppointmentGUID] [varchar](8000) NULL,
	[AccumulatorID] [int] NULL,
	[AccumulatorActionTypeID] [int] NULL,
	[QuantityUsedOriginal] [int] NULL,
	[QuantityUsedAdjustment] [int] NULL,
	[QuantityTotalOriginal] [int] NULL,
	[QuantityTotalAdjustment] [int] NULL,
	[MoneyOriginal] [numeric](21, 6) NULL,
	[MoneyAdjustment] [numeric](21, 6) NULL,
	[DateOriginal] [date] NULL,
	[DateAdjustment] [date] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[QuantityUsedNewCalc] [int] NULL,
	[QuantityUsedChangeCalc] [int] NULL,
	[QuantityTotalNewCalc] [int] NULL,
	[QuantityTotalChangeCalc] [int] NULL,
	[MoneyNewCalc] [numeric](22, 6) NULL,
	[MoneyChangeCalc] [numeric](23, 6) NULL,
	[SalesOrderTenderGuid] [varchar](8000) NULL,
	[ClientMembershipAddOnID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
