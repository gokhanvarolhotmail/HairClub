/* CreateDate: 11/18/2016 15:49:30.997 , ModifyDate: 11/18/2016 15:49:30.997 */
GO
CREATE TABLE [dbo].[Proc1_Old](
	[SalesCodeDivisionID] [int] NULL,
	[SalesCodeDivisionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[SalesCodeDepartmentDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeID] [int] NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](21, 6) NULL,
	[Discount] [money] NULL,
	[TotalTaxCalc] [money] NULL,
	[ExtendedPriceCalc] [decimal](33, 6) NULL,
	[PriceTaxCalc] [decimal](35, 6) NULL,
	[ClientFullNameCalc] [nvarchar](127) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Cashier] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConGUID] [uniqueidentifier] NULL,
	[Consultant] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConFullName] [nvarchar](127) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Stylist] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PerformerGUID] [uniqueidentifier] NULL,
	[PerformerName] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RevenueGroupID] [int] NULL,
	[RefundedTotalPrice] [money] NULL
) ON [PRIMARY]
GO
