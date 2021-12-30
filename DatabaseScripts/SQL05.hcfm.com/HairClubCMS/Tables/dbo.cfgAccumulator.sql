/* CreateDate: 05/05/2020 17:42:37.430 , ModifyDate: 05/05/2020 18:40:52.710 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
