/* CreateDate: 10/03/2019 23:03:41.497 , ModifyDate: 06/16/2021 23:26:52.603 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimSalesCode](
	[SalesCodeKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCode_RowIsCurrent_SalesCodeSSID_SalesCodeKey] ON [bi_cms_dds].[DimSalesCode]
(
	[SalesCodeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCode_SalesCodeKey] ON [bi_cms_dds].[DimSalesCode]
(
	[SalesCodeKey] ASC
)
INCLUDE([SalesCodeSSID],[SalesCodeDescription],[SalesCodeTypeDescription],[ProductVendorDescription],[Barcode],[PriceDefault],[ServiceDuration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
