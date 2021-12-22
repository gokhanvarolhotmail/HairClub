/* CreateDate: 05/03/2010 12:17:23.073 , ModifyDate: 09/16/2019 09:33:49.817 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimSalesCode](
	[SalesCodeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesCodeSSID] [int] NOT NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeTypeSSID] [int] NOT NULL,
	[SalesCodeTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ProductVendorSSID] [int] NOT NULL,
	[ProductVendorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ProductVendorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDepartmentKey] [int] NOT NULL,
	[SalesCodeDepartmentSSID] [int] NOT NULL,
	[Barcode] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceDefault] [money] NULL,
	[GLNumber] [int] NULL,
	[ServiceDuration] [int] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[SalesCodeSortOrder] [int] NULL,
 CONSTRAINT [PK_DimSalesCode] PRIMARY KEY CLUSTERED
(
	[SalesCodeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCode_RowIsCurrent_SalesCodeSSID_SalesCodeKey] ON [bi_cms_dds].[DimSalesCode]
(
	[SalesCodeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCode_SalesCodeKey] ON [bi_cms_dds].[DimSalesCode]
(
	[SalesCodeKey] ASC
)
INCLUDE([SalesCodeSSID],[SalesCodeDescription],[SalesCodeTypeDescription],[ProductVendorDescription],[Barcode],[PriceDefault],[ServiceDuration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_SalesCodeTypeSSID]  DEFAULT ((-2)) FOR [SalesCodeTypeSSID]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_ProductVendorSSID]  DEFAULT ((-2)) FOR [ProductVendorSSID]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_SalesCodeDepartmentSSID]  DEFAULT ((-2)) FOR [SalesCodeDepartmentSSID]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_Barcode]  DEFAULT ('') FOR [Barcode]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCode] ADD  CONSTRAINT [MSrepl_tran_version_default_538A11AF_8221_4E2C_A8A6_91FABADE7DA1_133575514]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
