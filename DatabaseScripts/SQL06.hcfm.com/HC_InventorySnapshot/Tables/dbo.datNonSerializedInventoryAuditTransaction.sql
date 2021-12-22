CREATE TABLE [dbo].[datNonSerializedInventoryAuditTransaction](
	[NonSerializedInventoryAuditTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[NonSerializedInventoryAuditBatchID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[QuantityExpected] [int] NOT NULL,
	[IsExcludedFromCorrections] [bit] NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
