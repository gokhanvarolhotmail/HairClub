/****** Object:  Table [ODS].[CNCT_cfgVendor]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_cfgVendor]
(
	[VendorID] [int] NULL,
	[VendorTypeID] [int] NULL,
	[VendorSortOrder] [int] NULL,
	[VendorDescription] [nvarchar](max) NULL,
	[VendorDescriptionShort] [nvarchar](max) NULL,
	[VendorAddress1] [nvarchar](max) NULL,
	[VendorAddress2] [nvarchar](max) NULL,
	[VendorAddress3] [nvarchar](max) NULL,
	[VendorPhone] [nvarchar](max) NULL,
	[VendorFax] [nvarchar](max) NULL,
	[VendorContractCounter] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[FactoryColor] [nvarchar](max) NULL,
	[GPVendorID] [nvarchar](max) NULL,
	[GPVendorDescription] [nvarchar](max) NULL,
	[VendorExportFileTypeID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
