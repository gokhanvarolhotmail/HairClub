/* CreateDate: 07/08/2019 12:59:56.210 , ModifyDate: 07/08/2019 12:59:56.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datInventoryAdjustmentDetailSerialized_PreSplit](
	[InventoryAdjustmentDetailSerializedID] [int] NOT NULL,
	[InventoryAdjustmentDetailID] [int] NOT NULL,
	[SerialNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NewSerializedInventoryStatusID] [int] NOT NULL,
	[IsScannedEntry] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[InventoryAuditTransactionSerializedID] [int] NULL,
 CONSTRAINT [PK_datInventoryAdjustmentDetailSerialized] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentDetailSerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
