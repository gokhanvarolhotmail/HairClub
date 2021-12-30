/* CreateDate: 05/05/2020 17:42:51.050 , ModifyDate: 05/05/2020 17:43:11.787 */
GO
CREATE TABLE [dbo].[datInventoryTransaction](
	[InventoryTransactionGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[SalesCodeCenterID] [int] NULL,
	[InventoryTransactionTypeID] [int] NULL,
	[InventoryTransactionDate] [datetime] NULL,
	[QuantityAdjustment] [int] NULL,
	[ResetQuantityFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemHoldReasonID] [int] NULL,
 CONSTRAINT [PK_datInventoryTransaction] PRIMARY KEY CLUSTERED
(
	[InventoryTransactionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
