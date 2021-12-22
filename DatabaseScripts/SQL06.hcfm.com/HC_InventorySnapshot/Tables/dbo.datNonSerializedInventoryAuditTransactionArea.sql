/* CreateDate: 12/07/2020 16:29:29.910 , ModifyDate: 12/07/2020 16:29:29.910 */
GO
CREATE TABLE [dbo].[datNonSerializedInventoryAuditTransactionArea](
	[NonSerializedInventoryAuditTransactionAreaID] [int] IDENTITY(1,1) NOT NULL,
	[NonSerializedInventoryAuditTransactionID] [int] NOT NULL,
	[InventoryAreaID] [int] NOT NULL,
	[QuantityEntered] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
