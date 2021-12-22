/* CreateDate: 07/08/2019 12:56:41.570 , ModifyDate: 07/08/2019 12:56:41.570 */
GO
CREATE TABLE [dbo].[datInventoryAuditTransaction_PreSplit](
	[InventoryAuditTransactionID] [int] NOT NULL,
	[InventoryAuditBatchID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[IsSerialized] [bit] NOT NULL,
	[QuantityExpected] [int] NOT NULL,
	[QuantityEntered] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsExcludedFromCorrections] [bit] NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datInventoryAuditTransaction] PRIMARY KEY CLUSTERED
(
	[InventoryAuditTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
