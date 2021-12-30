/* CreateDate: 05/05/2020 17:42:38.583 , ModifyDate: 05/05/2020 17:42:58.463 */
GO
CREATE TABLE [dbo].[cfgAddOnAccumulator](
	[AddOnAccumulatorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddOnID] [int] NOT NULL,
	[AccumulatorID] [int] NOT NULL,
	[InitialQuantity] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgAddOnAccumulatorID] ON [dbo].[cfgAddOnAccumulator]
(
	[AddOnAccumulatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
