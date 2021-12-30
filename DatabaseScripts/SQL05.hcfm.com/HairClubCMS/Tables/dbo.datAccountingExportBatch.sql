/* CreateDate: 05/05/2020 17:42:45.507 , ModifyDate: 05/05/2020 17:43:04.410 */
GO
CREATE TABLE [dbo].[datAccountingExportBatch](
	[AccountingExportBatchGUID] [uniqueidentifier] NOT NULL,
	[AccountingExportBatchTypeID] [int] NOT NULL,
	[AccountingExportBatchNumber] [int] NOT NULL,
	[BatchRunDate] [datetime] NOT NULL,
	[BatchBeginDate] [datetime] NULL,
	[BatchEndDate] [datetime] NULL,
	[BatchInvoiceDate] [datetime] NULL,
	[ExportFileName] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceAmount] [money] NOT NULL,
	[FreightAmount] [money] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datAccountingExportBatch] PRIMARY KEY CLUSTERED
(
	[AccountingExportBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
