/* CreateDate: 05/05/2020 17:42:46.727 , ModifyDate: 02/09/2022 19:01:05.343 */
GO
CREATE TABLE [dbo].[datAccountingExportBatchDetail](
	[AccountingExportBatchDetailGUID] [uniqueidentifier] NOT NULL,
	[AccountingExportBatchGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderTransactionGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[FreightAmount] [money] NULL,
	[InventoryShipmentGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
 CONSTRAINT [PK_datAccountingExportBatchDetail] PRIMARY KEY CLUSTERED
(
	[AccountingExportBatchDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
