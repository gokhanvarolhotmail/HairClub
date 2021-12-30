/* CreateDate: 05/03/2010 12:17:23.210 , ModifyDate: 11/21/2019 15:17:45.897 */
GO
CREATE TABLE [bi_cms_dds].[DimSalesOrderType](
	[SalesOrderTypeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesOrderTypeSSID] [int] NOT NULL,
	[SalesOrderTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimSalesOrderType] PRIMARY KEY CLUSTERED
(
	[SalesOrderTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderType_RowIsCurrent_SalesOrderTypeSSID_SalesOrderTypeKey] ON [bi_cms_dds].[DimSalesOrderType]
(
	[SalesOrderTypeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesOrderTypeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderType_SalesOrderTypeKey] ON [bi_cms_dds].[DimSalesOrderType]
(
	[SalesOrderTypeKey] ASC
)
INCLUDE([SalesOrderTypeSSID],[SalesOrderTypeDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimSalesOrderType] ADD  CONSTRAINT [DF_DimSalesOrderType_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesOrderType] ADD  CONSTRAINT [DF_DimSalesOrderType_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesOrderType] ADD  CONSTRAINT [DF_DimSalesOrderType_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimSalesOrderType] ADD  CONSTRAINT [MSrepl_tran_version_default_F4DC74EF_C17E_4BC8_AAC8_5DB882F78DB7_229575856]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
