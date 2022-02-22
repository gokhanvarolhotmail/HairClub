/* CreateDate: 02/21/2022 17:05:21.490 , ModifyDate: 02/21/2022 17:05:21.523 */
GO
CREATE TABLE [Audit].[dbo_datSalesCodeCenterInventory](
	[LogId] [int] NOT NULL,
	[LogUser] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogAppName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogDate] [datetime2](7) NOT NULL,
	[Action] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeCenterInventoryID] [int] NOT NULL,
	[SalesCodeCenterID] [int] NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[QuantityPar] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [dbo_datSalesCodeCenterInventory_PKC] ON [Audit].[dbo_datSalesCodeCenterInventory]
(
	[LogId] ASC,
	[SalesCodeCenterInventoryID] ASC,
	[Action] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
