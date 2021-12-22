/* CreateDate: 01/04/2019 11:28:09.843 , ModifyDate: 01/04/2019 11:28:09.843 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['New Sales Codes$'](
	[CopyFromSalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewSalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewSalesCodeDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewSalesCodePrice] [money] NULL,
	[NewSalesCodeInterCompanyPrice] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FifteenPercentDiscount] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TwentyPercentDiscount] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceDuration] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRefundable] [float] NULL,
	[IsDiscountable] [float] NULL,
	[Product] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSerializedInventory] [float] NULL,
	[SerialNumberRegEx] [float] NULL,
	[IsInventoried] [float] NULL,
	[InventorySalesCodeID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Brand] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Size] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDepartment] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GeneralLedger] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuantityPerPack] [float] NULL,
	[CanOrderFlag] [float] NULL,
	[AddToDistributorFlag] [float] NULL,
	[CenterCost] [float] NULL,
	[CopyCenterPrice] [float] NULL,
	[CopyMembershipPrice] [float] NULL,
	[Case] [float] NULL
) ON [PRIMARY]
GO
