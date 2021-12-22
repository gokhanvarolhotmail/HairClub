/* CreateDate: 04/29/2021 14:39:41.207 , ModifyDate: 04/29/2021 14:39:41.207 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
