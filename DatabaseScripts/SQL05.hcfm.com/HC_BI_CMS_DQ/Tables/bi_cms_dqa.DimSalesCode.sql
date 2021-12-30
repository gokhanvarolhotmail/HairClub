/* CreateDate: 05/03/2010 12:19:13.150 , ModifyDate: 04/10/2012 14:21:12.273 */
GO
CREATE TABLE [bi_cms_dqa].[DimSalesCode](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[SalesCodeKey] [bigint] NULL,
	[SalesCodeSSID] [int] NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeTypeSSID] [int] NULL,
	[SalesCodeTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProductVendorSSID] [int] NULL,
	[ProductVendorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProductVendorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDepartmentKey] [int] NULL,
	[SalesCodeDepartmentSSID] [int] NULL,
	[Barcode] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceDefault] [money] NULL,
	[GLNumber] [int] NULL,
	[ServiceDuration] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[SalesCodeSortOrder] [int] NULL,
 CONSTRAINT [PK_DimSalesCode_1] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_SalesCodeTypeSSID_1]  DEFAULT ((-2)) FOR [SalesCodeTypeSSID]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_ProductVendorSSID_1]  DEFAULT ((-2)) FOR [ProductVendorSSID]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesCode] ADD  CONSTRAINT [DF_DimSalesCode_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
