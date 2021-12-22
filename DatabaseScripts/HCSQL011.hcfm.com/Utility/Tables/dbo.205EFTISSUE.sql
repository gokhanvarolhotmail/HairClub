/* CreateDate: 04/29/2021 14:23:11.153 , ModifyDate: 04/29/2021 14:33:22.717 */
GO
CREATE TABLE [dbo].[205EFTISSUE](
	[InvoiceNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderGUID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TenderTypeID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreditCardLast4Digits] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApprovalCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreditCardTypeID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntrySortOrder] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
