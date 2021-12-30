/* CreateDate: 05/05/2020 17:42:38.247 , ModifyDate: 05/05/2020 17:42:58.427 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
