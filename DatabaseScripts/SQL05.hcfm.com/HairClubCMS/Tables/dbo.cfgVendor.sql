/* CreateDate: 05/05/2020 17:42:37.717 , ModifyDate: 05/05/2020 18:31:42.993 */
GO
CREATE TABLE [dbo].[cfgVendor](
	[VendorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[UpdateStamp] [timestamp] NULL,
	[FactoryColor] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GPVendorID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GPVendorDescription] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorExportFileTypeID] [int] NOT NULL,
 CONSTRAINT [PK_cfgVendor] PRIMARY KEY CLUSTERED
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgVendor_VendorDescription] ON [dbo].[cfgVendor]
(
	[VendorDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgVendor_VendorDescriptionShort] ON [dbo].[cfgVendor]
(
	[VendorDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgVendor_VendorSortOrder] ON [dbo].[cfgVendor]
(
	[VendorSortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
