/****** Object:  Table [dbo].[DimSalesCode]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesCode]
(
	[SalesCodeKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeID] [int] NULL,
	[SalesCodeDescription] [nvarchar](50) NOT NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) NOT NULL,
	[SalesCodeTypeID] [int] NOT NULL,
	[SalesCodeTypeDescription] [nvarchar](50) NOT NULL,
	[SalesCodeTypeDescriptionShort] [nvarchar](10) NOT NULL,
	[ProductVendorID] [int] NULL,
	[ProductVendorDescription] [nvarchar](50) NULL,
	[ProductVendorDescriptionShort] [nvarchar](10) NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[Barcode] [nvarchar](25) NULL,
	[PriceDefault] [money] NULL,
	[GLNumber] [int] NULL,
	[ServiceDuration] [int] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[SalesCodeID] ASC
	)
)
GO
