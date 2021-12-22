/* CreateDate: 10/12/2018 16:54:37.500 , ModifyDate: 10/12/2018 16:54:37.500 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpSalesCodeCreation](
	[CopyFromSalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewSalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewSalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewSalesCodePrice] [money] NULL,
	[NewSalesCodeInterCompanyPrice] [money] NULL,
	[FifteenPercentDiscount] [money] NULL,
	[TwentyPercentDiscount] [money] NULL,
	[ServiceDuration] [int] NULL,
	[IsRefundable] [bit] NULL,
	[IsDiscountable] [bit] NULL,
	[Product] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSerializedInventory] [int] NULL,
	[SerialNumberRegEx] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsInventoried] [bit] NULL,
	[InventorySalesCodeID] [int] NULL,
	[Brand] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Size] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDepartment] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GeneralLedger] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuantityPerPack] [int] NULL,
	[CanOrderFlag] [bit] NULL,
	[CenterCost] [money] NULL,
	[CopyCenterPrice] [bit] NULL,
	[CopyMembershipPrice] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessedFlag] [bit] NULL,
	[ProcessedDate] [datetime] NULL
) ON [PRIMARY]
GO
