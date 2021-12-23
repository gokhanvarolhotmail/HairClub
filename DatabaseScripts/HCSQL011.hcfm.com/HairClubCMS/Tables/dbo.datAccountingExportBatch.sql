/* CreateDate: 12/31/2010 13:21:02.390 , ModifyDate: 05/26/2020 10:49:16.530 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAccountingExportBatch] ADD  DEFAULT ((0)) FOR [InvoiceAmount]
GO
ALTER TABLE [dbo].[datAccountingExportBatch] ADD  DEFAULT ((0)) FOR [FreightAmount]
GO
ALTER TABLE [dbo].[datAccountingExportBatch]  WITH CHECK ADD  CONSTRAINT [FK_datAccountingExportBatch_lkpAccountingExportBatchType] FOREIGN KEY([AccountingExportBatchTypeID])
REFERENCES [dbo].[lkpAccountingExportBatchType] ([AccountingExportBatchTypeID])
GO
ALTER TABLE [dbo].[datAccountingExportBatch] CHECK CONSTRAINT [FK_datAccountingExportBatch_lkpAccountingExportBatchType]
GO
