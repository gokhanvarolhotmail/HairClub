/* CreateDate: 03/05/2014 16:35:06.423 , ModifyDate: 03/05/2014 16:35:06.423 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCTransOriginal](
	[SalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaxRate1] [float] NULL,
	[TaxRate2] [float] NULL,
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientFullNameCalc] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [float] NULL,
	[ClientMembershipGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterFeeBatchStatusDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RunDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EFTAccountTypeID] [float] NULL,
	[EFTAccountTypeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EFTStatusID] [float] NULL,
	[FeePayCycleID] [float] NULL,
	[CreditCardTypeID] [float] NULL,
	[AccountNumberLast4Digits] [float] NULL,
	[BankName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankPhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankRoutingNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EFTProcessorToken] [float] NULL,
	[BankAccountNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountExpiration] [datetime] NULL,
	[Amount] [float] NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [float] NULL,
	[IsTaxExempt] [float] NULL,
	[IsFrozen] [float] NULL,
	[ClientIdentifier] [float] NULL,
	[CenterFeeBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[F30] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
