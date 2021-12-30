/* CreateDate: 10/31/2019 20:53:42.713 , ModifyDate: 11/01/2019 09:57:48.987 */
GO
CREATE TABLE [dbo].[cfgVendor](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorTypeID] [int] NOT NULL,
	[VendorSortOrder] [int] NOT NULL,
	[VendorDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[VendorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[VendorAddress1] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorAddress2] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorAddress3] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorPhone] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorFax] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorContractCounter] [int] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FactoryColor] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GPVendorID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GPVendorDescription] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorExportFileTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
